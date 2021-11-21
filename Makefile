include .env

DRIVE = ./bin/drive_linux

ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
	VENV_BIN_DIR = venv/Scripts
	PYTHON = "$(VENV_BIN_DIR)/python.exe"
	PIP = "$(VENV_BIN_DIR)/pip.exe"
	FLASK = "$(VENV_BIN_DIR)/flask.exe"
	PYTHON_ROOT = $(PYTHON_ROOT_WIN)
	DRIVE = ./bin/drive_win
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
	VENV_BIN_DIR = venv/bin
	PYTHON = "$(VENV_BIN_DIR)/python"
	PIP = "$(VENV_BIN_DIR)/pip"
	FLASK = "$(VENV_BIN_DIR)/flask"
	PYTHON_ROOT = $(PYTHON_ROOT_LINUX)
	ifeq ($(detected_OS),Darwin)
		DRIVE = ./bin/drive_darwin
	endif
endif

CMD_FROM_VENV = ". $(VENV_BIN_DIR)/activate; which"
define create-venv
$(PYTHON_ROOT)/python3 -m venv venv
endef
define create-venv-win
$(PYTHON_ROOT)/python.exe -m venv venv
endef

.PHONY: all
all: flask

run-py:
	$(PYTHON) --version

flask:
	$(FLASK) run

.PHONY: venv
venv:
	@$(create-venv)
	make update-pip

venv-win:
	@$(create-venv-win)
	make update-pip

update-pip:
	@$(PYTHON) -m pip install --upgrade pip
	@$(PIP) install -r requirements.txt

clean-venv:
	@rm -rf venv