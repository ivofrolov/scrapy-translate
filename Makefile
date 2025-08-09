.DEFAULT_GOAL := install

package = scrapy_translate
tests = tests

.PHONY: format
format:
	ruff format $(package) $(tests)

.PHONY: lint
lint:
	ruff check --output-format pylint $(package) $(tests)
	pyright $(package)

.PHONY: install
install:
	python3 -m pip install --editable .

.PHONY: test
test:
	python3 -m unittest

.PHONY: build
build:
	python3 -m build --no-isolation

.PHONY: upload
upload: build
	python3 -m twine upload dist/*
