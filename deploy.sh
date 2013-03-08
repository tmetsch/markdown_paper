#!/bin/sh
case "$1" in
  pdf)
    rm -rf temp
    mkdir temp

    cp -r img temp/img
    cp -r template/* temp
    touch temp/out.md

    cat paper.md >> temp/out.md
    # If you have more chapters in seperate Markdown files use:
    # tail -n +4 chapter2.md >> temp/out.md

    cd temp
    multimarkdown -t latex out.md > out.tex

    cat ../header.tex | cat - out.tex > /tmp/out && mv /tmp/out out.tex
    sed -i 's/citep/cite/g' ./out.tex
    cat  ../footer.tex >> out.tex

    pdflatex -interaction=nonstopmode out.tex
    pdflatex -interaction=nonstopmode out.tex
    pdflatex -interaction=nonstopmode out.tex
    cp out.pdf ../paper.pdf
    cd ..
    ;;
  html)
    rm -rf web
    mkdir web
    multimarkdown -b *.md
    cp -r img/ web/img
    # If you have a style file uncomment:
    # cp style.css web/
    mv *.html web/
    ;;
  *)
    echo "Usage: $N {pdf,html}"
    exit 1
    ;;
esac

exit 0
