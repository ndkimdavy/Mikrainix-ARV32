library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.arv32_pkg.all;

-- RV32I Base Instruction Set - Register Bank
-- Dual-port register file (2 read ports, 2 write ports)
-- 32 registers x0-x31, x0 always reads as zero
-- Synchronous read and write operations

entity bank_reg is
    port(
        clk      : in std_logic;
        rs       : in std_logic;
        bank_in  : in bank_input_t;
        bank_out : out bank_output_t
    );
end entity bank_reg;

architecture rtl of bank_reg is

    signal regs : xregs_t := (others => (others => '0'));

begin

    process(clk, rs)
    begin
        if rs = '1' then
            regs <= (others => (others => '0'));
            bank_out.data1 <= (others => '0');
            bank_out.data2 <= (others => '0');
            
        elsif rising_edge(clk) then
            
            if bank_in.we1 = '0' then
                bank_out.data1 <= regs(to_integer(unsigned(bank_in.addr1)));
            elsif bank_in.we1 = '1' then
                if to_integer(unsigned(bank_in.addr1)) /= 0 then
                    regs(to_integer(unsigned(bank_in.addr1))) <= bank_in.data1;
                end if;
            end if;
            
            if bank_in.we2 = '0' then
                bank_out.data2 <= regs(to_integer(unsigned(bank_in.addr2)));
            elsif bank_in.we2 = '1' then
                if to_integer(unsigned(bank_in.addr2)) /= 0 then
                    regs(to_integer(unsigned(bank_in.addr2))) <= bank_in.data2;
                end if;
            end if;
            
        end if;
    end process;

end architecture rtl;