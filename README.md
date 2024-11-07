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
        <li><a href="#equipamentos">Descrição dos Equipamentos e Software Utilizados</a></li>
        <li><a href="#arq_CPU"> Estrutura da Placa DE1-SoC </a></li>
        <li><a href="#Drives">Drives de Dispositivos de Entrada e Saída (E/S)</a></li>
        <li><a href="#Acelerometro">Acelerômetro</a></li>
        <li><a href="#Interface-Grafica">Interface do Usuário</a></li>
        <li><a href="#Regras-de-jogo">Dinâmica e Regras de Jogo</a></li>
        <li><a href="#Algoritmos">Algoritmos de Jogo</a></li>
        <li><a href="#Funcionamento">Funcionamento do jogo</a></li>
        <li><a href="#execucao"> Como Usar </a></li>
         <li><a href="#makefile">Makefile</a></li>  
        <li><a href="#conclusao">Conclusão</a></li>
        <li><a href="#referencia">Referências</a></li>
  </ul>
</div>


<div align="justify" id="equipamentos"> 
<h2> Descrição dos Equipamentos e Software Utilizados</h2>

Nesta seção, são apresentados os equipamentos e software utilizados durante o desenvolvimento do projeto.

<h3>Kit de desenvolvimento DE1-SoC</h3>

A placa DE1-SoC é um kit de desenvolvimento que integra um processador ARM Cortex-A9 dual-core com um FPGA Cyclone V da Intel, proporcionando uma poderosa plataforma para projetos que combinam software e hardware. Com uma ampla variedade de periféricos, como portas VGA, Ethernet, USB, e áudio, a DE1-SoC é ideal para aplicações em sistemas embarcados e FPGA. Devido à sua versatilidade, essa placa é amplamente utilizada em ambientes educacionais e de pesquisa, facilitando o aprendizado e o desenvolvimento de projetos em ambas as áreas.
Abaixo estão os elementos utilizados na construção desse projeto:

| Categoria                               | Detalhes                                       |
| --------------------------------------- | ---------------------------------------------- |
| **FPGA**                          | Cyclone V SoC 5CSEMA5F31C6                     |
| Logic Elements                          | 85K                                            |
| Memória Embarcada                      | 4,450 Kbits                                    |
| PLLs Fracionais                         | 6                                              |
| Controladores de Memória               | 2                                              |
| **Configuração e Depuração**  | Dispositivo de Configuração Serial (EPCS128) |
| On-Board                                | USB Blaster II                                 |
| **Memória**                      | 64MB SDRAM                                     |
| DDR3 SDRAM                              | 1GB                                            |
| Micro SD                                | Sim                                            |
| **Comunicação**                 | 2 Portas USB 2.0                               |
| Ethernet                                | 10/100/1000                                    |
| **Display**                       | VGA DAC 24-bit                                 |
| Entrada de Vídeo                       | Decodificador TV                               |
| **Botões, Interruptores e LEDs** | 
4 Teclas de Usuário (FPGA)                    |
| 2 Botões de Reset (HPS)                |                                                |
| **Energia**                       | Entrada DC 12V                                 |

<h3> Linguagem C</h3>
A linguagem C foi escolhida por sua eficiência, portabilidade e ampla aplicação em sistemas embarcados. Com uma sintaxe simples, ela oferece controle preciso sobre o hardware, além de contar com bibliotecas padrão e ferramentas que facilitam o desenvolvimento de código compacto e otimizado, ideal para dispositivos com recursos limitados.

<h3> Linguagem Assembly</h3>
A linguagem assembly foi escolhida por sua capacidade de oferecer controle direto sobre o hardware, permitindo o máximo de otimização e eficiência em sistemas embarcados. Com uma sintaxe próxima ao código de máquina, o assembly possibilita o uso específico de registradores e instruções, aproveitando ao máximo os recursos da arquitetura ARMv7. Essa escolha é ideal para aplicações em que desempenho e controle absoluto sobre o processamento são essenciais, especialmente em dispositivos com recursos limitados, onde o gerenciamento preciso do hardware é fundamental.

