.PHONY: build

build:
	Rscript -e 'library(devtools); document(); install()'

