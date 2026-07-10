# Step 5a Part A — Fetch the Confidence Database (Rahnev et al. 2020) from
# OSF and establish provenance (dispatch 009). REALDATA-EXTERNAL (CONFDB).
#
# Source: OSF project s46pr ONLY (https://osf.io/s46pr; Rahnev et al. 2020,
# Nat Hum Behav 4:317-325). No registered/versioned snapshot of the node
# exists (https://api.osf.io/v2/nodes/s46pr/registrations/ returns an empty
# list, checked 2026-07-10), so provenance is pinned by: the access
# timestamp, each file's OSF-reported md5/sha256, and each file's OSF
# version number, all recorded in the manifest.
#
# Download mechanics: the OSF v2 API enumerates the "Confidence Database"
# folder (all study data_*.csv + readme_*.txt) plus the root
# Database_Information.xlsx (the maintainers' study-information sheet —
# an input to the inventory, never a substitute for verifying the files).
# Each file is downloaded via its canonical OSF download link
# (https://osf.io/download/<guid>/), binary mode, and verified against the
# md5 OSF reports for it. Per dispatch: 2 retries after a failed attempt,
# then the file is recorded as MISSING and the run proceeds.
#
# Outputs:
#   data/raw/confidence_db/            raw files (gitignored, ~255 MB)
#   results/step11_CONFDB_manifest.csv one row per expected file:
#                                      md5s, bytes, version, URL, timestamp,
#                                      status VERIFIED/MD5_MISMATCH/MISSING
#   results/step11_CONFDB_provenance.json  node-level provenance + counts
#
# The script is idempotent: files already present whose md5 matches the
# OSF-reported md5 are not re-downloaded.

library(here)

node_id <- "s46pr"
api_base <- paste0("https://api.osf.io/v2/nodes/", node_id, "/files/osfstorage/")

