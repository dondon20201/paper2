# strip_public_comments.R — dispatch 016, Part A
# Removes comments from the code shipped in the PUBLIC replication copy
# (C:\Dev\Git-For-Metacognition-Paper). paper2 keeps every comment; this tool
# only ever writes the public versions. It is NEVER published: `tools/` is on
# the public-copy exclusion list with cowork/, BRIEF.md, CLAUDE.md,
# PROGRESS.md and README.md.
#
# R code is stripped with R's own parser (getParseData COMMENT tokens), never
# a regex, so a `#` inside a string or backticked name is never touched.
#   *.R    every COMMENT token
#   *.qmd  COMMENT tokens inside ```{r} chunks, EXCEPT tokens starting `#|`
#          (Quarto chunk options); comment lines in the YAML front matter;
#          whole-line HTML comments. Prose, inline `r` code and chunk headers
#          are never changed.
#   .gitignore, .gitattributes, *.yml  lines whose first non-space char is #
# In R code (files and chunks) a line emptied by a deletion is dropped,
# trailing whitespace left behind is trimmed, runs of 2+ blank lines collapse
# to 1 and blank lines at the start or end of the code are dropped (never
# inside a multi-line string literal).
#
# Usage (base R only; --vanilla keeps renv from activating):
#   Rscript --vanilla tools/strip_public_comments.R strip SRC DEST [SRC DEST ...]
#   Rscript --vanilla tools/strip_public_comments.R check BEFORE AFTER [...]
# `strip` writes DEST (may equal SRC) as LF/UTF-8 and prints removal counts.
# `check` runs guards C.0-C.4 on each pair and exits 1 if any fails:
#   C.0 shape   (no parser) AFTER = BEFORE with lines deleted and trailing
#               `#...` cut, nothing added or rewritten
#   C.1 code    non-COMMENT token stream (type + text) identical and parsed
#               expressions identical; no COMMENT left (qmd: only `#|`)
#   C.2 options qmd `#|` lines identical: count, text, order
#   C.3 prose   qmd lines outside chunks, YAML comments, HTML comments identical
#   C.4 config  non-comment lines identical, in order; no comment line left
# Render (C.5), provenance (C.6) and the grep (C.7) are run outside this tool;
# the full procedure is in cowork/REPORT.md (dispatch 016).

# ---- text I/O (byte-exact, LF only) ----------------------------------------
read_text <- function(path) {
  bytes <- readBin(path, "raw", file.size(path))
  if (any(bytes == as.raw(13L))) stop("CR byte in ", path, " (expect LF only)")
  txt <- rawToChar(bytes)
  Encoding(txt) <- "UTF-8"
  if (!validUTF8(txt)) stop("invalid UTF-8 in ", path)
  lines <- if (nzchar(txt)) strsplit(txt, "\n", fixed = TRUE)[[1]] else character(0)
  list(lines = lines, final_nl = endsWith(txt, "\n"))
}

write_text <- function(lines, final_nl, path) {
  txt <- paste(lines, collapse = "\n")
  if (final_nl && length(lines)) txt <- paste0(txt, "\n")
  writeBin(charToRaw(enc2utf8(txt)), path)
}

file_kind <- function(path) {
  b <- basename(path)
  if (grepl("\\.[Rr]$", b)) return("r")
  if (grepl("\\.qmd$", b)) return("qmd")
  if (b %in% c(".gitignore", ".gitattributes") || grepl("\\.ya?ml$", b)) return("config")
  stop("unsupported file type: ", path)
}

# ---- R code ------------------------------------------------------------------
# terminal tokens in source order (empty data frame for code with no tokens)
r_tokens <- function(lines) {
  pd <- getParseData(parse(text = lines, keep.source = TRUE))
  if (is.null(pd)) {
    return(data.frame(line1 = integer(0), line2 = integer(0),
                      token = character(0), text = character(0)))
  }
  pd <- pd[pd$terminal, ]
  pd[order(pd$line1, pd$col1), c("line1", "line2", "token", "text")]
}

