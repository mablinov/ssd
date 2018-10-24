library ieee;
use ieee.std_logic_1164.all;

entity ssd_ctrl_tb is
end entity;

architecture tb of ssd_ctrl_tb is
	signal clk: std_logic := '1';
	
begin
	clk <= not clk after 5 ns;
	
	uut: entity work.ssd_ctrl(rtl)
    generic map (
        DELAY => 2 ** 8
    )
    port map (
	    clk => clk,
	    d7 => X"00",
	    d6 => X"FF",
	    d5 => X"11",
	    d4 => X"AA",
	    d3 => X"BB",
	    d2 => X"CC",
	    d1 => X"DD",
	    d0 => X"EE",
		dig_en => open,
		seg_cs => open
	);
end architecture;

