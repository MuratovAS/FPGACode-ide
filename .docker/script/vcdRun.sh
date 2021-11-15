#!/bin/sh
vcd `find -name '*.vcd' -type f | fzf --layout=reverse  --preview './vcd -i=0 {}' --color=bw`