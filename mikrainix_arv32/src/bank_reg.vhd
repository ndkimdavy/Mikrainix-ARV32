library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.arv32_pkg.all;

entity bank_reg is
   port(
       clk  : in std_logic;
       rs   : in std_logic;
       we   : in std_logic;
       addr : in std_logic_vector(4 downto 0);
       din  : in std_logic_vector(31 downto 0);
       dout : out std_logic_vector(31 downto 0)
   );
end entity bank_reg;

architecture rtl of bank_reg is

   signal regs : xregs_t := (others => (others => '0'));

begin

   process(clk, rs)
   begin
       if rs = '1' then
           regs <= (others => (others => '0'));
       elsif rising_edge(clk) then
           if we = '0' then
               dout <= regs(to_integer(unsigned(addr)));
           elsif we = '1' then
               if to_integer(unsigned(addr)) /= 0 then
                   regs(to_integer(unsigned(addr))) <= din;
               end if;
           end if;
       end if;
   end process;

end architecture rtl;