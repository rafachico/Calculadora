# Calculadora

  O código para a execução do relógio consiste de dois arquivos, o primeiro(relógio_digital.vhd) executa a operação do relógio em si com a variação de cada digito, mas sempre trabalhando com inteiros. O segundo arquivo (relógio_digital_dec.vhd) é responsável por fazer a conversão do inteiro para um vetor com as posições corretas do display 7 segmentos. O primeiro arquivo começa chamando as bibliotecas e a função que se encontra no outro arquivo( work.bcd_decoder.all), em seguida passamos a entidade relógio_digital o primeiro passo é declarar o GENERIC nomeado SEG um inteiro de valor 4999999999, o qual sera usado no contador para identificar a passagem de 1 segundo, o próximo passo é definir as portas os displays são nomeados “HEX0” sendo o digito final sua posição. São declarados como saídas std_logic_vector de 6 a 0, o clock de 50 MHz também é definido como CLOCK_50 e entrada std_logic. Na arquitetura declaramos os sinais: 

* Counter (Inteiro de 0 a SEG) 
* M0(Inteiro de 0 a 9) 
* M1(Inteiro de 0 a 5) 
* S0 (Inteiro de 0 a 9) 
* S1(Inteiro de 0 a 5)

  Então definimos que os valores dos displays são obtidos usando a função criada para a conversão de inteiro para o vetor, assim chamamos a função para cada display com seu respectivo digito a ser exibido. Um process sensível ao clock é iniciado. Um condicional identifica a borda de subida do clock, um novo condicional identifica se counter é diferente de SEG, se for então incrementa 1 a counter, senão zera counter e incrementa um a S0, um novo condicional identifica se S0=9 se for então zera S0 e incrementa 1 a S1, um condicional identifica se S1=5, positivo zera S1 e incrementa M0, outro condicional identifica M0=9, correspondendo zera M0 e incrementa M1, um ultimo condicional identifica M1=5 e reinicia todos os dígitos. O segundo código contém um package nomeado bcd_decoder, o qual é uma função com entrada A(inteiro) e saída STD_LOGIC_VECTOR. Seu funcionamento baseia-se em um case que analisa o valor de A e retorna o valor correto para acionar o display 7 segmentos
