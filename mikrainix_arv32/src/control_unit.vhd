library ieee;
use ieee.std_logic_1164.all;

library work;
use work.arv32_pkg.all;

-- CONTROL UNIT
-- Control signals:
-- reg_we   : 1=Write to register rd, 0=No register write
-- mem_we   : 1=Write to memory (STORE), 0=Read from memory (LOAD)
-- use_mem  : 1=Data from memory, 0=Data from ALU
-- use_imm  : 1=ALU uses immediate, 0=ALU uses register rs2
-- br       : 1=Branch instruction, 0=No branch
-- jmp      : 1=Jump instruction, 0=No jump

entity control_unit is
   port(
       clk      : in std_logic;
       rs       : in std_logic;
       bis      : in bis_t;
       alu_zero : in std_logic; 
       
       reg_we   : out std_logic;
       mem_we   : out std_logic;
       use_mem  : out std_logic;
       use_imm  : out std_logic;
       br       : out std_logic;
       jmp      : out std_logic
   );
end entity control_unit;

architecture rtl of control_unit is
begin

   process(clk, rs)
   begin
       if rs = '1' then
           reg_we  <= '0';
           mem_we  <= '0';
           use_mem <= '0';
           use_imm <= '0';
           br      <= '0';
           jmp     <= '0';
           
       elsif rising_edge(clk) then
           
           reg_we  <= '0';
           mem_we  <= '0';
           use_mem <= '0';
           use_imm <= '0';
           br      <= '0';
           jmp     <= '0';
           
           case bis is
               
               when BIS_LUI =>
                   reg_we  <= '1';
                   use_imm <= '1';
                   use_mem <= '0';
                   
               when BIS_AUIPC =>
                   reg_we  <= '1';
                   use_imm <= '1';
                   use_mem <= '0';
                   
               when BIS_JAL =>
                   jmp     <= '1';
                   reg_we  <= '1';
                   use_imm <= '1';
                   
               when BIS_JALR =>
                   jmp     <= '1';
                   reg_we  <= '1';
                   use_imm <= '1';
                   
               when BIS_BEQ  |
                    BIS_BNE  |
                    BIS_BLT  |
                    BIS_BGE  |
                    BIS_BLTU |
                    BIS_BGEU =>
                   br      <= '1';
                   use_imm <= '0';
                   
               when BIS_LB  |
                    BIS_LH  |
                    BIS_LW  |
                    BIS_LBU |
                    BIS_LHU =>
                   reg_we  <= '1';
                   use_imm <= '1';
                   use_mem <= '1';
                   mem_we  <= '0';
                   
               when BIS_SB |
                    BIS_SH |
                    BIS_SW =>
                   reg_we  <= '0';
                   use_imm <= '1';
                   mem_we  <= '1';
                   
               when BIS_ADDI  |
                    BIS_SLTI  |
                    BIS_SLTIU |
                    BIS_XORI  |
                    BIS_ORI   |
                    BIS_ANDI =>
                   reg_we  <= '1';
                   use_imm <= '1';
                   use_mem <= '0';
                   
               when BIS_SLLI |
                    BIS_SRLI |
                    BIS_SRAI =>
                   reg_we  <= '1';
                   use_imm <= '1';
                   use_mem <= '0';
                   
               when BIS_ADD  |
                    BIS_SUB  |
                    BIS_SLL  |
                    BIS_SLT  |
                    BIS_SLTU |
                    BIS_XOR  |
                    BIS_SRL  |
                    BIS_SRA  |
                    BIS_OR   |
                    BIS_AND =>
                   reg_we  <= '1';
                   use_imm <= '0';
                   use_mem <= '0';
                   
               when BIS_FENCE     |
                    BIS_FENCE_TSO |
                    BIS_PAUSE =>
                   null;
                   
               when BIS_ECALL  |
                    BIS_EBREAK =>
                   null;
                   
               when others =>
                   null;
                   
           end case;
       end if;
   end process;

end architecture rtl;