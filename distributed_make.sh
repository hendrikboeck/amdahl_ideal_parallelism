#!/bin/bash

# ============================
# Color Definitions
# ============================

# ANSI color codes for colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREY='\033[0;37m'
NC='\033[0m' # No Color

# ============================
# Variables
# ============================

# Extract directories to ignore from .gitignore (lines ending with '/'), excluding comments and empty lines
if [ -f .gitignore ]; then
    IGNORE_DIRS=$(grep '/$' .gitignore 2>/dev/null | grep -v '^#' | awk '{sub(/\/$/,""); print}')
else
    IGNORE_DIRS=""
fi

# Dynamically list all immediate subdirectories, excluding those in .gitignore
SUBDIRS=$(ls -d */ 2>/dev/null | awk '{gsub(/\/$/,""); print}')
for dir in $IGNORE_DIRS; do
    SUBDIRS=$(echo "$SUBDIRS" | grep -v "^$dir$")
done

# ============================
# Functions
# ============================

usage() {
    echo -e "${CYAN}Usage: $0 <subdirectory> [target]"
    echo -e "       $0 all [target]${NC}"
    echo ""
    echo -e "${CYAN}Available Subdirectories:${NC}"
    echo "  $SUBDIRS"
    echo ""
    echo -e "${CYAN}Special Target:${NC}"
    echo "  all [target]  - Run the specified target (or default if none) on all subdirectories."
    echo ""
    echo -e "${CYAN}Example Usage:${NC}"
    echo "  $0 subdir1 build       - Run 'make build' in subdir1."
    echo "  $0 all clean           - Run 'make clean' in all subdirectories."
    echo "  $0 all                 - Run 'make' (default target) in all subdirectories."
    echo "  $0 help                - Show this help message."
}

# ============================
# Main Script
# ============================

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

COMMAND="$1"
shift

# Now, ARGS should be everything else
# We need to filter out any occurrences of COMMAND in the remaining arguments
ARGS_ARRAY=()
for arg in "$@"; do
    if [ "$arg" != "$COMMAND" ]; then
        ARGS_ARRAY+=("$arg")
    fi
done

if [ "$COMMAND" == "help" ]; then
    usage
    exit 0
elif [ "$COMMAND" == "all" ]; then
    # Build the command string
    CMD="make"
    if [ ${#ARGS_ARRAY[@]} -gt 0 ]; then
        CMD+=" ${ARGS_ARRAY[*]}"
    fi
    echo -e "${GREEN}Running '${CMD}' on all subdirectories...${NC}"
    for dir in $SUBDIRS; do
        if [ -f "$dir/Makefile" ]; then
            echo -e "${BLUE}-- Executing '${CMD}' in $dir...${NC}"
            (
                cd "$dir"
                # Run the make command and pipe the output through sed to color it grey
                make "${ARGS_ARRAY[@]}" 2>&1 | sed "s/^/${GREY}/" | sed "s/$/${NC}/"
            )
            STATUS=${PIPESTATUS[0]}
            if [ $STATUS -ne 0 ]; then
                echo -e "${RED}Error: 'make' failed in $dir.${NC}"
                exit $STATUS
            fi
        else
            echo -e "${YELLOW}-- Skipping $dir: Makefile not found.${NC}"
        fi
    done
    echo -e "${GREEN}All targets executed.${NC}"
elif echo "$SUBDIRS" | grep -w "$COMMAND" > /dev/null; then
    # Build the command string
    CMD="make"
    if [ ${#ARGS_ARRAY[@]} -gt 0 ]; then
        CMD+=" ${ARGS_ARRAY[*]}"
    fi
    if [ -f "$COMMAND/Makefile" ]; then
        echo -e "${GREEN}Running '${CMD}' in $COMMAND...${NC}"
        (
            cd "$COMMAND"
            # Run the make command and pipe the output through sed to color it grey
            make "${ARGS_ARRAY[@]}" 2>&1 | sed "s/^/${GREY}/" | sed "s/$/${NC}/"
        )
        STATUS=${PIPESTATUS[0]}
        if [ $STATUS -ne 0 ]; then
            echo -e "${RED}Error: 'make' failed in $COMMAND.${NC}"
            exit $STATUS
        fi
    else
        echo -e "${YELLOW}-- Skipping $COMMAND: Makefile not found.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Error: Subdirectory '$COMMAND' does not exist or is not recognized.${NC}"
    exit 1
fi