<h3> Compilador GNU</h3>

O GCC, abreviação de "GNU Compiler Collection" (Coleção de Compiladores GNU), é uma popular distribuição de compiladores que oferece suporte a diversas linguagens de programação, como C, C++, Objective-C, Fortran e Ada. Quando executado, o GCC realiza várias etapas, incluindo pré-processamento, compilação, montagem e vinculação. Ele também disponibiliza uma ampla variedade de opções de linha de comando, permitindo que o desenvolvedor personalize o processo de compilação conforme suas necessidades específicas.

<div align="justify" id="arq_CPU">
<h2> Estrutura da Placa DE1-SoC </h2>

Nesta parte, será detalhada a arquitetura da placa DE1-SoC, incluindo o processador ARM Cortex-A9, a organização dos registradores, o mapeamento dos dispositivos de entrada/saída na memória, o uso da memória, a comunicação entre o processador e o FPGA, além do processo de compilação nativa diretamente na placa.

<h3>Resumo dos Recursos do Processador ARM Cortex-A9 </h3>

O ARM Cortex-A9 é baseado em uma arquitetura RISC (Reduced Instruction Set Computing), onde operações aritméticas e lógicas são realizadas nos registradores de propósito geral. A movimentação de dados entre memória e registradores é feita através de instruções Load e Store, com comprimento de palavra de 32 bits e endereçamento em estilo little-endian.

<h3>Organização dos Registradores</h3>

O processador ARM Cortex-A9 contém 15 registradores de propósito geral (R0 a R14), um contador de programa (R15) e um registrador de status do programa atual (CPSR), todos com 32 bits. Dois registradores têm tratamento especial: R13 é o Stack Pointer, enquanto R14 atua como registrador de link em chamadas de sub-rotina.

<h3>Instruções e Modo Thumb</h3>

As instruções têm 32 bits e são armazenadas na memória com alinhamento de palavras. O conjunto de instruções Thumb oferece uma versão reduzida com instruções de 16 bits, o que diminui os requisitos de memória, algo útil em sistemas embarcados.

<h3>Memória Utilizada</h3>

O HPS (Hard Processor System) conta com uma interface de memória que conecta o ARM MPCORE a uma memória DDR3 de 1 GB. Esta memória serve como armazenamento de dados e programas para os processadores ARM. Organizada como 256M x 32 bits, ela pode ser acessada por palavras de 32 bits, meias palavras e bytes.

<h3>Mapeamento de Dispositivos de Entrada/Saída</h3>

Os dispositivos de E/S disponíveis ao processador ARM são mapeados diretamente na memória e acessados como se fossem endereços de memória, utilizando as instruções Load e Store.

<h3>Interrupções de Hardware</h3>

Dispositivos de E/S podem gerar interrupções de hardware, ativando as linhas de solicitação de interrupção (IRQ ou FIQ) do processador. Quando ocorre uma interrupção, o processador entra no modo de exceção correspondente e salva o estado atual do programa. Antes de retornar à execução, o endereço salvo no registrador de link deve ser decrementado em 4.

<h3>Diagrama de Blocos da Placa DE1-SoC</h3>

O sistema DE1-SoC é composto pelo HPS e pelo FPGA, ambos integrados no chip Cyclone V SoC. O HPS inclui um processador ARM Cortex-A9 dual-core, uma interface de memória DDR3 e periféricos. O FPGA implementa dois processadores Intel Nios II e vários periféricos conectados.

<h3>Compilação Nativa na DE1-SoC</h3>

A compilação nativa ocorre quando o código é compilado no mesmo sistema em que será executado. Aqui, a compilação será realizada diretamente na placa, utilizando a linha de comando do Linux e as ferramentas de compilação integradas. O comando `gcc` invoca o GNU C Compiler, um compilador de código aberto muito usado para gerar executáveis no Linux.

