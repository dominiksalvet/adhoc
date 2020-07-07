--------------------------------------------------------------------------------
-- Copyright 2020 Dominik Salvet
-- github.com/dominiksalvet/risc63
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc63_pkg.all;

entity picker is
    port (
        i_opcode: in std_ulogic_vector(3 downto 0); -- picker opcode
        i_data_array: in std_ulogic_vector(63 downto 0);
        i_selector: in std_ulogic_vector(2 downto 0);
        o_result: out std_ulogic_vector(63 downto 0)
    );
end entity picker;

architecture rtl of picker is
    signal s_block_size: integer range 8 to 32; -- block size in bits
    signal s_block_index: integer range 0 to 7; -- final data index
    signal s_low_index: integer range 0 to 56;
    signal s_high_index: integer range 7 to 63;
begin

    with i_opcode select s_block_size <=
        8 when c_PICKER_EXTB | c_PICKER_EXTBU | c_PICKER_INSB | c_PICKER_MSKB,
        16 when c_PICKER_EXTW | c_PICKER_EXTWU | c_PICKER_INSW | c_PICKER_MSKW,
        32 when others;

    with s_block_size select s_block_index <=
        to_integer(unsigned(i_selector)) when 8,
        to_integer(unsigned(i_selector(2 downto 1))) when 16,
        to_integer(unsigned'(0 => i_selector(2))) when others;

    s_low_index <= s_block_index * s_block_size;
    s_high_index <= s_low_index + s_block_size - 1;

end architecture rtl;