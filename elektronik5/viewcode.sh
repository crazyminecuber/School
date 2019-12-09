#!/bin/bash
tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
cat start.tex > test.tex
python3 calculate.py >> test.tex
"\\end\{document\}" >> test.tex
pdflatex test.tex
zathura test.pdf
rm $tmpfile
