library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

--ROM

ENTITY tb_ROM_block IS
END tb_ROM_block;

ARCHITECTURE behavior OF tb_ROM_block IS
COMPONENT dist_mem_gen_21
PORT(
--clka : IN STD_LOGIC;••••••••
a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;




--Inputs
signal clock : std_logic := '0';
signal rdaddress : std_logic_vector(15 downto 0) := (others => '0');

--Outputs
signal data : std_logic_vector(7 downto 0) := (others => '0');

-- Clock period definitions
constant clock_period : time := 5 ps;
--signal i: integer;
BEGIN
-- Read image in VHDL
uut: dist_mem_gen_21 PORT MAP (
--clka => clock,
spo => data,
a => rdaddress
);
-- Clock process definitions
--clock_process :process
--begin
--wait for clock_period/2;
--clock <= '1';
--wait for clock_period/2;
--end process;

-- Stimulus process
stim_proc: process
begin
for i in 0 to 65535 loop
rdaddress <= std_logic_vector(to_unsigned(i, 16));
wait for 5 ps;
end loop;
wait;
end process;
END;