library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;




entity ADDIT is
		
port (
	A: in std_logic;
	B: in std_logic;
	cin: in std_logic;
	cout:out std_logic;
	S:out std_logic
		
);
end entity ADDIT;
architecture TP1 of ADDIT is
	
	begin
			S<=A XOR cin XOR B;
			cout<=(A and B ) or (cin and (A or B));
	

end architecture TP1 ;
