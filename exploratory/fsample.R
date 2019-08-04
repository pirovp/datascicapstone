# Function to sample lines from a large file
# https://stackoverflow.com/questions/15532810/reading-40-gb-csv-file-into-r-using-bigmemory/18282037#18282037

fsample <- function(fname, n, seed, header=FALSE, ..., reader=NULL) {

  # The function seeds the random number generator, opens a connection,
  # and reads in the (optional) header line
  set.seed(seed)
  con <- file(fname, open = "r")
  hdr <- if (header) {
    readLines(con, 1L)
  } else {
    character()
  }

  # The next step is to read in a chunk of n lines, initializing a counter
  # of the total number of lines seen
  buf <- readLines(con, n)
  n_tot <- length(buf)

  # Continue to read in chunks of n lines, stopping when there is no further
  # input
  repeat {
    txt <- readLines(con, n)
    if ((n_txt <- length(txt)) == 0L) break
    # For each chunk, draw a sample of n_keep lines, with the number of
    # lines proportional to the fraction of total lines in the current
    # chunk. This ensures that lines are sampled uniformly over the file.
    # If there are no lines to keep, move to the next chunk.
    n_tot <- n_tot + n_txt
    n_keep <- rbinom(1, n_txt, n_txt / n_tot)
    if (n_keep == 0L) next
    # Choose the lines to keep, and the lines to replace, and update the
    # buffer
    keep <- sample(n_txt, n_keep)
    drop <- sample(n, n_keep)
    buf[drop] <- txt[keep]
  }

  # When data input is done, we parse the result using the reader and return
  # the result
  if (is.null(reader) == FALSE) {
    reader(textConnection(c(hdr, buf), header = header, ...))
  }
  else {
    close(con)
    c(hdr, buf)
  }
}
