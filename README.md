# Calculadora

Iniciando a descrição pelo código da conversão temos um package nomeado bcd_decoder, o qual é uma função com entrada A(inteiro) e saída STD_LOGIC_VECTOR. Seu funcionamento baseia-se em um case que analisa o valor de A e retorna o valor correto para acionar o display 7 segmentos. Os valores de variam de -7 a 49 visto que a calculadora só ira operar nesse intervalo. O vetor saída nem na posição 20 a 14 o sinal do número, na 13 a 7 o digito das dezenas e na posição de 6 a 0 as unidades. Caso seja pedido um numero fora do intervalo retornara traços. Passando ao código de cálculos temos a chamada das bibliotecas e do decodificador, na entidade as portas utilizadas são: 
* SW( entrada UNSIGNED(sem sinal) de 9 a 0) 
* KEY(entrada std_logic_vector de 3 a 0 
* HEX0(saídas std_logic_vector de 6 a 0 para cada display) 

Iniciando a arquitetura temos a definição de alguns sinais que serão utilizados para armazenar temporariamente os valores obtidos nas operações a serem realizadas: 
* Soma( Inteiro de -7 a 49) 
* S(Inteiro de -7 a 49) 
* As e bs(inteiro de 0 a 7) 
* Res, diga e digb( std_logic_vector de 20 a 0) 
* Sel(std_logic_vector 1 a 0) 
* Sinal(std_logic_vector 1 a 0) 
* R(Inteiro) 
* Rest(std_logic_vector 20 a 0) 

Definimos Sel como a conversão de SW( 5 a 4 ) para um std_logic_vector. Iniciamos um process(op) sensível em Sel,SW,as,bs,soma,S,R. “as” é SW(9 a 7) convertido para inteiro, “bs” é SW(2 a 0) convertido para inteiro. Um condicional verifica Sel=00, então soma = as + bs e S=soma. Senão e Sel=01 entao soma=as-bs e S=soma. Senão e Sel=10 então soma = as*bs e S=soma. Senão e Sel=11, e novo condicional com bs diferente de 0 soma= as/bs S=soma e R= as rem bs, Encerra-se o process(op) Um process(sig) sensível em Sel e SW com um condicional Sel=00 mostra”+” no display 2. Senão e Sel=01 mostra “-“. Senão e Sel=10 mostra ”X”. Senão e Sel=11 mostra”/”. O process(sig) acaba Abre-se o process(disp) sensível em KEY(3),Sel,res,rest,S,R,as,bs,diga,sinal,digb. Um condicional identifica se o botão 3 foi pressionado(vai para LOW), um condicional identifica Sel =11 e outro bs /= 0 entao res é S convertido pelo decoder e rest é R convertido pelo decoder. Disp 0 é os dígitos de 6 a 0 de rest. Disp 2 é “r”. Disp 3 é os dígitos de 6 a 0 de res e Disp 3 é “q”. Senão(bs=0). Disp 3 é “E”, Disp 2 é “r”, Disp1 é “r” e Disp0 é “o”. Senão (Sel /= 11) res é S convertido pelo decoder. Disp 0 é os dígitos de 6 a 0 de res, Disp 1 é os dígitos 13 a 7 de res, Disp 2 é os dígitos 20 a 14 de res e Disp 3 é “A”. Senão(Key(3) liberada) diga é as convertido por decoder digb é bs convertido por decoder. Disp 3 é “C”, Disp 2 é os dígitos 6-0 de diga, Disp 1 os dígitos 6-0 de sinal e Disp0 os dígitos 6-0 de digb
