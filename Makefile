#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = code-your-own-pandas-pipeline
PYTHON_VERSION = 3.12
PYTHON_INTERPRETER = python

#################################################################################
# COMMANDS                                                                      #
#################################################################################


## Install Python Dependencies
.PHONY: requirements
requirements: 
	$(PYTHON_INTERPRETER) -m pip install -U pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt

## Install Python Dependencies Quietly
.PHONY: requirements_quiet
requirements_quiet: 
	$(PYTHON_INTERPRETER) -m pip install -q -U pip
	$(PYTHON_INTERPRETER) -m pip install -q -r requirements.txt


## Delete all compiled Python files
.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} +

## Alias for clean
.PHONY: clear
clear: clean

## Delete the current python environment. Nuke it from orbit.
.PHONY: nuke
nuke: clean
	find . -type d -name "*.venv" -exec rm -rf {} +

## Lint using flake8 and black (use `make format` to do formatting)
.PHONY: lint
lint:
	$(PYTHON_INTERPRETER) -m flake8 $(PROJECT_NAME)
	$(PYTHON_INTERPRETER) -m isort --check --diff --profile black $(PROJECT_NAME)
	$(PYTHON_INTERPRETER) -m black --check --config pyproject.toml $(PROJECT_NAME)

## Format source code with black
.PHONY: format
format:
	$(PYTHON_INTERPRETER) -m isort --profile black $(PROJECT_NAME)
	$(PYTHON_INTERPRETER) -m black --config pyproject.toml $(PROJECT_NAME)

## Set up python interpreter environment
.PHONY: create_environment
create_environment:
	$(PYTHON_INTERPRETER) -m venv .venv


## Set up pre-commits and run them on all files
.PHONY: pre-commits
pre-commits: requirements_quiet
	$(PYTHON_INTERPRETER) -m pre_commit autoupdate
	$(PYTHON_INTERPRETER) -m pre_commit install
	$(PYTHON_INTERPRETER) -m pre_commit run --all-files


#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

## Run Pipeline
.PHONY: run_example_pipeline
run_pipeline: requirements_quiet
	$(PYTHON_INTERPRETER) example_pipeline/pipeline.py

## Run all tests
.PHONY: test
test: requirements_quiet
	$(PYTHON_INTERPRETER) -m pytest

## Run only unittests
.PHONY: unittest
unittest: requirements_quiet
	$(PYTHON_INTERPRETER) -m pytest tests/unittests 

## Run only end-to-end (e2e) tests
.PHONY: e2e
e2e: requirements_quiet
	$(PYTHON_INTERPRETER) -m pytest tests/e2e_tests

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

## Show some helpful information!

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z0-9_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)