raw_dir <- here("data", "raw", "confidence_db")
dir.create(raw_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(here("results"), recursive = TRUE, showWarnings = FALSE)

api_get <- function(u, tries = 3) {
  for (i in seq_len(tries)) {
    out <- tryCatch({
      con <- url(u, "r")
      on.exit(close(con), add = TRUE)
      jsonlite::fromJSON(paste(readLines(con, warn = FALSE), collapse = ""),
                         simplifyVector = FALSE)
    }, error = function(e) {
      message(sprintf("  API attempt %d failed: %s", i, conditionMessage(e)))
      NULL
    })
    if (!is.null(out)) return(out)
    Sys.sleep(2^i)
  }
  stop("OSF API unreachable after ", tries, " attempts: ", u,
       " — STOPPING per dispatch (do not source the data elsewhere).")
}

# ---- 1. Enumerate ----------------------------------------------------------
message("Enumerating OSF node ", node_id, " ...")
node_info <- api_get(paste0("https://api.osf.io/v2/nodes/", node_id, "/"))
node_modified <- node_info$data$attributes$date_modified

list_page <- function(u) {
  items <- list()
  while (!is.null(u)) {
    d <- api_get(u)
    items <- c(items, d$data)
    u <- d$links$`next`
  }
  items
}

root_items <- list_page(paste0(api_base, "?page%5Bsize%5D=100"))
root_names <- vapply(root_items, function(f) f$attributes$name, character(1))

db_folder <- root_items[[which(root_names == "Confidence Database")]]
stopifnot(db_folder$attributes$kind == "folder")
db_url <- paste0(api_base, sub("^/", "", db_folder$attributes$path),
                 "?page%5Bsize%5D=100")
db_items <- list_page(db_url)

# The metadata sheet lives at the node root.
meta_item <- root_items[[which(root_names == "Database_Information.xlsx")]]
stopifnot(meta_item$attributes$kind == "file")

all_items <- c(db_items, list(meta_item))

item_row <- function(f) {
  a <- f$attributes
  data.frame(
    filename = a$name,
    role = if (a$name == "Database_Information.xlsx") "metadata"
           else if (grepl("^data_", a$name)) "data"
           else if (grepl("^readme_", a$name)) "readme"
           else "other",
    bytes_osf = as.numeric(a$size),
    md5_osf = a$extra$hashes$md5,
    sha256_osf = a$extra$hashes$sha256,
    osf_version = a$current_version,
    source_url = f$links$download,
    stringsAsFactors = FALSE
  )
}
manifest <- do.call(rbind, lapply(all_items, item_row))
manifest <- manifest[order(manifest$filename), ]
message(sprintf("Enumerated %d files (%d data, %d readme, %d metadata), %.0f MB",
                nrow(manifest), sum(manifest$role == "data"),
                sum(manifest$role == "readme"),
                sum(manifest$role == "metadata"),
                sum(manifest$bytes_osf) / 1e6))

# ---- 2. Download + verify --------------------------------------------------
fetch_one <- function(u, dest, tries = 3) { # initial attempt + 2 retries
  for (i in seq_len(tries)) {
    ok <- tryCatch({
      download.file(u, dest, mode = "wb", quiet = TRUE, method = "libcurl")
      TRUE
    }, error = function(e) {
      message(sprintf("  attempt %d failed: %s", i, conditionMessage(e)))
      FALSE
    })
    if (ok) return(TRUE)
    Sys.sleep(2^i)
  }
  FALSE
}

manifest$bytes_local <- NA_real_
manifest$md5_local <- NA_character_
manifest$md5_match <- NA
manifest$downloaded_utc <- NA_character_
manifest$status <- NA_character_

for (i in seq_len(nrow(manifest))) {
  dest <- file.path(raw_dir, manifest$filename[i])
  if (file.exists(dest) &&
      identical(unname(tools::md5sum(dest)), manifest$md5_osf[i])) {
    message(sprintf("[%3d/%d] present + md5 ok: %s",
                    i, nrow(manifest), manifest$filename[i]))
  } else {
    message(sprintf("[%3d/%d] fetching %s", i, nrow(manifest),
                    manifest$filename[i]))
    got <- fetch_one(manifest$source_url[i], dest)
    if (!got) {
      if (file.exists(dest)) unlink(dest) # never keep a partial file
      manifest$status[i] <- "MISSING"
      next
    }
  }
  manifest$bytes_local[i] <- file.size(dest)
  manifest$md5_local[i] <- unname(tools::md5sum(dest))
  manifest$md5_match[i] <- identical(manifest$md5_local[i],
                                     manifest$md5_osf[i])
  manifest$downloaded_utc[i] <- format(Sys.time(), "%Y-%m-%d %H:%M:%S",
                                       tz = "UTC")
  manifest$status[i] <- if (isTRUE(manifest$md5_match[i])) "VERIFIED"
                        else "MD5_MISMATCH"
}

write.csv(manifest, here("results", "step11_CONFDB_manifest.csv"),
          row.names = FALSE)

# ---- 3. Node-level provenance ----------------------------------------------
provenance <- list(
  data_type = "REALDATA-EXTERNAL (CONFDB)",
  source = "https://osf.io/s46pr (Rahnev et al. 2020, Nat Hum Behav 4:317-325)",
  api_enumeration = list(
    node = paste0("https://api.osf.io/v2/nodes/", node_id, "/"),
    folder_listing = db_url,
    registrations_checked =
      "https://api.osf.io/v2/nodes/s46pr/registrations/ -> empty (no registered snapshot exists; live node fetched)"
  ),
  node_date_modified = node_modified,
  accessed_utc = format(Sys.time(), "%Y-%m-%d %H:%M:%S", tz = "UTC"),
  n_files_enumerated = nrow(manifest),
  n_data_csv = sum(manifest$role == "data"),
  n_readme = sum(manifest$role == "readme"),
  n_verified = sum(manifest$status == "VERIFIED", na.rm = TRUE),
  n_md5_mismatch = sum(manifest$status == "MD5_MISMATCH", na.rm = TRUE),
  n_missing = sum(manifest$status == "MISSING", na.rm = TRUE),
  total_bytes_verified = sum(manifest$bytes_local[manifest$status == "VERIFIED"],
                             na.rm = TRUE),
  osf_versions_all_1 = all(vapply(all_items,
                                  function(f) f$attributes$current_version == 1,
                                  logical(1)))
)
jsonlite::write_json(provenance,
                     here("results", "step11_CONFDB_provenance.json"),
                     auto_unbox = TRUE, pretty = TRUE)

message(sprintf(
  "\nFetch complete: %d VERIFIED, %d MD5_MISMATCH, %d MISSING (of %d).",
  provenance$n_verified, provenance$n_md5_mismatch, provenance$n_missing,
  nrow(manifest)
))
if (provenance$n_md5_mismatch > 0) {
  message("WARNING: md5 mismatches present — see manifest; affected files must not be used.")
}
