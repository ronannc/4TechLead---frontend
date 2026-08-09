FLUTTER ?= /Users/ronan/fvm/bin/fvm flutter
DART ?= /Users/ronan/fvm/bin/fvm dart

.DEFAULT_GOAL := help

.PHONY: help pub-get format fix clean analyze test run

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

pub-get: ## Install Flutter dependencies
	$(FLUTTER) pub get

format: ## Format Dart files
	$(DART) format lib test

fix: ## Apply Dart automated fixes
	$(DART) fix --apply

clean: ## Clean Flutter build artifacts
	$(FLUTTER) clean

analyze: ## Run Flutter analyzer
	$(FLUTTER) analyze

test: ## Run Flutter tests
	$(FLUTTER) test

run: ## Run the app, e.g. make run d=macos
	$(FLUTTER) run $(if $(d),-d $(d),)
