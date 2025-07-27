library ieee;
use ieee.std_logic_1164.all;

-- RISC-V RV32I Package for Mikrainix-ARV32
-- 5-Stage Pipeline Architecture

package arv32_pkg is

-- ============================================================================
-- MEMORY CONSTANTS
-- ============================================================================
-- CODE (16MB)
constant CODE_START : std_logic_vector(31 downto 0) := x"00000000";
constant CODE_END   : std_logic_vector(31 downto 0) := x"00FFFFFF";
-- DATA (16MB)
constant DATA_START : std_logic_vector(31 downto 0) := x"20000000";
constant DATA_END   : std_logic_vector(31 downto 0) := x"20FFFFFF";
-- IO (8 bytes)
constant IO_START   : std_logic_vector(31 downto 0) := x"40000000";
constant IO_END     : std_logic_vector(31 downto 0) := x"40000007";

-- ============================================================================
-- BASE INSTRUCTION SET (42)
-- ============================================================================
type bis_t is (
   -- Upper Immediate
   BIS_LUI, 
   BIS_AUIPC,
   -- Jump and Link
   BIS_JAL, 
   BIS_JALR,
   -- Branch
   BIS_BEQ, 
   BIS_BNE, 
   BIS_BLT, 
   BIS_BGE, 
   BIS_BLTU, 
   BIS_BGEU,
   -- Load
   BIS_LB, 
   BIS_LH, 
   BIS_LW, 
   BIS_LBU, 
   BIS_LHU,
   -- Store
   BIS_SB, 
   BIS_SH, 
   BIS_SW,
   -- Immediate ALU
   BIS_ADDI, 
   BIS_SLTI, 
   BIS_SLTIU, 
   BIS_XORI, 
   BIS_ORI, 
   BIS_ANDI, 
   BIS_SLLI, 
   BIS_SRLI, 
   BIS_SRAI,
   -- Register ALU
   BIS_ADD, 
   BIS_SUB, 
   BIS_SLL, 
   BIS_SLT, 
   BIS_SLTU, 
   BIS_XOR, 
   BIS_SRL, 
   BIS_SRA, 
   BIS_OR, 
   BIS_AND,
   -- Memory Ordering
   BIS_FENCE,
   BIS_FENCE_TSO,
   BIS_PAUSE,
   -- System
   BIS_ECALL, 
   BIS_EBREAK,
   -- Unknown
   BIS_UNKNOWN
);

-- ============================================================================
-- BASE TYPES
-- ============================================================================
-- Register bank
type xregs_t is array (0 to 31) of std_logic_vector(31 downto 0);

-- Pipeline stages (5 stages)
type pipeline_stage_t is (IF_STAGE, ID_STAGE, EX_STAGE, MEM_STAGE, WB_STAGE);

-- ============================================================================
-- ALU TYPES
-- ============================================================================
-- ALU input
type alu_input_t is record
    a      : std_logic_vector(31 downto 0);
    b      : std_logic_vector(31 downto 0);
    bis    : bis_t;
end record alu_input_t;

-- ALU output
type alu_output_t is record
    result : std_logic_vector(31 downto 0);
    zero   : std_logic;
end record alu_output_t;

-- ============================================================================
-- I/O TYPES
-- ============================================================================
type io_t is record
    gpio : std_logic_vector(31 downto 0);
    uart : std_logic_vector(31 downto 0);
end record io_t;

-- ============================================================================
-- FUNCTIONS
-- ============================================================================
-- RV32I Base Instruction Set decoder
function get_rv32i_bis(instr : std_logic_vector(31 downto 0)) return bis_t;

-- ============================================================================
-- COMPONENTS 
-- ============================================================================
-- (TODO)

end package arv32_pkg;