# ============================
# Phony Targets
# ============================

.PHONY: all help

# ============================
# Default Target
# ============================

.DEFAULT_GOAL := help

# ============================
# Help Target
# ============================

help:
	@./distributed_make.sh help

# ============================
# All Target
# ============================

all: _args
	@./distributed_make.sh all $(ARGS)

# ============================
# Subdirectory Targets
# ============================

SUBDIRS := $(shell ls -d */ 2>/dev/null | sed 's/\/$$//')

$(SUBDIRS): _args
	@./distributed_make.sh $@ $(ARGS)

# ============================
# Argument Handling
# ============================

.PHONY: _args

_args:
	$(eval ARGS := $(filter-out $@,$(MAKECMDGOALS)))
	@:

# Prevent make from interpreting extra arguments as targets
$(filter-out $(SUBDIRS) all help, $(MAKECMDGOALS)):
	@:
