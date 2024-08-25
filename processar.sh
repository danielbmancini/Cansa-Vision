#!/bin/bash

#Utilizar as chaves do Azure
set -a
. ./.env
set +a

#Entrar no venv
source myenv/bin/activate

#nome do arquivo é o primeiro argumento
FILENAME="$1"

if [ ! -f "$FILENAME" ]; then
  echo "Arquivo não existe."
  exit 1
fi

#Definir o MIME_TYPE
case "${FILENAME##*.}" in
  pdf)
    MIME_TYPE="application/pdf"
    ;;
  png)
    MIME_TYPE="image/png"
    ;;
  jpg | jpeg)
    MIME_TYPE="image/jpeg"
    ;;
  tiff)
    MIME_TYPE="image/tiff"
  ;;
  *)
    echo "Extensão não suportado"
    exit 1
    ;;
esac

#Requisição ao Azure de um JSON contendo material reconhecido ópticamente, separados. Salvar em body.json
curl -H "Ocp-Apim-Subscription-Key: $AI_SERVICE_KEY" \
     -H "Content-Type: $MIME_TYPE" \
     --data-binary "@$FILENAME" \
     "$AI_SERVICE_ENDPOINT/computervision/imageanalysis:analyze?features=read&model-version=latest&language=en&api-version=2024-02-01" > body.json


#Coletar os 'text's da estrutura denotada abaixo e salvar em output.txt
jq -r '.readResult.blocks[].lines[].words[].text' body.json > output.txt 



#prompt
instruct=$(cat prompt)

out=$(cat output.txt)

#Requisição ao vertexAI para remover noise e induzir padrões 
python vertex.py "$out" "$instruct" > outvertex.txt

#limpar fin4pontos
echo "" > fin4pontos.txt

#organizar fin4pontos em tempos crescentes, representando dias
./organizar.awk outvertex.txt