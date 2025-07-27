library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.arv32_pkg.all;

entity alu is
  port(
      clk     : in std_logic;
      rs      : in std_logic;
      alu_in  : in alu_input_t;
      alu_out : out alu_output_t
  );
end entity alu;

architecture rtl of alu is
    signal result_tmp : std_logic_vector(31 downto 0);
begin

  process(clk, rs)
    variable result_var : std_logic_vector(31 downto 0);
  begin
      if rs = '1' then
          result_tmp <= (others => '0');
          alu_out.zero <= '0';
          
      elsif rising_edge(clk) then
          
          case alu_in.bis is
              
              when BIS_LUI =>
                  result_var := alu_in.a;
                  
              when BIS_AUIPC =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
                  
              when BIS_JAL =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
                  
              when BIS_JALR =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
                  
              when BIS_BEQ =>
                  if alu_in.a = alu_in.b then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_BNE =>
                  if alu_in.a /= alu_in.b then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_BLT =>
                  if signed(alu_in.a) < signed(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_BGE =>
                  if signed(alu_in.a) >= signed(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_BLTU =>
                  if unsigned(alu_in.a) < unsigned(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_BGEU =>
                  if unsigned(alu_in.a) >= unsigned(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
                  
              when BIS_LB  |
                   BIS_LH  |
                   BIS_LW  |
                   BIS_LBU |
                   BIS_LHU =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
                  
              when BIS_SB |
                   BIS_SH |
                   BIS_SW =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
                  
              when BIS_ADDI =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
              
              when BIS_SLTI =>
                  if signed(alu_in.a) < signed(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
              
              when BIS_SLTIU =>
                  if unsigned(alu_in.a) < unsigned(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
              
              when BIS_XORI =>
                  result_var := alu_in.a xor alu_in.b;
              
              when BIS_ORI =>
                  result_var := alu_in.a or alu_in.b;
              
              when BIS_ANDI =>
                  result_var := alu_in.a and alu_in.b;
              
              when BIS_SLLI =>
                  result_var := std_logic_vector(shift_left(unsigned(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));
              
              when BIS_SRLI =>
                  result_var := std_logic_vector(shift_right(unsigned(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));
              
              when BIS_SRAI =>
                  result_var := std_logic_vector(shift_right(signed(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));
              
              when BIS_ADD =>
                  result_var := std_logic_vector(signed(alu_in.a) + signed(alu_in.b));
              
              when BIS_SUB =>
                  result_var := std_logic_vector(signed(alu_in.a) - signed(alu_in.b));
              
              when BIS_SLL =>
                  result_var := std_logic_vector(shift_left(unsigned(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));
              
              when BIS_SLT =>
                  if signed(alu_in.a) < signed(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
              
              when BIS_SLTU =>
                  if unsigned(alu_in.a) < unsigned(alu_in.b) then
                      result_var := x"00000001";
                  else
                      result_var := x"00000000";
                  end if;
              
              when BIS_XOR =>
                  result_var := alu_in.a xor alu_in.b;

              when BIS_SRL =>
                  result_var := std_logic_vector(shift_right(unsigned(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));

              when BIS_SRA =>
                  result_var := std_logic_vector(shift_right(signed(alu_in.a), to_integer(unsigned(alu_in.b(4 downto 0)))));

              when BIS_OR =>
                  result_var := alu_in.a or alu_in.b;

              when BIS_AND =>
                  result_var := alu_in.a and alu_in.b;

              when BIS_FENCE     |
                   BIS_FENCE_TSO |
                   BIS_PAUSE =>
                  result_var := (others => '0');

              when BIS_ECALL  |
                   BIS_EBREAK =>
                  result_var := (others => '0');

              when others =>
                  result_var := (others => '0');

          end case;
          
          result_tmp <= result_var;

          if result_var = x"00000000" then
              alu_out.zero <= '1';
          else
              alu_out.zero <= '0';
          end if;
          
      end if;
  end process;

  alu_out.result <= result_tmp;

end architecture rtl;