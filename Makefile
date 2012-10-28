# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx/sphinx-build.py
PAPER         =
BUILDDIR      = build

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help clean html diss doctest

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  pdf        to make LaTeX files and run pdflatex"
	@echo "  diss       to make pdf, docx and html"

clean:
	-rm -rf $(BUILDDIR)/*

html:
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."


pdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through pdflatex..."
	make -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex finished; the PDF files are in _build/latex."

diss:
	@echo "============="
	@echo "Building Diss"
	@echo "============="
	@echo
	@echo "------------------------"
	@echo "Cleaning build directory"
	@echo "------------------------"
	@echo
	rm -rf $(BUILDDIR)/*
	@echo
	@echo "----------------------------"
	@echo "Running Sphinx LaTeX-Builder"
	@echo "----------------------------"
	@echo
	$(SPHINXBUILD) -a -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo
	@echo "----------------------"
	@echo "Modifying latex source"
	@echo "----------------------"
	@echo
	python latex4diss.py
	@echo
	@echo "----------------------------------"
	@echo "Running LaTeX files through rubber"
	@echo "----------------------------------"
	@echo
	cd $(BUILDDIR)/disslatex && rubber --verbose --warn all --pdf *.tex
	@echo
	@echo "rubber finished; the PDF files are in $(BUILDDIR)/disslatex."
	@echo
	@echo "---------------------------"
	@echo "Running Sphinx docx-Builder"
	@echo "---------------------------"
	@echo
	$(SPHINXBUILD) -a -b docx $(ALLSPHINXOPTS) $(BUILDDIR)/docx
	@echo
	@echo "Build finished. The .docx-file is in $(BUILDDIR)/doxc."
	@echo
	@echo "---------------------------"
	@echo "Running Sphinx HTML-Builder"
	@echo "---------------------------"
	@echo
	$(SPHINXBUILD) -a -E -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

