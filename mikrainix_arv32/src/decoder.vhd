library ieee;
use ieee.std_logic_1164.all;

library work;
use work.arv32_pkg.all;

-- RV32I Base Instruction Set - Decoder
-- Extracts fields and reconstructs immediates with sign extension
--
-- Outputs:
-- bis : Instruction type
-- rd, rs1, rs2 : Register addresses (5 bits)
-- imm : Reconstructed immediate (32 bits with sign extension)
-- opcode : Operation code (7 bits)
-- funct3, funct7 : Function fields
--
-- Immediate field reconstruction:
-- R-type : no immediate | imm = 0
-- I-type : sign-extend (imm[31:12] = instr[31]) | imm[11:0] = instr[31:20]
-- I-type shifts : no sign extension | imm[31:5] = 0 | imm[4:0] = instr[24:20] (shamt only)
-- S-type : sign-extend (imm[31:12] = instr[31]) | imm[11:5] = instr[31:25], imm[4:0] = instr[11:7]
-- B-type : sign-extend (imm[31:13] = instr[31]) | bits reorganized, imm[0] = 0
-- U-type : no sign extension | imm[31:12] = instr[31:12], imm[11:0] = 0
-- J-type : sign-extend (imm[31:21] = instr[31]) | bits reorganized, imm[0] = 0

entity decoder is
    port(
        clk    : in std_logic;
        rs     : in std_logic;
        instr  : in std_logic_vector(31 downto 0);
        bis    : out bis_t;
        rd     : out std_logic_vector(4 downto 0);
        rs1    : out std_logic_vector(4 downto 0);
        rs2    : out std_logic_vector(4 downto 0);
        imm    : out std_logic_vector(31 downto 0);
        opcode : out std_logic_vector(6 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        funct7 : out std_logic_vector(6 downto 0)
    );
end entity decoder;

architecture rtl of decoder is
    signal bis_tmp : bis_t;
begin

    process(clk, rs)
        variable bis_var : bis_t;
    begin
        if rs = '1' then
            bis_tmp <= BIS_UNKNOWN;
            rd      <= (others => '0');
            rs1     <= (others => '0');
            rs2     <= (others => '0');
            imm     <= (others => '0');
            opcode  <= (others => '0');
            funct3  <= (others => '0');
            funct7  <= (others => '0');

        elsif rising_edge(clk) then
            bis_var := get_rv32i_bis(instr);
            bis_tmp <= bis_var;
            rd      <= instr(11 downto 7);
            rs1     <= instr(19 downto 15);
            rs2     <= instr(24 downto 20);
            opcode  <= instr(6 downto 0);
            funct3  <= instr(14 downto 12);
            funct7  <= instr(31 downto 25);
            
            case bis_var is
                
                when BIS_LUI   |
                     BIS_AUIPC =>
                    imm(31 downto 12) <= instr(31 downto 12);
                    imm(11 downto 0)  <= (others => '0');

                when BIS_JAL =>
                    imm(31 downto 21) <= (others => instr(31));
                    imm(20)           <= instr(31);
                    imm(19 downto 12) <= instr(19 downto 12);
                    imm(11)           <= instr(20);
                    imm(10 downto 1)  <= instr(30 downto 21);
                    imm(0)            <= '0';

                when BIS_JALR =>
                    imm(31 downto 12) <= (others => instr(31));
                    imm(11 downto 0)  <= instr(31 downto 20);

                when BIS_BEQ  |
                     BIS_BNE  |
                     BIS_BLT  |
                     BIS_BGE  |
                     BIS_BLTU |
                     BIS_BGEU =>
                    imm(31 downto 13) <= (others => instr(31));
                    imm(12)           <= instr(31);
                    imm(11)           <= instr(7);
                    imm(10 downto 5)  <= instr(30 downto 25);
                    imm(4 downto 1)   <= instr(11 downto 8);
                    imm(0)            <= '0';

                when BIS_LB  |
                     BIS_LH  |
                     BIS_LW  |
                     BIS_LBU |
                     BIS_LHU =>
                    imm(31 downto 12) <= (others => instr(31));
                    imm(11 downto 0)  <= instr(31 downto 20);
                
                when BIS_SB |
                     BIS_SH |
                     BIS_SW =>
                    imm(31 downto 12) <= (others => instr(31));
                    imm(11 downto 5)  <= instr(31 downto 25);
                    imm(4 downto 0)   <= instr(11 downto 7);

                when BIS_ADDI  |
                     BIS_SLTI  |
                     BIS_SLTIU |
                     BIS_XORI  |
                     BIS_ORI   |
                     BIS_ANDI  =>
                    imm(31 downto 12) <= (others => instr(31));
                    imm(11 downto 0)  <= instr(31 downto 20);

                when BIS_SLLI |
                     BIS_SRLI |
                     BIS_SRAI =>
                    imm(31 downto 5) <= (others => '0');  
                    imm(4 downto 0)  <= instr(24 downto 20); 

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
                    imm <= (others => '0');
                
                when BIS_FENCE     |
                     BIS_FENCE_TSO |
                     BIS_PAUSE     =>
                    imm <= (others => '0');
                
                when BIS_ECALL  |
                     BIS_EBREAK =>
                    imm <= (others => '0');
                
                when BIS_UNKNOWN =>
                    imm <= (others => '0');
                
            end case;
        end if;
    end process;

    bis <= bis_tmp;

end architecture rtl;