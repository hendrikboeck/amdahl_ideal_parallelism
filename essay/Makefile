# ============================
# Color Definitions
# ============================

# ANSI color codes with properly escaped backslashes
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
MAGENTA := \033[0;35m
CYAN := \033[0;36m
GRAY := \033[0;37m
NC := \033[0m # No Color

# ============================
# Variables
# ============================

REPO_URL = https://github.com/fmarotta/kaobook.git
REPO_CLONE_PATH = /tmp/kaobook

# Handle TEXMFHOME: Use TEXMFHOME if set; otherwise, default to ~/texmf
TEXMFHOME ?= $(HOME)/texmf
DESTINATION_PATH = $(TEXMFHOME)/tex/latex/kaobook

FILES_TO_COPY = kao.sty kaobiblio.sty kaobook.cls kaohandt.clsakorefs.sty kaotheorems.sty

# Default LaTeX file
DEFAULT_LATEXFILE = essay.tex
LATEXFILE ?= $(DEFAULT_LATEXFILE)

# LaTeX compilation command with suppressed output
LATEX_CMD = latexmk -pdf -silent -pdflatex="pdflatex -interaction=nonstopmode" -use-make

# ============================
# Default Target
# ============================

# Set 'all' as the default target (CMake-like)
.DEFAULT_GOAL := all

# ============================
# Phony Targets
# ============================

.PHONY: help configure build install update clone copy upgrade confirm_upgrade clone_reclone clean_repository clean clean_aux all

# ============================
# Help Target
# ============================

help:
	@printf "$(CYAN)Available targets:$(NC)\n"
	@printf "  $(GREEN)all$(NC)               - Configure and build the LaTeX project (default).\n"
	@printf "  $(GREEN)configure$(NC)         - Set up the build environment.\n"
	@printf "  $(GREEN)build$(NC)             - Compile the LaTeX file.\n"
	@printf "  $(GREEN)install$(NC)           - Install necessary dependencies.\n"
	@printf "  $(GREEN)update$(NC)            - Conditionally clone and copy repository files.\n"
	@printf "  $(GREEN)upgrade$(NC)           - Forcefully re-clone repository and recopy files.\n"
	@printf "  $(GREEN)clean$(NC)             - Remove LaTeX auxiliary files and cloned repository.\n"
	@printf "  $(GREEN)clean_aux$(NC)         - Remove only LaTeX auxiliary files.\n"
	@printf "  $(GREEN)clean_repository$(NC)  - Remove the cloned repository.\n"
	@printf "  $(GREEN)help$(NC)              - Show this help message.\n"

# ============================
# All Target
# ============================

all: configure build
	@printf "$(GREEN)-- All targets completed successfully.$(NC)\n"

# ============================
# Configure Target
# ============================

configure: update
	@printf "$(GREEN)-- Configuration completed.$(NC)\n"

# ============================
# Update Target
# ============================

update: check_update
	@printf "$(GREEN)-- Update step completed.$(NC)\n"

check_update:
	@printf "$(CYAN)-- Checking for required LaTeX dependencies...$(NC)\n"
	@if [ ! -f "$(DESTINATION_PATH)/kaobook.cls" ]; then \
		printf "$(YELLOW)-- kaobook.cls not found in $(DESTINATION_PATH).$(NC)\n"; \
		read -p "Enter the URL to download it [Default: $(REPO_URL)]: " url; \
		url=$${url:-$(REPO_URL)}; \
		read -p "Enter the installation path [Default: $(DESTINATION_PATH)]: " dest; \
		dest=$${dest:-$(DESTINATION_PATH)}; \
		read -p "Proceed with downloading and installing from $$url to $$dest? [Y/n]: " confirm; \
		if [ "$$confirm" = "n" ] || [ "$$confirm" = "N" ]; then \
			printf "$(YELLOW)-- Skipping dependency installation.$(NC)\n"; \
		else \
			printf "$(CYAN)-- Proceeding with downloading and installing...$(NC)\n"; \
			REPO_URL="$$url" DESTINATION_PATH="$$dest" $(MAKE) clone copy; \
		fi; \
	else \
		printf "$(GREEN)-- kaobook.cls already exists in $(DESTINATION_PATH). No update needed.$(NC)\n"; \
	fi

# ============================
# Clone Target
# ============================

clone:
	@printf "$(CYAN)-- Cloning kaobook repository...$(NC)\n"
	@if [ ! -d "$(REPO_CLONE_PATH)" ]; then \
		git clone --depth=1 $(REPO_URL) $(REPO_CLONE_PATH) >/dev/null 2>&1; \
		if [ $$? -eq 0 ]; then \
			printf "$(GREEN)-- Repository cloned successfully.$(NC)\n"; \
		else \
			printf "$(RED)-- Failed to clone repository.$(NC)\n"; \
			exit 1; \
		fi \
	else \
		printf "$(GREEN)-- Repository already cloned at $(REPO_CLONE_PATH). Skipping clone.$(NC)\n"; \
	fi

# ============================
# Copy Target
# ============================

copy:
	@printf "$(CYAN)-- Copying necessary files...$(NC)\n"
	@for FILE in $(FILES_TO_COPY); do \
		if [ -f "$(REPO_CLONE_PATH)/$$FILE" ] || [ -d "$(REPO_CLONE_PATH)/$$FILE" ]; then \
			cp -f "$(REPO_CLONE_PATH)/$$FILE" "$(DESTINATION_PATH)/" >/dev/null 2>&1; \
			if [ $$? -eq 0 ]; then \
				printf "$(GREEN)--- Copied $$FILE successfully.$(NC)\n"; \
			else \
				printf "$(RED)--- Failed to copy $$FILE.$(NC)\n"; \
			fi \
		else \
			printf "$(YELLOW)--- Warning: $$FILE not found in the repository.$(NC)\n"; \
		fi \
	done

# ============================
# Install Target
# ============================

install: clone copy
	@printf "$(GREEN)-- Installation completed.$(NC)\n"

# ============================
# Upgrade Target
# ============================

upgrade: confirm_upgrade clone_reclone copy
	@printf "$(GREEN)-- Upgrade completed successfully.$(NC)\n"

confirm_upgrade:
	@printf "$(CYAN)-- Confirming upgrade process...$(NC)\n"
	@read -p "Are you sure you want to upgrade? This will re-clone the repository and overwrite existing files. [Y/n]: " confirm; \
	if [ "$$confirm" = "n" ] || [ "$$confirm" = "N" ]; then \
		printf "$(YELLOW)-- Upgrade cancelled.$(NC)\n"; \
		exit 0; \
	else \
		printf "$(CYAN)-- Proceeding with upgrade...$(NC)\n"; \
	fi

clone_reclone:
	@printf "$(CYAN)-- Re-cloning kaobook repository...$(NC)\n"
	@if [ -d "$(REPO_CLONE_PATH)" ]; then \
		rm -rf "$(REPO_CLONE_PATH)" >/dev/null 2>&1; \
		if [ $$? -eq 0 ]; then \
			printf "$(GREEN)-- Existing repository removed successfully.$(NC)\n"; \
		else \
			printf "$(RED)-- Failed to remove existing repository.$(NC)\n"; \
			exit 1; \
		fi \
	fi
	@git clone --depth=1 $(REPO_URL) $(REPO_CLONE_PATH) >/dev/null 2>&1
	@if [ $$? -eq 0 ]; then \
		printf "$(GREEN)-- Repository cloned successfully.$(NC)\n"; \
	else \
		printf "$(RED)-- Failed to clone repository.$(NC)\n"; \
		exit 1; \
	fi

# ============================
# Clean Repository Target
# ============================

clean_repository:
	@printf "$(CYAN)-- Removing cloned repository at $(REPO_CLONE_PATH)...$(NC)\n"
	@rm -rf $(REPO_CLONE_PATH) >/dev/null 2>&1
	@if [ $$? -eq 0 ]; then \
		printf "$(GREEN)-- Repository removed successfully.$(NC)\n"; \
	else \
		printf "$(RED)-- Failed to remove repository.$(NC)\n"; \
	fi

# ============================
# Clean Auxiliary Files Target
# ============================

clean_aux:
	@printf "$(CYAN)-- Cleaning auxiliary LaTeX files for $(LATEXFILE)...$(NC)\n"
	@find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.toc" -o -name "*.lof" -o -name "*.lot" -o -name "*.fls" -o -name "*.fdb_latexmk" -o -name "*.synctex.gz" -o -name "*.bbl" -o -name "*.bcf" -o -name "*.blg" \) -exec rm -f {} + >/dev/null 2>&1
	@if [ $$? -eq 0 ]; then \
		printf "$(GREEN)-- Auxiliary files cleaned successfully.$(NC)\n"; \
	else \
		printf "$(RED)-- Failed to clean auxiliary files.$(NC)\n"; \
	fi

# ============================
# Clean Target
# ============================

clean: clean_aux clean_repository
	@printf "$(GREEN)-- Clean process completed. All auxiliary files and repositories removed.$(NC)\n"

# ============================
# Build Target
# ============================

build:
	@printf "$(CYAN)-- Scanning dependencies of target $(LATEXFILE)...$(NC)\n"
	@printf "$(CYAN)[ 50%%] Building LaTeX document...$(NC)\n"
	@$(LATEX_CMD) $(LATEXFILE) >/dev/null 2>&1
	@if [ $$? -eq 0 ]; then \
		if ls *.bib >/dev/null 2>&1; then \
			printf "$(CYAN)[ 75%%] Running BibTeX...$(NC)\n"; \
			bibtex $(basename $(LATEXFILE)); \
			if [ $$? -eq 0 ]; then \
				printf "$(CYAN)[ 90%%] Rebuilding LaTeX document...$(NC)\n"; \
				$(LATEX_CMD) $(LATEXFILE) >/dev/null 2>&1; \
				if [ $$? -eq 0 ]; then \
					printf "$(CYAN)[100%%] Built target $(LATEXFILE).$(NC)\n"; \
				else \
					printf "$(RED)-- Build failed during LaTeX recompilation. Check your LaTeX source for errors.$(NC)\n"; \
					exit 1; \
				fi \
			else \
				printf "$(RED)-- BibTeX failed. Check your .bib file for errors.$(NC)\n"; \
				exit 1; \
			fi \
		else \
			printf "$(GREEN)-- Built target $(LATEXFILE).$(NC)\n"; \
		fi \
	else \
		printf "$(RED)-- Initial LaTeX build failed. Check your LaTeX source for errors.$(NC)\n"; \
		exit 1; \
	fi

