library ieee;
use ieee.std_logic_1164.all;

library work;
use work.arv32_pkg.all;

-- RV32I Base Instruction Set - Control Unit
--
-- Output control signals:
-- reg_we : 1=Write to register rd, 0=No register write
-- mem_we : 1=Write to memory (STORE), 0=Read from memory (LOAD)

entity control_unit is
    port(
        clk      : in std_logic;
        rs       : in std_logic;
        bis      : in bis_t;
        alu_zero : in std_logic; 
        reg_we   : out std_logic;
        mem_we   : out std_logic
    );
end entity control_unit;

architecture rtl of control_unit is
begin

    process(clk, rs)
    begin
        if rs = '1' then
            reg_we <= '0';
            mem_we <= '0';
            
        elsif rising_edge(clk) then
            
            reg_we <= '0';
            mem_we <= '0';
            
            case bis is
                
                when BIS_LUI =>
                    reg_we <= '1';
                    
                when BIS_AUIPC =>
                    reg_we <= '1';
                    
                when BIS_JAL =>
                    reg_we <= '1';
                    
                when BIS_JALR =>
                    reg_we <= '1';
                    
                when BIS_BEQ  |
                     BIS_BNE  |
                     BIS_BLT  |
                     BIS_BGE  |
                     BIS_BLTU |
                     BIS_BGEU =>
                    null;
                    
                when BIS_LB  |
                     BIS_LH  |
                     BIS_LW  |
                     BIS_LBU |
                     BIS_LHU =>
                    reg_we <= '1';
                    
                when BIS_SB |
                     BIS_SH |
                     BIS_SW =>
                    mem_we <= '1';
                    
                when BIS_ADDI  |
                     BIS_SLTI  |
                     BIS_SLTIU |
                     BIS_XORI  |
                     BIS_ORI   |
                     BIS_ANDI  |
                     BIS_SLLI  |
                     BIS_SRLI  |
                     BIS_SRAI =>
                    reg_we <= '1';
                    
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
                    reg_we <= '1';
                    
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