----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

signal c_result : std_logic_vector(7 downto 0);
signal c_add    : unsigned(8 downto 0);
signal c_sub    : unsigned(8 downto 0);

begin

    c_add <= ('0' & unsigned(i_A)) + ('0' & unsigned(i_B));
    c_sub <= ('0' & unsigned(i_A)) - ('0' & unsigned(i_B));

    with i_op select
        c_result <= std_logic_vector(c_add(7 downto 0)) when "000",
                    std_logic_vector(c_sub(7 downto 0)) when "001",
                    i_A and i_B                          when "010",
                    i_A or i_B                           when "011",
                    (others => '0')                      when others;

    o_result <= c_result;

    -- Flags: N Z C V
    o_flags(3) <= c_result(7);                              -- N
    o_flags(2) <= '1' when c_result = "00000000" else '0';  -- Z

    -- C flag
    o_flags(1) <= c_add(8) when i_op = "000" else
                  '1' when i_op = "001" and unsigned(i_A) >= unsigned(i_B) else
                  '0';
                  
    -- V flag
    o_flags(0) <=
        (i_A(7) and i_B(7) and not c_result(7)) or
        ((not i_A(7)) and (not i_B(7)) and c_result(7))
        when i_op = "000" else

        (i_A(7) and (not i_B(7)) and not c_result(7)) or
        ((not i_A(7)) and i_B(7) and c_result(7))
        when i_op = "001" else

        '0';


end Behavioral;
