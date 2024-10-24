# ============================
# Color Definitions
# ============================

# ANSI color codes
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
MAGENTA := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

# ============================
# Variables
# ============================

REPO_URL = https://github.com/fmarotta/kaobook.git
REPO_CLONE_PATH = /tmp/kaobook

# Handle TEXMFHOME: Use TEXMFHOME if set; otherwise, default to ~/texmf
TEXMFHOME ?= $(HOME)/texmf
DESTINATION_PATH = $(TEXMFHOME)/tex/latex/kaobook

FILES_TO_COPY = kao.sty kaobiblio.sty kaobook.cls kaohandt.cls kaorefs.sty kaotheorems.sty

# Default LaTeX file
DEFAULT_LATEXFILE = presentation.tex
LATEXFILE ?= $(DEFAULT_LATEXFILE)

# LaTeX compilation command
# LATEX_CMD = pdflatex
# Alternatively, you can use latexmk for more robust builds
LATEX_CMD = latexmk -pdf

# Optional: LaTeX tidy command
TIDY_CMD = latexindent -w

# ============================
# Default Target
# ============================

# Set 'build' as the default target
.DEFAULT_GOAL := build

# ============================
# Phony Targets
# ============================

.PHONY: help update clone copy upgrade clone_reclone clean_repository clean build tidy

# ============================
# Help Target
# ============================

help:
	@echo -e "$(CYAN)Available targets:$(NC)"
	@echo "  $(GREEN)build$(NC)            - Compile the LaTeX file (default)."
	@echo "  $(GREEN)update$(NC)           - Conditionally clone and copy repository files."
	@echo "  $(GREEN)upgrade$(NC)          - Forcefully re-clone repository and recopy files."
	@echo "  $(GREEN)clean$(NC)            - Remove LaTeX auxiliary files."
	@echo "  $(GREEN)clean_repository$(NC) - Remove the cloned repository."
	@echo "  $(GREEN)tidy$(NC)             - Format the LaTeX file using latexindent."
	@echo "  $(GREEN)help$(NC)             - Show this help message."

# ============================
# Update Target
# ============================

update: check_update

check_update:
	@if [ ! -f "$(DESTINATION_PATH)/kaobook.cls" ]; then \
		echo -e "$(YELLOW)kaobook.cls not found in $(DESTINATION_PATH). Proceeding with update...$(NC)"; \
		$(MAKE) clone copy; \
	else \
		echo -e "$(GREEN)kaobook.cls already exists in $(DESTINATION_PATH). Update not required.$(NC)"; \
	fi

# ============================
# Clone Target
# ============================

clone:
	@if [ ! -d "$(REPO_CLONE_PATH)" ]; then \
		echo -e "$(CYAN)Cloning kaobook repository...$(NC)"; \
		git clone --depth=1 $(REPO_URL) $(REPO_CLONE_PATH); \
	else \
		echo -e "$(GREEN)Repository already cloned at $(REPO_CLONE_PATH). Skipping clone.$(NC)"; \
	fi

# ============================
# Ensure Destination Directory
# ============================

ensure_dest:
	@mkdir -p $(DESTINATION_PATH)

# ============================
# Copy Target
# ============================

copy: ensure_dest
	@for FILE in $(FILES_TO_COPY); do \
		if [ -f "$(REPO_CLONE_PATH)/$$FILE" ] || [ -d "$(REPO_CLONE_PATH)/$$FILE" ]; then \
			echo -e "$(CYAN)Copying $$FILE to $(DESTINATION_PATH)...$(NC)"; \
			cp -f "$(REPO_CLONE_PATH)/$$FILE" "$(DESTINATION_PATH)/"; \
		else \
			echo -e "$(YELLOW)Warning: $$FILE not found in the repository.$(NC)"; \
		fi \
	done

# ============================
# Upgrade Target
# ============================

upgrade: clone_reclone copy

clone_reclone:
	@if [ -d "$(REPO_CLONE_PATH)" ]; then \
		echo -e "$(YELLOW)Removing existing repository at $(REPO_CLONE_PATH)...$(NC)"; \
		rm -rf "$(REPO_CLONE_PATH)"; \
	fi
	@echo -e "$(CYAN)Cloning kaobook repository anew...$(NC)"
	git clone --depth=1 $(REPO_URL) $(REPO_CLONE_PATH)

# ============================
# Clean Repository Target
# ============================

clean_repository:
	@echo -e "$(YELLOW)Removing cloned repository at $(REPO_CLONE_PATH)...$(NC)"
	@rm -rf $(REPO_CLONE_PATH)

# ============================
# Clean Target
# ============================

clean:
	@echo -e "$(YELLOW)Cleaning auxiliary files for $(LATEXFILE)...$(NC)"
	@rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz *.bbl *.bcf *.blg

# ============================
# Build Target
# ============================

build:
	@echo -e "$(GREEN)Building LaTeX file: $(LATEXFILE)...$(NC)"
	@$(LATEX_CMD) $(LATEXFILE)
	@echo -e "$(GREEN)Build completed.$(NC)"

# ============================
# Tidy Target
# ============================

tidy:
	@if ! command -v $(TIDY_CMD) > /dev/null 2>&1; then \
		echo -e "$(RED)Error: $(TIDY_CMD) is not installed. Please install it to use the 'tidy' target.$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(GREEN)Tidying LaTeX file: $(LATEXFILE)...$(NC)"
	@$(TIDY_CMD) $(LATEXFILE)
	@echo -e "$(GREEN)Tidy completed.$(NC)"
