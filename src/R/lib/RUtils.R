# Library with my auxiliary and general purpose routines.

# Function that clears the screen
cls <- function() {
   system('clear')
}

# Function that concats n strings.
concat <- function(...) {
   return(paste(..., sep=""))
}

# Function that prints a message if the configuration variable printMessages
# is set to TRUE
printMessage <- function(...) {
   if(printMessages) cat(...)
}

# Function that prints a matrix if the configuration variable printMessages
# is set to TRUE
printMatrix <- function(...) {
   if(printMessages) print(...)
}

# Function that prints a ROC if the configuration variable printMessages
# is set to TRUE
printROC <- function(...) {
   if(printMessages) print(...)
}
