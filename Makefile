PERL6     := perl6
LIBPATH   := lib

# set below to 1 for no effect, 1 for debugging messages
DEBUG := MISC_UTILS_DEBUG=0

# set below to 0 for no effect, 1 to die on first failure
EARLYFAIL := PERL6_TEST_DIE_ON_FAIL=0

# set below for 0 for no effect and 1 to run Test::META
TA := TEST_AUTHOR=1

.PHONY: test bad good doc

default: test

TESTS     := t/*.t
BADTESTS  := bad-tests/*.t
GOODTESTS := good-tests/*.t

# the original test suite (i.e., 'make test')
test:
	for f in $(TESTS) ; do \
	    $(DEBUG) $(TA) $(EARLYFAIL) PERL6LIB=$(LIBPATH) prove -v --exec=$(PERL6) $$f ; \
	done

bad:
	for f in $(BADTESTS) ; do \
	    $(DEBUG) $(TA) $(EARLYFAIL) PERL6LIB=$(LIBPATH) prove -v --exec=$(PERL6) $$f ; \
	done

good:
	for f in $(GOODTESTS) ; do \
	    $(DEBUG) $(TA) $(EARLYFAIL) PERL6LIB=$(LIBPATH) prove -v --exec=$(PERL6) $$f ; \
	done

# generate PDF docs from pod; requires:
#   Perl 6 module:  Pod::To::Markdown
#   Debian packages: texlive-latex-base texlive-latex-recommended pandoc
doc: docs
docs: md pdf

pdf: md
	    pandoc Misc-Utils.md --latex-engine=pdflatex -o Misc-Utils.pdf
	    pandoc README-0.md --latex-engine=pdflatex -o README-0.pdf

md:
	    perl6 --doc=Markdown lib/Misc/Utils.pm6 > Misc-Utils.md
	    perl6 --doc=Markdown README.pod6 > README-0.md
