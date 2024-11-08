<h1 align="center"> 🟦🟪🟨🟥🟧<a href="https://git.io/typing-svg"><img src="https://readme-typing-svg.herokuapp.com?font=Arial&weight=900&size=36&duration=3000&pause=500&color=FFFFFF&center=true&vCenter=true&width=340&height=35&lines=Tetris+Game+parte+2" alt="Typing SVG" /></a>🟦🟪🟨🟥🟧
</h1>

<h3 align="justify">Jogo inspirado no clássico Tetris, desenvolvido para o kit de desenvolvimento DE1-SoC utilizando linguagem C e Assembly </h3>


<div align="justify" id="sobre-o-projeto"> 
<h2> Sobre o Projeto</h2>

Este projeto se concentra no gerenciamento de uma Unidade de Processamento Gráfico (GPU) especializada, desenvolvida para manipulação de saídas gráficas em sistemas computacionais. Também conhecida como placa de vídeo, a GPU é responsável por aliviar a CPU de tarefas intensas relacionadas à renderização de gráficos, que demanda cálculos complexos e frequentes.

Diferente de outros componentes de hardware, uma GPU possui uma estrutura relativamente sofisticada, composta por unidades de lógica aritmética, registradores, e até memória dedicada, além de, em alguns casos, uma ISA própria para executar operações gráficas específicas. A interação com a GPU requer um software especializado que realize o gerenciamento adequado do dispositivo e estabeleça uma comunicação eficiente com o sistema, garantindo que os sinais digitais corretos sejam gerados para cada operação.

Nesse contexto, o problema 2 do módulo integrador TEC499 - SISTEMAS DIGITAIS do curso de Engenharia de Computação da UEFS propõe a criação de uma biblioteca em linguagem assembly para ARMv7, focada no gerenciamento da GPU. A GPU utilizada neste projeto foi projetada por Gabriel Sá Barreto Alves como parte de sua iniciação científica e trabalho de conclusão de curso, implementada em uma FPGA no kit DE1-SoC.

Este relatório aborda a construção desse sistema de gerenciamento para a GPU, explicando o desenvolvimento da biblioteca em assembly, a lógica de controle da GPU e a comunicação com o dispositivo, tudo integrado ao ambiente de desenvolvimento DE1-SoC para execução.

Os requisitos para elaboração do sistema são apresentados a seguir:

* O código da biblioteca deve ser escrito em linguagem aseembly; 
* A biblioteca deve conter as funções essenciais para que seja possível implementar a parte gráfica do jogo usando o Processador Gráfico;

<h2>  Equipe: <br></h2>
<uL> 
  <li><a href="https://github.com/Oguelo">Alex da Fonseca Dantas Junior</a></li>
  <li><a href="https://github.com/BRCZ1N">Bruno Campos de Oliveira Rocha</a></li>
  <li><a href="https://github.com/duasck">Luis Eduardo Leite Azevedo</a></li>
</ul>
</div>

<h1 align="center"> Sumário </h1>
<div id="sumario">
    <ul>
       <li><a href="#Introdução">Introdução</a></li>
        <li><a href="#Metodologia">Metodologia</a></li>
        <li><a href="#Resultados">Resultados</a></li>
        <li><a href="#makefile">Makefile</a></li>  
        <li><a href="#conclusao">Conclusão</a></li>
        <li><a href="#referencia">Referências</a></li>
  </ul>
</div>

## Metodologia

### Funcionamento da GPU

Para controlar a GPU, foi necessário entender a arquitetura e os modos de comunicação desta unidade gráfica. A GPU utiliza instruções de 64 bits e se comunica através dos barramentos de dados `DATA A` e `DATA B`. Abaixo, é detalhado o funcionamento da GPU:

- **Instruções de 64 Bits**: A GPU opera com instruções de 64 bits, onde o campo `opcode` (4 bits) no início da palavra identifica o tipo de operação. Dependendo da instrução, a palavra é dividida entre `DATA A` e `DATA B`. Quando o sinal `START` recebe um nível lógico alto, os valores de `DATA A` e `DATA B` são inseridos nas filas FIFO de instrução, e a GPU processa os dados conforme a operação indicada.

- **Controle de FIFO**: Um barramento de saída indica o estado das filas FIFO (se estão cheias), permitindo evitar a perda de instruções por excesso de inserção.

