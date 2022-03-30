setup:
	ruby -v
	bundler install
PHONY: setup

clean-files:
	rm -rf assets/*
PHONY: clean-files

donwload-files:
	ruby ./src/pdf/download.rb
PHONY: donwload-files

extract:
	ruby ./src/pdf/extract.rb
PHONY: extract