#!/bin/bash
source myenv/bin/activate
#prompt
instruct=$(cat prompt)

out=$(cat output.txt)

python vertex.py "$out" "$instruct" > outvertex.txt