# lines strictly after the opening line of a multi-line string literal: they
# belong to the string's value, so blank-line collapsing must not touch them
string_body_lines <- function(tok) {
  s <- tok[tok$token == "STR_CONST" & tok$line2 > tok$line1, ]
  unlist(Map(function(a, b) seq(a + 1L, b), s$line1, s$line2), use.names = FALSE)
}

# `keep`: COMMENT tokens starting with this prefix survive (qmd: "#|")
strip_r <- function(lines, keep = NULL) {
  if (!length(lines)) return(list(lines = lines, removed = 0L, kept = 0L))
  tok <- r_tokens(lines)
  com <- tok[tok$token == "COMMENT", ]
  survive <- if (is.null(keep)) rep(FALSE, nrow(com)) else startsWith(com$text, keep)
  drop <- com[!survive, ]
  # a comment always runs to end of line, so at most one per line
  stopifnot(all(drop$line1 == drop$line2), !anyDuplicated(drop$line1))
  for (k in seq_len(nrow(drop))) {
    i <- drop$line1[k]
    if (!endsWith(lines[i], drop$text[k])) stop("comment text mismatch on line ", i)
    code <- substr(lines[i], 1L, nchar(lines[i]) - nchar(drop$text[k]))
    lines[i] <- sub("[ \t]+$", "", code)
  }
  is_blank <- !nzchar(trimws(lines))
  keep_line <- !(seq_along(lines) %in% drop$line1 & is_blank)
  collapsible <- is_blank & !(seq_along(lines) %in% string_body_lines(tok))
  prev_blank <- FALSE
  for (i in seq_along(lines)) {
    if (!keep_line[i]) next
    if (collapsible[i] && prev_blank) keep_line[i] <- FALSE
    prev_blank <- collapsible[i]
  }
  # a removed header block leaves its following blank line at the very top
  body <- which(keep_line & !collapsible)
  if (length(body)) {
    keep_line[seq_along(lines) < min(body) | seq_along(lines) > max(body)] <- FALSE
  }
  list(lines = lines[keep_line], removed = nrow(drop), kept = sum(survive))
}

# ---- qmd structure -----------------------------------------------------------
# Labels every line: yaml / yaml_comment / fence / chunk / html / prose.
# Stops on anything it does not understand rather than guessing.
segment_qmd <- function(lines) {
  n <- length(lines)
  kind <- rep("prose", n)
  if (n && lines[1] == "---") {
    end <- which(lines[-1] %in% c("---", "..."))[1] + 1L
    if (is.na(end)) stop("unterminated YAML front matter")
    body <- seq_len(end - 2L) + 1L
    kind[c(1L, end)] <- "yaml"
    kind[body] <- ifelse(grepl("^\\s*#", lines[body]), "yaml_comment", "yaml")
    # a block scalar could hold `#` lines that are content, not comments
    if (any(grepl("[|>][-+0-9]*\\s*$", lines[body]))) stop("YAML block scalar present")
  }
  in_chunk <- FALSE
  for (i in which(kind == "prose")) {
    l <- lines[i]
    if (grepl("^\\s*```", l)) {
      if (!in_chunk && grepl("^```\\{r([ ,][^}]*)?\\}\\s*$", l)) {
        in_chunk <- TRUE
      } else if (in_chunk && l == "```") {
        in_chunk <- FALSE
      } else {
        stop("unsupported code fence on line ", i, ": ", l)
      }
      kind[i] <- "fence"
    } else if (in_chunk) {
      kind[i] <- "chunk"
    }
  }
  if (in_chunk) stop("unterminated code chunk")
  i <- 1L
  while (i <= n) {
    if (kind[i] == "prose" && grepl("<!--", lines[i], fixed = TRUE)) {
      if (!grepl("^\\s*<!--", lines[i])) stop("inline HTML comment on line ", i)
      j <- i
      while (j <= n && !grepl("-->", lines[j], fixed = TRUE)) j <- j + 1L
      if (j > n || !grepl("-->\\s*$", lines[j])) stop("HTML comment not whole-line at ", i)
      if (any(kind[i:j] != "prose")) stop("HTML comment crosses a chunk at ", i)
      kind[i:j] <- "html"
      i <- j
    } else if (kind[i] == "prose" && grepl("-->", lines[i], fixed = TRUE)) {
      stop("stray --> on line ", i)
    }
    i <- i + 1L
  }
  kind
}

