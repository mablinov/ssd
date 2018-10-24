library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssd_ctrl is
    generic (
        DELAY: positive := 10 ** 5
    );
	port (
	    clk: in std_logic;
	    d7, d6, d5, d4, d3, d2, d1, d0: in std_logic_vector(7 downto 0);
		dig_en: out std_logic_vector(7 downto 0) := X"00";
		seg_cs: out std_logic_vector(7 downto 0) := X"00"
	);
end entity;

architecture rtl of ssd_ctrl is
	signal dig_en_int: std_logic_vector(7 downto 0) := "11111110";

	signal cur_digit: natural range 0 to 7 := 0;
	signal delay_counter: natural range 0 to DELAY - 1 := 0;

	signal ctr_at_limit: boolean := false;
begin
	ctr_at_limit <= delay_counter = DELAY - 1;
	
	dig_en <= dig_en_int;
	
	display_next_digit: process (clk, ctr_at_limit, dig_en_int, cur_digit) is
	begin
		if rising_edge(clk) then
			if ctr_at_limit then
				dig_en_int <= std_logic_vector(rotate_left(unsigned(dig_en_int), 1));
				
				if cur_digit = 7 then
					cur_digit <= 0;
				else
					cur_digit <= cur_digit + 1;
				end if;
			end if;
		end if;
	end process;

	display_digit: process (clk, cur_digit, d0, d1, d2, d3, d4, d5, d6, d7) is
	begin
		if rising_edge(clk) then
			case cur_digit is
				when 0 => seg_cs <= not d0;
				when 1 => seg_cs <= not d1;
				when 2 => seg_cs <= not d2;
				when 3 => seg_cs <= not d3;
				when 4 => seg_cs <= not d4;
				when 5 => seg_cs <= not d5;
				when 6 => seg_cs <= not d6;
				when 7 => seg_cs <= not d7;
			end case;
		end if;
	end process;

	increment_counter: process (clk, ctr_at_limit, delay_counter) is
	begin
		if rising_edge(clk) then
			if ctr_at_limit then
				delay_counter <= 0;
			else
				delay_counter <= delay_counter + 1;
			end if;
		end if;
	end process;
	
end architecture;

