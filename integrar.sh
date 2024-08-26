#!/bin/bash

#Fazer tudo de uma vez
#Uso: ./integrar.sh <arquivo> <linha> <funcionario>

./processar.sh "$1"

source myenv/bin/activate

nome="$3"
linha="$2"
nome_arquivo="000 - $nome - REF 08-2024"


coluna=$(awk -F ' ' '{print NF}' fin4pontos.txt | sort -n | tail -1)

#nova planilha se não existe
if [ ! -f "$nome_arquivo.xlsx" ]; then
  if [ "$coluna" -gt 5 ]; then
    cp "modelo6.xlsx" "$nome_arquivo.xlsx"
  else
    cp "modelo.xlsx" "$nome_arquivo.xlsx"
  fi
  sheet="MODELO"
else
  sheet="$nome"
fi

#colocar os dados na planilha
if [ "$coluna" -gt 5 ]; then
  python excel6.py "$linha" "$nome_arquivo" "$sheet" "$nome"
else
  sed --in-place 's/://g' fin4pontos.txt
  python excel.py "$linha" "$nome_arquivo.xlsx" "$sheet" "$nome"
fi

