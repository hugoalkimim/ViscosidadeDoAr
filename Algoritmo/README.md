# Algoritmo

## Utilização do Algoritmo
Para que o algoritmo execute corremente é necessário utilizar uma imagem com o mesmo posicionamento e resolução do vídeo que será analisado. Uma maneira satisfatória de fazer isso é utilizando a mediana de cada pixel de um conjunto de frames do vídeo em que a esfera esteja em movimento. Neste repositório disponibilizamos o script que realiza esta tarefa com o nome "GeradorImagemReferencia.m", onde a mediana dos pixels de 100 frames é feita.
### Geração da imagem de referência
- Abra o arquivo GeradorImagemReferencia.m
- Insira o nome do video, sua resolução e o tempo inicial do video
- Rode o script

### Execução do Algoritmo
- Tenha uma imagem de referência pronta ou gere uma utilizando as instruções anteriores.
- Abra o arquivo AnalisadorDeImagem.m
- Defina os parâmetros que deseja utilizar. Caso seja necessário é possível executar o algoritmo apenas para alguns frames para verificar se tudo está funcionando corretamente.
- Rode o script

Será gerado um vídeo em que os pixels que foram analisados e foram considerados diferentes estão pintados de vermelho. Além disso, uma linha vermelha indicará a altura da esfera quando ela estiver descendo e uma linha verde indicará quando estiver subindo. Os dados gerados estarão no workspace do MatLab.
