----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 06:35:14 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is

type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal ram:mem:=(x"0002",
x"0004",--s=4
x"0004",
x"0004",--s=8
x"0009",
x"0003",
x"0001",
x"0008",--s=16
x"0006",
x"0009",
others =>x"0000");
begin


process(clk)
begin
    if rising_edge(clk)then
      if en ='1' then
        if MemWrite = '1' then
        ram(conv_integer(ALURes))<=RD2;
    end if;
    end if;
    end if;
    MemData <= ram(conv_integer(ALURes));
end process;

end Behavioral;