- **Memórias de Sprites e Background**: 
  - **Memória de Sprites**: Capaz de armazenar até 31 sprites simultâneas, cada sprite possui dados de cada pixel individualmente.
  - **Memória de Background**: Armazena 4800 blocos de 8x8 pixels, formando uma grade de 80x60 que compõe o fundo da tela.
  - **Registradores**: A GPU possui 32 registradores que guardam o endereço de cada sprite ativa. O registrador 1 é reservado para a cor de background.

- **Saída em VGA**: A GPU gera uma saída no formato VGA (640x480 pixels), que é enviada diretamente à porta VGA da placa, sem necessidade de tratamento adicional.

- **Gerenciamento de Polígonos**: A GPU é capaz de desenhar polígonos como quadrados ou triângulos de tamanhos predefinidos, selecionados via instrução.

### Instruções da GPU

A GPU utiliza quatro instruções principais, conforme descrito abaixo:

1. **WBR (0000 - Escrita no Banco de Registradores)**: Modifica o endereço de memória referenciado pelo registrador alvo, associando-o a uma sprite específica.

2. **WSM (0001 - Escrita na Memória de Sprites)**: Altera o valor de um endereço na memória de sprites, modificando o valor de um pixel da sprite.

3. **WBM (0010 - Escrita na Memória de Background)**: Modifica a cor de um bloco específico no background.

4. **DP  (0011 - Definição de Polígono)**: Define um polígono com tamanho, cor e posição específicas, associando-o a um registrador selecionado.

### Biblioteca

A biblioteca foi criada com o propósito de possibilitar a interação do usuário com a GPU, facilitando o envio de instruções e dados. Ela abstrai a complexidade do acesso direto aos 
registradores e buffers FIFO da GPU.

As principais funções da biblioteca estão localizadas no arquivo `GpuLib.asm` e incluem:

#### Função de Mapeamento de Memória (`gpuMapping`)

Responsável por abrir o dispositivo de memória e mapear o endereço base de controle da GPU. A função utiliza chamadas de sistema para abrir e mapear a memória, permitindo o acesso direto aos registradores da GPU.

#### Função de Fechamento de Mapeamento (`closeGpuMapping`)

Finaliza o mapeamento de memória, liberando os recursos e fechando o descritor de arquivo do dispositivo. Garante que a memória mapeada seja liberada corretamente, evitando erros em caso de múltiplas chamadas.

#### Função de Verificação de FIFO Cheia (`isFull`)

Verifica se o FIFO da GPU está cheio antes de enviar uma nova instrução. A função checa o estado do FIFO e retorna um valor indicando se ele está ocupado.

#### Função de Envio de Instruções (`sendInstruction`)

Envia uma instrução para a GPU. Antes de enviar, a função verifica o status do FIFO, e, se disponível, envia as instruções apropriadas nos barramentos correspondentes(DATA_A e DATA_B) para o dispositivo.

#### Funções de Configuração de Gráficos

Funções para configurar diversos aspectos gráficos da tela, incluindo:

- **Cor de Fundo (`setBackgroundColor`)**: Define a cor de fundo da tela utilizando valores RGB, utilizando a instrução **WBR** para escrever a cor no registrador no banco de registradores.

- **Blocos de Fundo (`setBackgroundBlock`)**: Permite configurar a cor de blocos específicos no plano de fundo da tela. Utiliza a instrução **WBM** para escrever diretamente na memória de background, alterando as cores dos blocos de 8x8 pixels.

- **Sprites (`setSprite`)**: Define a posição, offset e visibilidade das sprites na tela. Usa a instrução **WBR** para configurar o registrador do sprite, ajustando sua posição, offset e o bit de ativação que controla a exibição do sprite.

- **Polígono (`setPolygon`)**: Define polígonos com propriedades específicas, como posição e tamanho, para exibição na tela. Utiliza a instrução **DP** para desenhar o polígono na tela, configurando sua forma (quadrado ou triângulo), tamanho e coordenadas.

Essas funções no arquivo `GpuLib.asm` oferecem uma interface simplificada para manipulação da GPU, possibilitando o envio de comandos específicos sem a necessidade de acesso direto aos registradores e buffers FIFO.

### Resultados

Usando essas funções das bibliotecas desenvolvemos novas funções para o jogo são elas: 

