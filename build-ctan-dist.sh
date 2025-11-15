#!/bin/sh

set -e
set -x

command_exists() {
    type "$1" &> /dev/null ;
}

if command_exists pandoc ; then
    pandoc --verbose \
           -f markdown+smart-raw_tex \
           -t latex \
           -o README.pdf \
           README.md
fi

${CC:-cc} -o skt skt.c



./skt sktdoc.skt sktdoc.tex

latexmk -gg -ps sktdoc.tex

latexmk -g -pdf sktdoc.tex

rm -f ./ps-type1/sktdoc.pdf
ln ./sktdoc.pdf ./ps-type1/sktdoc.pdf



./skt introtoskt.skt introtoskt.tex

latexmk -gg -ps introtoskt.tex

latexmk -g -pdf introtoskt.tex

rm -f ./ps-type1/introtoskt.pdf
ln ./introtoskt.pdf ./ps-type1/introtoskt.pdf


chmod -R +r .

list_files() {
    find ./ps-type1 -type f \
         \( -name '*.pfb' \
         -o -name '*.map' \
         -o -name 'sktdoc.pdf' \
         -o -name 'introtoskt.pdf' \
         -o -name 'README' \
         \) -print

    find . -maxdepth 1 -type f \
         \( -name '*.sh' \
         -o -name '*.mf' \
         -o -name '*.tfm' \
         -o -name '*.fd' \
         -o -name '*.sty' \
         -o -name '*.c' \
         -o -name 'sktdoc.ps' \
         -o -name 'sktdoc.pdf' \
         -o -name 'sktdoc.skt' \
         -o -name 'introtoskt.ps' \
         -o -name 'introtoskt.pdf' \
         -o -name 'introtoskt.skt' \
         -o -name 'README.md' \
         -o -name 'README.pdf' \
         \) -print
}


if command -v gtar >/dev/null 2>&1; then
    TAR=gtar
else
    TAR=tar
fi

list_files | sort | \
	"$TAR" -cvvzf sanskrit.tar.gz \
		-T - \
		--transform 's,^\./,sanskrit/,' \
		--owner=sanskrit \
		--group=ctan
