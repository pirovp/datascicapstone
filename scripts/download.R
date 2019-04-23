down_self <- function(url, folder) {
# Download file without specifying name
      urlsplit = strsplit(url, "/")[[1]]
      filename = urlsplit[length(urlsplit)]
      path = paste(folder, "/", filename, sep = "")      
      download.file(url, destfile = path)
}


# raw data for the project
url_rd = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(url_rd, destfile = "data/rawdata.zip")
unzip("data/rawdata.zip", exdir = "data")


# paper on Journal of Statistical Software on text mining infrastructure in R
jss = NULL
jss[1] <- "https://www.jstatsoft.org/index.php/jss/article/view/v025i05/v25i05.pdf"
# jss[2] <- "https://www.jstatsoft.org/index.php/jss/article/downloadSuppFile/v025i05/twww.mbeglobal.com m_0.3.tar.gz"
jss[2] <- "https://www.jstatsoft.org/index.php/jss/article/downloadSuppFile/v025i05/v25i05.R"

invisible(lapply(jss, down_self, folder = "knowledge"))

# clear workspace
rm(list = ls())