# chunk interiors as a list of line-index vectors, in order
chunk_blocks <- function(kind) {
  r <- rle(kind == "chunk")
  ends <- cumsum(r$lengths)
  starts <- ends - r$lengths + 1L
  Map(seq, starts[r$values], ends[r$values])
}

strip_qmd <- function(lines) {
  kind <- segment_qmd(lines)
  out <- character(0)
  removed <- 0L
  kept <- 0L
  i <- 1L
  while (i <= length(lines)) {
    if (kind[i] == "chunk") {
      j <- i
      while (j < length(lines) && kind[j + 1L] == "chunk") j <- j + 1L
      s <- strip_r(lines[i:j], keep = "#|")
      out <- c(out, s$lines)
      removed <- removed + s$removed
      kept <- kept + s$kept
      i <- j + 1L
      next
    }
    if (!kind[i] %in% c("yaml_comment", "html")) out <- c(out, lines[i])
    i <- i + 1L
  }
  list(lines = out, removed = removed, kept = kept,
       yaml = sum(kind == "yaml_comment"), html_lines = sum(kind == "html"),
       html_blocks = sum(rle(kind == "html")$values))
}

strip_config <- function(lines) {
  com <- grepl("^\\s*#", lines)
  list(lines = lines[!com], removed = sum(com))
}

strip_file <- function(src, dest) {
  x <- read_text(src)
  k <- file_kind(src)
  s <- switch(k, r = strip_r(x$lines), qmd = strip_qmd(x$lines), config = strip_config(x$lines))
  write_text(s$lines, x$final_nl, dest)
  msg <- switch(k,
    r = sprintf("%d COMMENT tokens removed", s$removed),
    qmd = sprintf("%d chunk COMMENT tokens removed, %d `#|` kept; %d YAML comment lines; %d HTML comment block(s) / %d lines",
                  s$removed, s$kept, s$yaml, s$html_blocks, s$html_lines),
    config = sprintf("%d comment lines removed", s$removed))
  cat(sprintf("STRIP %s: %s; lines %d -> %d\n", src, msg, length(x$lines), length(s$lines)))
  invisible(s)
}

# ---- guards ------------------------------------------------------------------
# C.0, parser-free: walk BEFORE; each AFTER line must equal the next BEFORE
# line, or be it with a trailing `#...` (and the space before it) cut off.
# BEFORE lines skipped on the way must be blank, `#` lines, or HTML comment.
check_shape <- function(b, a, kind) {
  html <- if (kind == "qmd") segment_qmd(b) == "html" else rep(FALSE, length(b))
  deletable <- !nzchar(trimws(b)) | grepl("^\\s*#", b) | html
  i <- 1L
  for (al in a) {
    repeat {
      if (i > length(b)) return(FALSE)
      bl <- b[i]
      i <- i + 1L
      if (identical(al, bl)) break
      cut <- startsWith(bl, al) && !grepl("\\s$", al) &&
        grepl("^\\s*#", substr(bl, nchar(al) + 1L, nchar(bl)))
      if (cut) break
      if (!deletable[i - 1L]) return(FALSE)
    }
  }
  all(deletable[seq_len(length(b) - i + 1L) + i - 1L])
}

