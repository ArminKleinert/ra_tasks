#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>

// Defining a generic buffer size. Could be anything
#define MCAT_BUFF_SIZE 1024

int readAll(int fd, char* buff, ssize_t size) {
    ssize_t temp = 0;
    ssize_t bytes_read = 0;
    
    // Write all contents of buffer
    do {
        temp = read(fd, buff + bytes_read, size - bytes_read);
        
        // Check for error
        if (temp < 0) {
            return temp;
        }
        
        bytes_read += temp;
    } while (temp > 0 && bytes_read < size);
    
    return bytes_read;
}

int writeAll(int fd, char* buff, ssize_t size) {
    ssize_t temp = 0;
    ssize_t bytes_written = 0;
    
    // Write all contents of buffer
    while (bytes_written >= 0 && bytes_written < size) {
        temp = write(fd, buff + bytes_written, size - bytes_written);
        
        // Check for error
        if (temp < 0) {
            return temp;
        }
        
        bytes_written += temp;
    }
    
    return bytes_written;
}

// Reads and prints the contents of a file. On success, returns 0.
// For codes that can be returned on a failure, see possible
// error codes of read(2) and write(2)
int handleFile(char *file) {
  int fd;
  char buff[MCAT_BUFF_SIZE];
  ssize_t stat = 0;
  ssize_t wstat = 0;

  fd = open(file, 0);

  if (fd == -1) {
    switch (errno) {
    case EISDIR:
      fprintf(stderr, "cat says: %s is a directory.\n", file);
      break;
    case ENOENT:
      fprintf(stderr, "cat says: %s: No such file or directory.\n", file);
      break;
    default:
      fprintf(stderr, "cat says: %s could not be read.\n", file);
      break;
    }
    return errno;
  }

  do {
    // Do the read system call
    stat = readAll(fd, buff, MCAT_BUFF_SIZE);
    // Write to stdout if no error occured
    if (stat >= 0) {
        wstat = writeAll(1, buff, stat);
    }
    // break if end of file was reached or if an error occured
  } while (stat > 0);
  
  fd = close(fd);
  if (fd == -1) {
    fprintf(stderr, "cat says: %s could not be closed.\n", file);
    return errno;
  }

  // Check for errors
  if (stat < 0 || wstat < 0) {
    fprintf(stderr, "An error occured.");
    return errno;
  }

  return 0;
}

// Reads and prints user input from stdin. To exit, the user has to press
// CTRL+C.
// For codes that can be returned on a failure, see possible error codes of
// read(2) and write(2)
int fromStdin(void) {
  // Set up variables
  char buff[MCAT_BUFF_SIZE];
  ssize_t stat = 0;
  // Loop until an error is encountered or the user presses CTRL+C
  do {
    // Read from stdin
    stat = read(0, buff, MCAT_BUFF_SIZE);
    // Write to stdout if there is something to write and no error was
    // encountered
    if (stat > 0) {
        writeAll(1, buff, stat);
    }
  } while (stat > 0);

  return errno;
}

int main(int argc, char **args) {
  if (argc > 1) {
    for (int fileIdx = 1; fileIdx < argc; fileIdx++) {
      char *f = args[fileIdx];
      if (f[0] == '-' && f[1] == '\0') {
        fromStdin();
      } else {
        handleFile(f);
      }
    }
    return 0;
  } else {
    return fromStdin();
  }
}

