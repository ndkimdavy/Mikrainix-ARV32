library ieee;
use ieee.std_logic_1164.all;

library work;
use work.arv32_pkg.all;

-- RV32I Base Instruction Set - ALU Multiplexer
-- Routes operands to ALU based on instruction type
--
-- Routing logic
-- Upper Immediate : LUI (alu_in.a = imm)
-- Immediate ALU : ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI (alu_in.a = rs1, alu_in.b = imm)
-- Register ALU : ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND (alu_in.a = rs1, alu_in.b = rs2)
-- Non-ALU instructions : All others (alu_in.a = 0, alu_in.b = 0)

entity alu_mux is
    port(
        clk      : in std_logic;
        rs       : in std_logic;
        bis      : in bis_t;
        bank_out : in bank_output_t;
        imm      : in std_logic_vector(31 downto 0);
        alu_in   : out alu_input_t
    );
end entity alu_mux;

architecture rtl of alu_mux is
begin

    process(clk, rs)
    begin
        if rs = '1' then
            alu_in.a   <= (others => '0');
            alu_in.b   <= (others => '0');
            alu_in.bis <= BIS_UNKNOWN;
            
        elsif rising_edge(clk) then
            
            alu_in.bis <= bis;
            
            case bis is
                
                when BIS_LUI =>
                    alu_in.a <= imm;
                    alu_in.b <= (others => '0');
                    
                when BIS_AUIPC =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_JAL =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_JALR =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_BEQ  |
                     BIS_BNE  |
                     BIS_BLT  |
                     BIS_BGE  |
                     BIS_BLTU |
                     BIS_BGEU =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_LB  |
                     BIS_LH  |
                     BIS_LW  |
                     BIS_LBU |
                     BIS_LHU =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_SB |
                     BIS_SH |
                     BIS_SW =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_ADDI  |
                     BIS_SLTI  |
                     BIS_SLTIU |
                     BIS_XORI  |
                     BIS_ORI   |
                     BIS_ANDI  |
                     BIS_SLLI  |
                     BIS_SRLI  |
                     BIS_SRAI  =>
                    alu_in.a <= bank_out.data1;
                    alu_in.b <= imm;
                    
                when BIS_ADD  |
                     BIS_SUB  |
                     BIS_SLL  |
                     BIS_SLT  |
                     BIS_SLTU |
                     BIS_XOR  |
                     BIS_SRL  |
                     BIS_SRA  |
                     BIS_OR   |
                     BIS_AND  =>
                    alu_in.a <= bank_out.data1;
                    alu_in.b <= bank_out.data2;
                    
                when BIS_FENCE     |
                     BIS_FENCE_TSO |
                     BIS_PAUSE     =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when BIS_ECALL  |
                     BIS_EBREAK =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
                when others =>
                    alu_in.a <= (others => '0');
                    alu_in.b <= (others => '0');
                    
            end case;
        end if;
    end process;

end architecture rtl;