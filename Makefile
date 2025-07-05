# Network File System (NFS) Makefile

CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -pthread -g
LDFLAGS = -pthread

# Source files
HELPER_SOURCES = helper.c lock.c tries.c
HELPER_OBJECTS = $(HELPER_SOURCES:.c=.o)

# Header files
HEADERS = helper.h lock.h tries.h ErrorCodes.h

# Executables
TARGETS = naming_server storage_server client

# Default target
all: $(TARGETS)

# Naming Server
naming_server: naming_server.o $(HELPER_OBJECTS)
    $(CC) $(LDFLAGS) -o $@ $^

ns: naming_server

# Storage Server
storage_server: storage_server.o $(HELPER_OBJECTS)
    $(CC) $(LDFLAGS) -o $@ $^

ss: storage_server

# Client
client: client.o $(HELPER_OBJECTS)
    $(CC) $(LDFLAGS) -o $@ $^

cl: client

# Object files
%.o: %.c $(HEADERS)
    $(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
    rm -f *.o $(TARGETS)

# Clean backups (as mentioned in README)
clean-backups:
    rm -rf ./backupforss

# Full clean
distclean: clean clean-backups
    rm -f log.txt

# Install dependencies (ffplay for streaming)
install-deps:
    @echo "Installing ffplay for media streaming..."
    @which ffplay > /dev/null || echo "Please install ffmpeg package for ffplay support"

# Help target
help:
    @echo "Available targets:"
    @echo "  all           - Build all components"
    @echo "  ns            - Build Naming Server"
    @echo "  ss            - Build Storage Server"
    @echo "  cl            - Build Client"
    @echo "  clean         - Remove build artifacts"
    @echo "  clean-backups - Remove backup folders"
    @echo "  distclean     - Full cleanup including logs"
    @echo "  install-deps  - Check/install dependencies"
    @echo "  help          - Show this help message"

# Phony targets
.PHONY: all clean clean-backups distclean install-deps help ns ss cl