- `drawBoard`: Esta função é responsável por desenhar o estado atual do tabuleiro do jogo. 
- `videoBox`: Esta função existia na primeira versão do game, onde, ao receber coordenadas iniciais e finais (x, y) e uma cor RGB, criava blocos gráficos na tela. Para manter a compatibilidade com a estrutura original do jogo, recriamos essa função na nova versão.
- `convertHexToRgb`: A função `convertHexToRgb` é necessária porque o `videoBox` recebe uma cor em formato hexadecimal RGB, enquanto nossa GPU exige um valor de 8 bits para cada componente de cor (`R`, `G` e `B`), com intensidade variando de 0 a 7. Assim, criamos essa função para converter as cores para o formato compatível com a GPU.
- `generateBox`: Esta função gera um bloco colorido no fundo, posicionando-o em uma localização específica baseada em coordenadas de coluna e linha (column e line). Recebe os valores de cor em componentes RGB (`R`, `G`, `B`) e o comprimento do bloco (length).
- `videoClear`: Limpa a tela.

##Funcionamento do jogo 
<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="gifsProjeto/funcionamento.gif" alt="Demonstração da jogabilidade do jogo." />
    <p>Demonstração da jogabilidade do jogo.</p>
</div>
<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="gifsProjeto/pause.gif" alt="Demonstração da marcação de pontos." />
    <p>Demonstração da função de pause.</p>
</div>
<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="gifsProjeto/pontuacao.gif" alt="Demonstração da marcação de pontos." />
    <p>Demonstração da pontuação.</p>
</div>
<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="gifsProjeto/gameOver.gif" alt="Demonstração da marcação de pontos." />
    <p>Demonstração do game over.</p>
</div>

<div align="justify" id="makefile"> 
<h2>Makefile</h2>

Para atender aos requisitos e simplificar o processo de compilação e execução do projeto, foi gerado um `Makefile`. Este arquivo serve como uma ferramenta que automatiza a construção do projeto, facilitando o gerenciamento do processo de compilação. O `Makefile` executa as seguintes operações:

- **Compilação**: Compila os arquivos de código-fonte em arquivos objeto.
- **Linkagem**: Combina os arquivos objeto em um executável.
- **Limpeza**: Remove arquivos temporários e o executável gerado.
- **Execução**: Permite iniciar o programa compilado.

</div>

<div  align="justify" id="execucao"> 
<h2>Guia de Instalação e Execução</h2>

Para iniciar o projeto, siga os passos abaixo para obter o código-fonte, compilar o código e executá-lo em um dispositivo FPGA DE1-SoC.

**Passo 1: Clonar o Repositório**

Abra o terminal e execute o seguinte comando para obter o código do repositório:

    git clone https://github.com/BRCZ1N/MI-SistemasDigitais-Problema-2.git

**Passo 2: Acessar o Diretório**

    cd MI-SistemasDigitais-Problema-2\Modules

**Passo 3: Compile e execute o código usando o comando:**

    make 

</div>

<div div align="justify" id="conclusao"> 
<h2> Conclusão</h2>

O desenvolvimento deste projeto de Tetris para a placa DE1-SoC, utilizando linguagem C, demonstrou a versatilidade e o poder de integração entre hardware e software oferecidos por essa plataforma. Ao implementar o jogo, foi possível explorar a interface gráfica transmitida via VGA, o controle responsivo utilizando um acelerômetro e botões, além da manipulação de memória e dispositivos de entrada/saída diretamente no hardware. Entretanto, não foi possível implementar recursos, tais como, rotação de tetrominos e aumento de nível com base na pontuação, esses recursos gerariam ainda mais diversidade e são possíveis de serem feitos com esse projeto base.
O projeto proporcionou uma oportunidade  de combinar conceitos de sistemas embarcados, como controle de periféricos, algoritmos de movimentação e colisão, e lógica de geração e remoção de peças, em uma aplicação prática e divertida. A utilização da DE1-SoC permitiu expandir o conhecimento sobre FPGAs, além de aprimorar as habilidades de programação em C para sistemas com recursos limitados.
<li><a href="#sumario">Voltar para o inicio</a></li>
 
</div>

<div id="referencia"> 
<h2> Referências</h2>
<ul>
<li><a href="https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/18.1/Computer_Systems/DE1-SoC/DE1-SoC_Computer_ARM.pdf">DE1-SoC Computer System with ARM* Cortex* A9 </a> - Acesso em 26 set. 2024. </li>
<li><a href="https://blogs.vmware.com/vsphere/2020/03/how-is-virtual-memory-translated-to-physical-memory.html"> NIELS HAGOORT. How is Virtual Memory Translated to Physical Memory? VMware vSphere Blog. </a> - Acesso em: 20 set. 2024.</li>
<li><a href="https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/17.0/Tutorials/Linux_On_DE_Series_Boards.pdf" > Using Linux* on DE-series Boards </a> - Acesso em 24 set 2024.</li>
‌</ul>
</div>
