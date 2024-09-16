library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;




entity porteET is
		

port (
		A : in std_logic;
		B : in std_logic;
		C:  out std_logic
);
end entity porteET;
architecture TP1 of porteET is
	begin
	C<=A and B;

end architecture TP1 ;
