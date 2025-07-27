library ieee;
use ieee.std_logic_1164.all;

-- ============================================================================
-- PACKAGE BODY
-- ============================================================================
package body arv32_pkg is

-- RV32I Base Instruction Set
function get_rv32i_bis(instr : std_logic_vector(31 downto 0)) return bis_t is
    variable opcode_var : std_logic_vector(6 downto 0);
    variable funct3_var : std_logic_vector(2 downto 0);
    variable funct7_var : std_logic_vector(6 downto 0);
begin
    opcode_var := instr(6 downto 0);
    funct3_var := instr(14 downto 12);
    funct7_var := instr(31 downto 25);
    
    if opcode_var = "0110111" then return BIS_LUI; end if;
    if opcode_var = "0010111" then return BIS_AUIPC; end if;
    if opcode_var = "1101111" then return BIS_JAL; end if;
    if opcode_var = "1100111" then return BIS_JALR; end if;
    
    if opcode_var = "1100011" then
        if funct3_var = "000" then return BIS_BEQ; end if;
        if funct3_var = "001" then return BIS_BNE; end if;
        if funct3_var = "100" then return BIS_BLT; end if;
        if funct3_var = "101" then return BIS_BGE; end if;
        if funct3_var = "110" then return BIS_BLTU; end if;
        if funct3_var = "111" then return BIS_BGEU; end if;
    end if;
    
    if opcode_var = "0000011" then
        if funct3_var = "000" then return BIS_LB; end if;
        if funct3_var = "001" then return BIS_LH; end if;
        if funct3_var = "010" then return BIS_LW; end if;
        if funct3_var = "100" then return BIS_LBU; end if;
        if funct3_var = "101" then return BIS_LHU; end if;
    end if;
    
    if opcode_var = "0100011" then
        if funct3_var = "000" then return BIS_SB; end if;
        if funct3_var = "001" then return BIS_SH; end if;
        if funct3_var = "010" then return BIS_SW; end if;
    end if;
    
    if opcode_var = "0010011" then
        if funct3_var = "000" then return BIS_ADDI; end if;
        if funct3_var = "010" then return BIS_SLTI; end if;
        if funct3_var = "011" then return BIS_SLTIU; end if;
        if funct3_var = "100" then return BIS_XORI; end if;
        if funct3_var = "110" then return BIS_ORI; end if;
        if funct3_var = "111" then return BIS_ANDI; end if;
        if funct3_var = "001" then return BIS_SLLI; end if;
        if funct3_var = "101" and funct7_var = "0000000" then return BIS_SRLI; end if;
        if funct3_var = "101" and funct7_var = "0100000" then return BIS_SRAI; end if;
    end if;
    
    if opcode_var = "0110011" then
        if funct3_var = "000" and funct7_var = "0000000" then return BIS_ADD; end if;
        if funct3_var = "000" and funct7_var = "0100000" then return BIS_SUB; end if;
        if funct3_var = "001" and funct7_var = "0000000" then return BIS_SLL; end if;
        if funct3_var = "010" and funct7_var = "0000000" then return BIS_SLT; end if;
        if funct3_var = "011" and funct7_var = "0000000" then return BIS_SLTU; end if;
        if funct3_var = "100" and funct7_var = "0000000" then return BIS_XOR; end if;
        if funct3_var = "101" and funct7_var = "0000000" then return BIS_SRL; end if;
        if funct3_var = "101" and funct7_var = "0100000" then return BIS_SRA; end if;
        if funct3_var = "110" and funct7_var = "0000000" then return BIS_OR; end if;
        if funct3_var = "111" and funct7_var = "0000000" then return BIS_AND; end if;
    end if;
    
    if opcode_var = "0001111" then return BIS_FENCE; end if;
    
    if opcode_var = "1110011" then
        if instr(31 downto 20) = "000000000000" then return BIS_ECALL; end if;
        if instr(31 downto 20) = "000000000001" then return BIS_EBREAK; end if;
    end if;
    
    return BIS_UNKNOWN;
end function get_rv32i_bis;

end package body arv32_pkg;