#!/usr/bin/env perl

$latex = 'uplatex %O -kanji=utf8 -no-guess-input-enc -synctex=1 -interaction=nonstopmode %S'; 

$pdflatex = 'pdflatex %O -synctex=1 -interaction=nonstopmode %S'; 

$lualatex = 'lualatex %O -synctex=1 -interaction=nonstopmode %S'; 

$xelatex = 'xelatex %O -no-pdf -synctex=1 -shell-escape -interaction=nonstopmode %S'; 

$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B'; 
$bibtex = 'upbibtex %O %B'; 

$makeindex = 'upmendex %O -o %D %S'; 

$dvipdf = 'dvipdfmx %O -o %D %S'; 

$dvips = 'dvips %O -z -f %S | convbkmk -u > %D'; 
$ps2pdf = 'ps2pdf.exe %O %S %D'; 