code_equal <- function(b, a) {
  tb <- r_tokens(b)
  ta <- r_tokens(a)
  nb <- tb[tb$token != "COMMENT", c("token", "text")]
  na <- ta[ta$token != "COMMENT", c("token", "text")]
  same_tok <- identical(unname(as.list(nb)), unname(as.list(na)))
  same_ast <- identical(parse(text = b, keep.source = FALSE),
                        parse(text = a, keep.source = FALSE))
  list(ok = same_tok && same_ast, n_tok = nrow(nb),
       com_before = tb$text[tb$token == "COMMENT"],
       com_after = ta$text[ta$token == "COMMENT"])
}

check_pair <- function(before, after) {
  k <- file_kind(before)
  b <- read_text(before)
  a <- read_text(after)
  res <- c(C.0 = check_shape(b$lines, a$lines, k) && b$final_nl == a$final_nl)
  info <- character(0)
  if (k == "r") {
    ce <- code_equal(b$lines, a$lines)
    res["C.1"] <- ce$ok && length(ce$com_after) == 0L
    info <- sprintf("%d code tokens identical=%s; COMMENT %d -> %d",
                    ce$n_tok, ce$ok, length(ce$com_before), length(ce$com_after))
  } else if (k == "qmd") {
    kb <- segment_qmd(b$lines)
    ka <- segment_qmd(a$lines)
    cb <- chunk_blocks(kb)
    ca <- chunk_blocks(ka)
    ok <- length(cb) == length(ca)
    removed <- 0L
    opt_b <- character(0)
    opt_a <- character(0)
    if (ok) for (m in seq_along(cb)) {
      ce <- code_equal(b$lines[cb[[m]]], a$lines[ca[[m]]])
      ok <- ok && ce$ok && all(startsWith(ce$com_after, "#|"))
      removed <- removed + sum(!startsWith(ce$com_before, "#|"))
      opt_b <- c(opt_b, ce$com_before[startsWith(ce$com_before, "#|")])
      opt_a <- c(opt_a, ce$com_after)
    }
    res["C.1"] <- ok
    res["C.2"] <- identical(opt_b, opt_a)
    other <- function(lines, kind) lines[!kind %in% c("chunk", "yaml_comment", "html")]
    res["C.3"] <- identical(other(b$lines, kb), other(a$lines, ka)) &&
      !any(ka %in% c("yaml_comment", "html"))
    info <- sprintf("%d chunks; chunk COMMENT removed %d; `#|` %d -> %d; YAML comment %d -> %d; HTML lines %d -> %d",
                    length(cb), removed, length(opt_b), length(opt_a),
                    sum(kb == "yaml_comment"), sum(ka == "yaml_comment"),
                    sum(kb == "html"), sum(ka == "html"))
  } else {
    com_b <- grepl("^\\s*#", b$lines)
    com_a <- grepl("^\\s*#", a$lines)
    res["C.4"] <- identical(b$lines[!com_b], a$lines) && !any(com_a)
    info <- sprintf("comment lines %d -> %d; %d setting lines identical=%s",
                    sum(com_b), sum(com_a), sum(!com_b), identical(b$lines[!com_b], a$lines))
  }
  verdict <- paste(sprintf("%s %s", names(res), ifelse(res, "PASS", "FAIL")), collapse = " | ")
  cat(sprintf("CHECK %s: %s | %s\n", after, verdict, info))
  all(res)
}

# ---- command line ------------------------------------------------------------
if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  mode <- args[1]
  paths <- args[-1]
  if (!mode %in% c("strip", "check") || !length(paths) || length(paths) %% 2L) {
    stop("usage: strip|check A1 B1 [A2 B2 ...]")
  }
  from <- paths[c(TRUE, FALSE)]
  to <- paths[c(FALSE, TRUE)]
  if (mode == "strip") {
    invisible(Map(strip_file, from, to))
  } else {
    ok <- unlist(Map(check_pair, from, to))
    cat(sprintf("%d/%d files passed all guards\n", sum(ok), length(ok)))
    if (!all(ok)) quit(status = 1L)
  }
}
