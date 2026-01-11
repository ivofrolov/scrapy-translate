.DEFAULT_GOAL := install

package = scrapy_translate
tests = tests

.PHONY: format
format:
	ruff format $(package) $(tests)

.PHONY: lint
lint:
	ruff check --output-format pylint $(package) $(tests)
	ty check --output-format concise --color never --no-progress $(package)

.PHONY: install
install:
	python3 -m pip install --editable .

.PHONY: test
test:
	python3 -m unittest

.PHONY: ensure-build-system
ensure-build-system:
	python3 -m pip install build setuptools twine wheel -q

.PHONY: build
build: ensure-build-system
	python3 -m build --no-isolation

.PHONY: upload
upload: build
	python3 -m twine upload dist/*
