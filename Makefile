setup:
	ruby -v
	bundler install
PHONY: setup

clean-files:
	rm -rf assets/*
PHONY: clean-files

donwload-files:
	ruby ./src/scripts/download.rb
PHONY: donwload-files

extract:
	ruby ./src/scripts/extract.rb
PHONY: extract