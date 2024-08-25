# Cansa-Vision

Neste projeto, utiliza-se **Azure Computer Vision** + **VertexAI (gcloud)** para automatizar o processo de preenchimento de planilhas de cartões-ponto (final do texto) de todos os tipos, trabalho de escritório árduo e repetitivo.

## **Inicialização**
Para as classes Python, é necessário um ambiente _myenv_ com os requisitos instaláveis. 

Instale os requisitos e o repositório (linux) com os comandos:

```bash
git clone https://github.com/username/Cansa-Vision.git

python -m venv myenv
source myenv/bin/activate

pip install -r requirements.txt
```

São necessárias as chaves **Azure** `AI_SERVICE_KEY` e `AI_SERVICE_ENDPOINT` (de um projeto [computer vision](https://portal.azure.com/#create/Microsoft.CognitiveServicesComputerVision)) no arquivo de ambiente `.env`, que deve ser salvo na raiz do projeto.

Para o uso da **VertexAI**, é necessário autenticação com a ferramenta _gcloud_:

```bash
gcloud auth application-default login
```
Referência: [SDK](https://cloud.google.com/sdk/docs/cheatsheet?hl=pt-br)

Alterar a linha 17 em  [vertex.py](./processando-documentos-impressos/vertex.py) para definir o projeto gcp sendo usado:

```python
# Alterar aqui para seu projeto e localização do servidor
vertexai.init(project="projeto", location="localização")
```
## **Uso**

Aqui, tomamos digitalizações (e fotos com luz homogênea) dos pontos manuscritos dentro da pasta `pontos` e utiliza-se VertexAI para processar o _output_ cru (na verdade parte do conteúdo do [.json](./body.json)). Este projeto é uma generalização do [anterior](https://github.com/danielbmancini/Repite-AzureVision), e o uso de IA se dá pela diminuição de suposições sobre a estrutura do documento, o que permite utilização mais fácil desta utilidade. Ainda assim, o código opera sobre essas garantias:

- **Números não relacionados ao tempo**: O documento não contém números com mais de 2 dígitos que não se referem a tempos.
- **Tempos válidos**: O documento não inclui tempos que não fazem parte da tabela de tempos de interesse.
- **Horário de saída e entrada**: Em qualquer dia, um empregado não deve sair do serviço *antes* do horário de entrada do expediente no dia seguinte. Por exemplo, se o empregado sai às 19h e entra no dia seguinte às 19:01. (Essa regra pode ser ajustada para um tamanho específico de imagem, se necessário.)
- **Rotação ortogonal**: O documento é rotacionado corretamente (90°, reto, etc).
- **Digitalização**: Documentos são digitalizados ('escaneados').


Para começar, use o script shell/bash `processar.sh` como:

```bash
chmod +x processar.sh
./processar.sh <arquivo>
```


------

Após executar esse script, os pontos serão salvos no arquivo `fin4pontos.txt`. A classe **excel.py** insere esses dados em uma planilha no formato igual ao `modelo.xlsx`.

Uso de **excel.py**:

```bash
source ../myenv/bin/activate
python excel.py (dia do mês para colar a partir) (nome arquivo) (nome da folha MODELO) (nome funcionário)
```
Este projeto possui a capacidade de entender um número arbitrário de pontos num dado dia. 