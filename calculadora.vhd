library IEEE;-- chama as bibliotecas
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.bcd_decoder.all;--chama o decoder de 7seg no outro arquivo
 
entity calculadora is 
	port(
		SW: in unsigned( 9 downto 0 );-- define as chaves como binarios sem sinal
		KEY: in std_logic_vector (3 DOWNTO 0);--define os push-buttons
		HEX0  :OUT STD_LOGIC_VECTOR (6 downto 0);--disp1
		HEX1  :OUT STD_LOGIC_VECTOR (6 downto 0);--disp2
		HEX2  :OUT STD_LOGIC_VECTOR (6 downto 0);--disp3
		HEX3  :OUT STD_LOGIC_VECTOR (6 downto 0)--disp4

	);
end calculadora;
 
architecture operacoes of calculadora is
		signal soma: integer range -7 to 49; -- soma é um inteiro entre -7 e 49
		signal S: integer range -7 to 49;
		signal as,bs: integer range 0 to 7;
		signal res,diga,digb: std_LOGIC_VECTOR(20 downto 0);
		signal Sel: std_logic_vector(1 DOWNTO 0);
		signal sinal: std_logic_vector(6 DOWNTO 0);
		signal R : integer;
		signal rest : std_LOGIC_VECTOR(20 downto 0);
	begin
		Sel<= conv_std_logic_vector(SW(5 DOWNTO 4), 2);-- sel é as chaves 5 e 4 convertidas para vetor
		
	op: process(Sel,SW,as,bs,soma,S,R)
		Begin
			as <= conv_integer(SW(9 DOWNTO 7));-- as é chaves 9 à 7 convertidas pra inteiro
			bs <= conv_integer(SW(2 DOWNTO 0));-- as é chaves 2 à 0 convertidas pra inteiro
			if Sel="00" THEN -- se Sel for 00 entao soma é as + bs
				 soma<= (as) + (bs);
				 S<= soma;-- S é soma
			elsif Sel="01" THEN -- se Sel for 01 entao soma é as - bs
				 soma<= (as) - (bs);
				 S<= soma;
			elsif Sel="10" THEN -- se Sel for 10 entao soma é as * bs
				 soma<= (as) * (bs);
				 S<= soma;	
			elsif Sel="11" THEN --se Sel for 11 entao
				if bs /= 0 then --e se bs for diferente de entao
					soma<= (as) / (bs);-- soma é as/bs
					S<= soma; --S é soma
					R<= as rem bs; --R é o resto da divisão as/bs
				end if;
			end if;
	end process;
	
	sig: process(Sel,SW) -- process pra definir o sinal da operacoes
		Begin
			if Sel="00" THEN -- se Sel for 00 entao sinal é o vetor
				 sinal <= "0011010";
			elsif Sel="01" THEN
				 sinal <= "0111111";
			elsif Sel="10" THEN
				 sinal <= "0001001";
			elsif Sel="11" THEN
				 sinal <= "0101101";
			end if;
	end process;
	
	disp: process(KEY(3),Sel,res,rest,S,R,as,bs,diga,sinal,digb) -- process para exibir no display
		Begin
			if KEY(3)='0' THEN -- se a key(3) for pressionada
				if Sel="11" Then -- e se Sel for 11(divisao)
					if bs /= 0 Then --e se bs for diferentede 0
						res <= conviseg(S); --res é o vetor S convertido pela função conviseg
						rest <= conviseg(R); --rest é o vetor R convertido pela função conviseg
						HEX0 <= rest(6 DOWNTO 0);-- disp 1 é os 7 primeiros digitos de rest
						HEX1 <= "0101111";--disp 2 é "r"
						HEX2 <= res(6 DOWNTO 0);-- disp 3 é os 7 primeiros digitos de res
						HEX3 <= "0011000";--disp 4 é "q"
					else --senao(bs=0)
						HEX0 <= "0100011"; --disp 1 "o"
						HEX1 <= "0101111"; --disp 2 "r"
						HEX2 <= "0101111"; --disp 3 "r"
						HEX3 <= "0000110"; --disp 4 "E"
					end if;
					
				else--senao(Sel diferente de 11)
					res <= conviseg(S);--res é o vetor S convertido pela função conviseg
					HEX0 <= res(6 DOWNTO 0);-- disp 1 é os 7 primeiros digitos de res 
					HEX1 <= res(13 DOWNTO 7);-- disp 2 é os digitos de 14 a 8 de res
					HEX2 <= res(20 DOWNTO 14);-- disp 3 é os digitos de 21 a 15 de res
					HEX3 <= "0001000";--disp 4 é "A"
				end if;
					
			else--senao(Key(3) liberada)
				diga <= conviseg(as);-- diga é o vetor as convertido pela função conviseg
				digb <= conviseg(bs);-- diga é o vetor bs convertido pela função conviseg
				HEX3 <= "1000110";-- disp 4 é "C"
				HEX2 <= diga(6 DOWNTO 0);-- disp 3 e é os 6 primeiros digitos de diga
				HEX1 <= sinal(6 DOWNTO 0);--disp 2 é o vetor em sinal
				HEX0 <= digb(6 DOWNTO 0);-- disp 1 e é os 6 primeiros digitos de digb
			end if;
	end process;
end operacoes;
 