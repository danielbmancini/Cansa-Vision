import base64
import vertexai
from vertexai.generative_models import GenerativeModel, Part, FinishReason
from vertexai.generative_models import (
    GenerativeModel,
    GenerationConfig,
    SafetySetting,
    HarmCategory,
    HarmBlockThreshold,
)

import vertexai.preview.generative_models as generative_models
import sys 

def generate():
  #Alterar aqui para seu projeto e localização do servidor
  vertexai.init(project="atomic-monument-429817-b0", location="us-central1")
  model = GenerativeModel(
    "gemini-1.5-flash-001",
    system_instruction=[textsi_1]
  )
  #Dependendo da tarefa, como esta de extrair informações sensíveis, é necessário mudar as configurações de segurança
  safety_config = [
    SafetySetting(
        category=HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
        threshold=HarmBlockThreshold.BLOCK_ONLY_HIGH,
    ),
    SafetySetting(
        category=HarmCategory.HARM_CATEGORY_HARASSMENT,
        threshold=HarmBlockThreshold.BLOCK_ONLY_HIGH,
    ),
  ]

  responses = model.generate_content(
      [text1],
      generation_config=generation_config,
      safety_settings=safety_config,
      stream=True,
  )
  



  for response in responses:
    print(response.text, end="")

#definição de alguns parâmetros do gemini. Tomar argumentos passados por processar.sh
text1 = sys.argv[1]
textsi_1 = sys.argv[2]
generation_config = {
    "max_output_tokens": 8192,
    "temperature": 1,
    "top_p": 0.95,
}



generate()