</div>


<div align="justify" id="Bibliotecas"> 

# Resumo da Biblioteca para Gerenciamento de GPU em Assembly
Esta biblioteca em assembly ARMv7 foi projetada para controle direto de uma GPU implementada em FPGA, permitindo mapeamento de memória, configuração de fundo e sprites, e manipulação de polígonos. Abaixo está uma visão geral das principais funções e os endereços de memória usados para interagir com o hardware gráfico. Para realizar a comunicação com a GPU, este projeto utiliza a linguagem Assembly. O mapeamento de memória é realizado por meio de chamadas de sistema (syscalls). São utilizadas quatro syscalls específicas: `open`, passando a constante 5, para abrir o diretório `/dev/mem`; `close`, com a constante 6, para fechar o diretório; `mmap2`, com a chamada 192, uma vez que o ARMv7 não possui `mmap`; e, finalmente, `munmap` para desmapear a memória.

<h3> Mapeamento de Memória e Controle da GPU</h3>

- `gpuMapping`: Configura o mapeamento da GPU, acessando o endereço /dev/mem para acesso direto ao hardware. Endereço base: `0xFF200000` (definido como `ALT_LWFPGASLVS_OFST`), usado para o mapeamento de I/O leve da FPGA.
- `closeGpuMapping`: Desfaz o mapeamento, liberando a memória de `virtual_base` e fechando o descritor `fd`.

<h3>Controle da FIFO</h3>

- `isFull`:Verifica o status da FIFO, acessando o endereço `0xFF2000B0`. Retorna 0 se não está cheia.
- `sendInstruction`:Envia instruções para a GPU, garantindo que a FIFO esteja vazia antes do envio.
  - Endereços envolvidos:
    - `0xFF2000B0`: Verifica o status da FIFO.
    - `0xFF2000C0`: Controla o sinal de escrita da instrução.
    - `0xFF200080` e `0xFF200070`: Armazenam os dados e endereços da instrução a ser enviada.

<h3>Configuração do Fundo e Sprites</h3>

- `setBackgroundColor`: Define a cor de fundo da tela, combinando os valores RGB de três registros.
  - Parâmetros RGB: `R0` (Red), `R1` (Green), `R2` (Blue).
- `setBackgroundBlock`: Configura um bloco específico no fundo com uma cor, permitindo criar mosaicos no background.
  - Endereçamento:
    - Colunas e linhas são organizadas em blocos 8x8 para uma personalização eficiente.
- `setSprite`: Define a posição, cor e ID de um sprite, manipulando-o diretamente em memória.
  - Endereços de controle:
    - `R0`, `R1`, `R2`, e `R3` para ID, posição X, posição Y e cor do sprite, respectivamente.

<h3>Configuração de Polígonos</h3>

- `setPolygon`: Define um polígono em uma posição com cor e formato específico (quadrado ou triângulo).
  - Parâmetros de Controle:
    - ID e tipo do polígono, posição de referência, e cor.

<h3>Endereços Utilizados</h3>

- `0xFF200000`: Base de mapeamento de memória para a GPU.
- `0xFF2000B0`: Verifica status da FIFO (usado em isFull e sendInstruction).
- `0xFF2000C0`: Sinal de escrita para envio de instrução.
- `0xFF200080`: Dados da instrução.
- `0xFF200070`: Endereço de instrução.

## Funções da biblioteca usadas no game

A biblioteca identificada como `GpuLib` é responsável pela comunicação com o dispositivo de saída VGA. As funções utilizadas são:

- `gpuMapping`: Abre o dispositivo de vídeo e mapeia.
- `closeGpuMapping`: Fecha o dispositivo de vídeo e desmapeia.
- `setBackgroundColor`: Define uma cor de fundo.
- `setBackgroundBlock`: Semelhante a anterior, define uma cor de fundo, porém não para tela inteira mas sim para um bloco determinado.
- `isFull`: Confere o status da FIFO.

