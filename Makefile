# FailSafe pipeline. Run `make help` for targets.

PYTHON  ?= python3
VENV    := .venv
BIN     := $(VENV)/bin
QUARTER ?= Q1_2024
CLUSTER ?= failsafe

# Placeholder recipe for stages that are not built yet: fail loudly.
TODO = @echo "$@: not implemented yet" >&2; exit 1

.PHONY: help setup test lint data features train evaluate cost cluster-up demo cluster-down clean

help: ## List targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-13s %s\n", $$1, $$2}'

# --- Dev -------------------------------------------------------------------

setup: $(VENV)/.installed ## Create .venv and install requirements

$(VENV)/.installed: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(BIN)/pip install -r requirements.txt
	touch $@

test: setup ## Run tests
	$(BIN)/python -m pytest

lint: setup ## Lint with ruff
	$(BIN)/ruff check .

# --- Brain -----------------------------------------------------------------

data: ## Download one quarter of Drive Stats to data/raw (QUARTER=Q1_2024)
	mkdir -p data/raw
	curl -fL -o data/raw/data_$(QUARTER).zip \
		https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_$(QUARTER).zip
	unzip -o -q data/raw/data_$(QUARTER).zip -d data/raw/$(QUARTER)

features: ## Filter to one drive model, build per-drive features and labels
	$(TODO)

train: ## Fit threshold rule, logistic regression, Isolation Forest, XGBoost
	$(TODO)

evaluate: ## Per-drive metrics and lead time on the chronological test split
	$(TODO)

# --- Cost model ------------------------------------------------------------

cost: ## Compare disk/in-memory checkpointing vs predictive action
	$(TODO)

# --- Hands -----------------------------------------------------------------

cluster-up: ## Create the kind cluster
	kind create cluster --name $(CLUSTER)

demo: ## Flag a node, cordon + evict under the PDB, hand state over via etcd
	$(TODO)

cluster-down: ## Delete the kind cluster
	kind delete cluster --name $(CLUSTER)

# ---------------------------------------------------------------------------

clean: ## Remove venv and caches (keeps data/ and models/)
	rm -rf $(VENV) .pytest_cache .ruff_cache
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
