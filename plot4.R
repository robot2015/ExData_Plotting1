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

# Create plot4.png.
png('plot4.png', width = 480, height = 480)
par(mfrow = c(2,2))
plot(powerData$DateTime,
     powerData$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power"
)
plot(powerData$DateTime,
     powerData$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage"
)
plot(powerData$DateTime,
     powerData$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering"
)
lines(powerData$DateTime,
      powerData$Sub_metering_2,
      col = 2
)
lines(powerData$DateTime,
      powerData$Sub_metering_3,
      col = 4
)
legend("topright",
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       col = c(1, 2, 4),
       bty = "n",
       lty = 1
)
plot(powerData$DateTime,
     powerData$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power"
)
dev.off()