Usando essas funções das bibliotecas desenvolvemos novas funções para o jogo são elas: 

- `drawBoard`: Esta função é responsável por desenhar o estado atual do tabuleiro do jogo. 
- `videoBox`: Esta função existia na primeira versão do game, onde, ao receber coordenadas iniciais e finais (x, y) e uma cor RGB, criava blocos gráficos na tela. Para manter a compatibilidade com a estrutura original do jogo, recriamos essa função na nova versão.
- `convertHexToRgb`: A função `convertHexToRgb` é necessária porque o `videoBox` recebe uma cor em formato hexadecimal RGB, enquanto nossa GPU exige um valor de 8 bits para cada componente de cor (`R`, `G` e `B`), com intensidade variando de 0 a 7. Assim, criamos essa função para converter as cores para o formato compatível com a GPU.
- `generateBox`: Esta função gera um bloco colorido no fundo, posicionando-o em uma localização específica baseada em coordenadas de coluna e linha (column e line). Recebe os valores de cor em componentes RGB (`R`, `G`, `B`) e o comprimento do bloco (length).
- `videoClear`: Limpa a tela.

## Botões

Para usar os botões, usamos mapeamento de memoria com linguagem C, 
</div>

<div div align="justify" id="Funcionamento"> 
<h2> Funcionamento do jogo</h2>
<div display= "flex" justify-content= "center" align="center"> 
  
<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="Imagens/1.gif" alt="Tela do jogo." />
    <p>Tela do jogo.</p>
</div>

 <div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="Imagens/5.gif" alt="Como controlar o jogo." />
    <p>Como controlar o jogo.</p>
</div>

<div style="display: flex; justify-content: center; align-items: center; flex-direction: column; text-align: center;">
    <img src="Imagens/6.gif" alt="Demonstração da jogabilidade do jogo." />
    <p>Demonstração da jogabilidade do jogo.</p>
</div>

<div display= "flex" justify-content= "center" align="center">
        <img src="Imagens/9.png" alt="Localização do botão na placa." />
        <p>Localização do botão na placa.</p>
</div>

</div>

Para controlar as peças, o jogador deve inclinar a placa no eixo horizontal, o que permite mover as peças para a esquerda ou para a direita. Além disso, o jogo possui uma função de pausa: para pausar, o jogador deve pressionar o botão 1 na placa.
Se as peças alcançarem o topo da tela, o jogo termina e reinicia. Caso a pontuação do jogador seja superior à maior pontuação registrada, ela será definida como o novo high score.
</div>


<div align="justify" id="makefile"> 
<h2>Makefile</h2>

Para atender aos requisitos e simplificar o processo de compilação e execução do programa em C, foi criado um `Makefile`. Este arquivo serve como uma ferramenta que automatiza a construção do projeto, facilitando o gerenciamento do processo de compilação. O `Makefile` executa as seguintes operações:

- **Compilação**: Compila os arquivos de código-fonte em arquivos objeto.
- **Linkagem**: Combina os arquivos objeto em um executável.
- **Limpeza**: Remove arquivos temporários e o executável gerado.
- **Execução**: Permite iniciar o programa compilado.

</div>


<div  align="justify" id="execucao"> 
<h2>Como usar</h2>


Para iniciar o projeto, siga os passos abaixo para obter o código-fonte, compilar o código em C e executa-lo em um dispositivo FPGA DE1-SoC. 

**Passo 1: Clonar o Repositório**

Abra o terminal e execute o seguinte comando para obter o código do repositório:

    git clone https://github.com/BRCZ1N/MI-SistemasDigitais-Problema-1.git

**Passo 2: Acessar o Diretório e Compilar o Código em C**

    cd MI-SistemasDigitais-Problema-1\Modulos

Compile e execute o código usando o comando:

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
