rm(list = ls())

## Estimate memory.
# The dataset has 2,075,259 rows and 9 columns.
# First calculate a rough estimate of how much memory 
# the dataset will require in memory before reading into R. 
# Make sure your computer has enough memory
memoryEst.MB <- 2075259 * 9 * 8 / 2^20

## Read data.
# Unzip data.
zipData <- unzip("exdata-data-household_power_consumption.zip")

# Get column classes.
powerDataCheck <- read.table(zipData, header = TRUE, nrows = 100, sep = ";")
classes <- sapply(powerDataCheck, class)

# Read date.
classes2 <- c(classes[1], rep(list(NULL), 8))
powerDataDate <- read.table(zipData, header = TRUE, sep = ";", colClasses = classes2)
powerDataDate$Date = as.POSIXlt(powerDataDate$Date, format = "%d/%m/%Y")

dateStart <- as.POSIXlt("2007-02-01", format = "%Y-%m-%d")
dateEnd <- as.POSIXlt("2007-02-02", format = "%Y-%m-%d")

dates <- dateStart <= powerDataDate$Date & powerDataDate$Date <= dateEnd

# Read only desired dates.
rowStart <- min(which(dates))
rowEnd <- max(which(dates))
rowN = rowEnd - rowStart + 1

powerData <- read.table(zipData, 
                        header = FALSE, 
                        sep = ";",
                        colClasses = classes, 
                        skip = rowStart,
                        nrows = rowN,
                        na.strings = "?"
)

colNames <- read.table(zipData, 
                   header = TRUE, 
                   sep = ";", 
                   nrows = 1
)

names(powerData) <- names(colNames)

powerData$DateTime <- paste(powerData$Date, powerData$Time, sep = " ")
powerData$DateTime <- as.POSIXlt(powerData$DateTime, format = "%d/%m/%Y %H:%M:%S")

# Create plot1.png.
png('plot1.png', width = 480, height = 480)
hist(powerData$Global_active_power, 
     col = 'red', 
     main = 'Global Active Power', 
     xlab = 'Global Active Power (kilowatts)'
)
dev.off()