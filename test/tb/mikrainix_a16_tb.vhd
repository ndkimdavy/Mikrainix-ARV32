library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.arv32_pkg.all;

entity mikrainix_a16_tb is
end entity mikrainix_a16_tb;

architecture decoder_tb of mikrainix_a16_tb is

    signal clk    : std_logic := '0';
    signal rs     : std_logic := '0';
    signal instr  : std_logic_vector(31 downto 0);
    signal bis    : bis_t;
    signal rd     : std_logic_vector(4 downto 0);
    signal rs1    : std_logic_vector(4 downto 0);
    signal rs2    : std_logic_vector(4 downto 0);
    signal imm    : std_logic_vector(31 downto 0);
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;

begin

    uut : entity work.decoder
        port map (
            clk    => clk,
            rs     => rs,
            instr  => instr,
            bis    => bis,
            rd     => rd,
            rs1    => rs1,
            rs2    => rs2,
            imm    => imm,
            opcode => opcode,
            funct3 => funct3,
            funct7 => funct7
        );

    clk <= not clk after CLK_PERIOD / 2;

    stimulus : process
    begin
        
        report "=== DECODER TESTBENCH START ===";
        
        rs <= '1';
        wait for CLK_PERIOD;
        rs <= '0';
        wait for CLK_PERIOD;
        
        report "Test 1: LUI x5, 0x12345";
        instr <= "00010010001101000101" & "00101" & "0110111";
        wait for CLK_PERIOD;
        assert bis = BIS_LUI report "LUI: Wrong BIS" severity error;
        assert rd = "00101" report "LUI: Wrong rd" severity error;
        assert imm = x"12345000" report "LUI: Wrong immediate" severity error;
        assert imm(11 downto 0) = (11 downto 0 => '0') report "LUI: Lower bits should be 0" severity error;
        
        report "Test 2: AUIPC x6, 0x1000";
        instr <= "00000001000000000000" & "00110" & "0010111";
        wait for CLK_PERIOD;
        assert bis = BIS_AUIPC report "AUIPC: Wrong BIS" severity error;
        assert rd = "00110" report "AUIPC: Wrong rd" severity error;
        assert imm = x"01000000" report "AUIPC: Wrong immediate" severity error;
        
        report "Test 3: JAL x1, 8";
        instr <= "0" & "0000000100" & "0" & "00000000" & "00001" & "1101111";
        wait for CLK_PERIOD;
        assert bis = BIS_JAL report "JAL: Wrong BIS" severity error;
        assert rd = "00001" report "JAL: Wrong rd" severity error;
        assert to_integer(signed(imm)) = 8 report "JAL: Wrong immediate, expected 8" severity error;
        assert imm(0) = '0' report "JAL: LSB must be 0" severity error;
        
        report "Test 4: JALR x2, x3, 100";
        instr <= "000001100100" & "00011" & "000" & "00010" & "1100111";
        wait for CLK_PERIOD;
        assert bis = BIS_JALR report "JALR: Wrong BIS" severity error;
        assert rd = "00010" report "JALR: Wrong rd" severity error;
        assert rs1 = "00011" report "JALR: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 100 report "JALR: Wrong immediate, expected 100" severity error;
        
        report "Test 5: BEQ x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "000" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BEQ report "BEQ: Wrong BIS" severity error;
        assert rs1 = "00001" report "BEQ: Wrong rs1" severity error;
        assert rs2 = "00010" report "BEQ: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BEQ: Wrong immediate, expected 8" severity error;
        assert imm(0) = '0' report "BEQ: LSB must be 0" severity error;
        
        report "Test 6: BNE x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "001" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BNE report "BNE: Wrong BIS" severity error;
        assert rs1 = "00001" report "BNE: Wrong rs1" severity error;
        assert rs2 = "00010" report "BNE: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BNE: Wrong immediate, expected 8" severity error;
        
        report "Test 7: BLT x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "100" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BLT report "BLT: Wrong BIS" severity error;
        assert rs1 = "00001" report "BLT: Wrong rs1" severity error;
        assert rs2 = "00010" report "BLT: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BLT: Wrong immediate, expected 8" severity error;
        
        report "Test 8: BGE x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "101" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BGE report "BGE: Wrong BIS" severity error;
        assert rs1 = "00001" report "BGE: Wrong rs1" severity error;
        assert rs2 = "00010" report "BGE: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BGE: Wrong immediate, expected 8" severity error;
        
        report "Test 9: BLTU x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "110" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BLTU report "BLTU: Wrong BIS" severity error;
        assert rs1 = "00001" report "BLTU: Wrong rs1" severity error;
        assert rs2 = "00010" report "BLTU: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BLTU: Wrong immediate, expected 8" severity error;
        
        report "Test 10: BGEU x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "111" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BGEU report "BGEU: Wrong BIS" severity error;
        assert rs1 = "00001" report "BGEU: Wrong rs1" severity error;
        assert rs2 = "00010" report "BGEU: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 8 report "BGEU: Wrong immediate, expected 8" severity error;
        
        report "Test 11: LB x1, 0(x2)";
        instr <= "000000000000" & "00010" & "000" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LB report "LB: Wrong BIS" severity error;
        assert rd = "00001" report "LB: Wrong rd" severity error;
        assert rs1 = "00010" report "LB: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 0 report "LB: Wrong immediate, expected 0" severity error;
        
        report "Test 12: LH x1, 2(x2)";
        instr <= "000000000010" & "00010" & "001" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LH report "LH: Wrong BIS" severity error;
        assert rd = "00001" report "LH: Wrong rd" severity error;
        assert rs1 = "00010" report "LH: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 2 report "LH: Wrong immediate, expected 2" severity error;
        
        report "Test 13: LW x1, 4(x2)";
        instr <= "000000000100" & "00010" & "010" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LW report "LW: Wrong BIS" severity error;
        assert rd = "00001" report "LW: Wrong rd" severity error;
        assert rs1 = "00010" report "LW: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 4 report "LW: Wrong immediate, expected 4" severity error;
        
        report "Test 14: LBU x1, 8(x2)";
        instr <= "000000001000" & "00010" & "100" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LBU report "LBU: Wrong BIS" severity error;
        assert rd = "00001" report "LBU: Wrong rd" severity error;
        assert rs1 = "00010" report "LBU: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 8 report "LBU: Wrong immediate, expected 8" severity error;
        
        report "Test 15: LHU x1, 10(x2)";
        instr <= "000000001010" & "00010" & "101" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LHU report "LHU: Wrong BIS" severity error;
        assert rd = "00001" report "LHU: Wrong rd" severity error;
        assert rs1 = "00010" report "LHU: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 10 report "LHU: Wrong immediate, expected 10" severity error;
        
        report "Test 16: SB x3, 0(x2)";
        instr <= "0000000" & "00011" & "00010" & "000" & "00000" & "0100011";
        wait for CLK_PERIOD;
        assert bis = BIS_SB report "SB: Wrong BIS" severity error;
        assert rs1 = "00010" report "SB: Wrong rs1" severity error;
        assert rs2 = "00011" report "SB: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 0 report "SB: Wrong immediate, expected 0" severity error;
        
        report "Test 17: SH x3, 2(x2)";
        instr <= "0000000" & "00011" & "00010" & "001" & "00010" & "0100011";
        wait for CLK_PERIOD;
        assert bis = BIS_SH report "SH: Wrong BIS" severity error;
        assert rs1 = "00010" report "SH: Wrong rs1" severity error;
        assert rs2 = "00011" report "SH: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 2 report "SH: Wrong immediate, expected 2" severity error;
        
        report "Test 18: SW x3, 4(x2)";
        instr <= "0000000" & "00011" & "00010" & "010" & "00100" & "0100011";
        wait for CLK_PERIOD;
        assert bis = BIS_SW report "SW: Wrong BIS" severity error;
        assert rs1 = "00010" report "SW: Wrong rs1" severity error;
        assert rs2 = "00011" report "SW: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 4 report "SW: Wrong immediate, expected 4" severity error;
        
        report "Test 19: ADDI x1, x2, 100";
        instr <= "000001100100" & "00010" & "000" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_ADDI report "ADDI: Wrong BIS" severity error;
        assert rd = "00001" report "ADDI: Wrong rd" severity error;
        assert rs1 = "00010" report "ADDI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 100 report "ADDI: Wrong immediate, expected 100" severity error;
        
        report "Test 20: SLTI x1, x2, 50";
        instr <= "000000110010" & "00010" & "010" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLTI report "SLTI: Wrong BIS" severity error;
        assert rd = "00001" report "SLTI: Wrong rd" severity error;
        assert rs1 = "00010" report "SLTI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 50 report "SLTI: Wrong immediate, expected 50" severity error;
        
        report "Test 21: SLTIU x1, x2, 50";
        instr <= "000000110010" & "00010" & "011" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLTIU report "SLTIU: Wrong BIS" severity error;
        assert rd = "00001" report "SLTIU: Wrong rd" severity error;
        assert rs1 = "00010" report "SLTIU: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 50 report "SLTIU: Wrong immediate, expected 50" severity error;
        
        report "Test 22: XORI x1, x2, 255";
        instr <= "000011111111" & "00010" & "100" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_XORI report "XORI: Wrong BIS" severity error;
        assert rd = "00001" report "XORI: Wrong rd" severity error;
        assert rs1 = "00010" report "XORI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 255 report "XORI: Wrong immediate, expected 255" severity error;
        
        report "Test 23: ORI x1, x2, 240";
        instr <= "000011110000" & "00010" & "110" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_ORI report "ORI: Wrong BIS" severity error;
        assert rd = "00001" report "ORI: Wrong rd" severity error;
        assert rs1 = "00010" report "ORI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 240 report "ORI: Wrong immediate, expected 240" severity error;
        
        report "Test 24: ANDI x1, x2, 15";
        instr <= "000000001111" & "00010" & "111" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_ANDI report "ANDI: Wrong BIS" severity error;
        assert rd = "00001" report "ANDI: Wrong rd" severity error;
        assert rs1 = "00010" report "ANDI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 15 report "ANDI: Wrong immediate, expected 15" severity error;
        
        report "Test 25: SLLI x1, x2, 4";
        instr <= "0000000" & "00100" & "00010" & "001" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLLI report "SLLI: Wrong BIS" severity error;
        assert rd = "00001" report "SLLI: Wrong rd" severity error;
        assert rs1 = "00010" report "SLLI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 4 report "SLLI: Wrong immediate, expected 4" severity error;
        
        report "Test 26: SRLI x1, x2, 2";
        instr <= "0000000" & "00010" & "00010" & "101" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SRLI report "SRLI: Wrong BIS" severity error;
        assert rd = "00001" report "SRLI: Wrong rd" severity error;
        assert rs1 = "00010" report "SRLI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 2 report "SRLI: Wrong immediate, expected 2" severity error;
        
        report "Test 27: SRAI x1, x2, 4";
        instr <= "0100000" & "00100" & "00010" & "101" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SRAI report "SRAI: Wrong BIS" severity error;
        assert rd = "00001" report "SRAI: Wrong rd" severity error;
        assert rs1 = "00010" report "SRAI: Wrong rs1" severity error;
        assert to_integer(signed(imm)) = 4 report "SRAI: Wrong immediate, expected 4" severity error;
        
        report "Test 28: ADD x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "000" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_ADD report "ADD: Wrong BIS" severity error;
        assert rd = "00001" report "ADD: Wrong rd" severity error;
        assert rs1 = "00010" report "ADD: Wrong rs1" severity error;
        assert rs2 = "00011" report "ADD: Wrong rs2" severity error;
        assert to_integer(signed(imm)) = 0 report "ADD: Should have no immediate" severity error;
        
        report "Test 29: SUB x1, x2, x3";
        instr <= "0100000" & "00011" & "00010" & "000" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SUB report "SUB: Wrong BIS" severity error;
        assert rd = "00001" report "SUB: Wrong rd" severity error;
        assert rs1 = "00010" report "SUB: Wrong rs1" severity error;
        assert rs2 = "00011" report "SUB: Wrong rs2" severity error;
        assert funct7 = "0100000" report "SUB: Wrong funct7" severity error;
        
        report "Test 30: SLL x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "001" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLL report "SLL: Wrong BIS" severity error;
        assert rd = "00001" report "SLL: Wrong rd" severity error;
        assert rs1 = "00010" report "SLL: Wrong rs1" severity error;
        assert rs2 = "00011" report "SLL: Wrong rs2" severity error;
        assert funct3 = "001" report "SLL: Wrong funct3" severity error;
        
        report "Test 31: SLT x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "010" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLT report "SLT: Wrong BIS" severity error;
        assert rd = "00001" report "SLT: Wrong rd" severity error;
        assert rs1 = "00010" report "SLT: Wrong rs1" severity error;
        assert rs2 = "00011" report "SLT: Wrong rs2" severity error;
        
        report "Test 32: SLTU x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "011" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLTU report "SLTU: Wrong BIS" severity error;
        assert rd = "00001" report "SLTU: Wrong rd" severity error;
        assert rs1 = "00010" report "SLTU: Wrong rs1" severity error;
        assert rs2 = "00011" report "SLTU: Wrong rs2" severity error;
        
        report "Test 33: XOR x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "100" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_XOR report "XOR: Wrong BIS" severity error;
        assert rd = "00001" report "XOR: Wrong rd" severity error;
        assert rs1 = "00010" report "XOR: Wrong rs1" severity error;
        assert rs2 = "00011" report "XOR: Wrong rs2" severity error;
        
        report "Test 34: SRL x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "101" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SRL report "SRL: Wrong BIS" severity error;
        assert rd = "00001" report "SRL: Wrong rd" severity error;
        assert rs1 = "00010" report "SRL: Wrong rs1" severity error;
        assert rs2 = "00011" report "SRL: Wrong rs2" severity error;
        
        report "Test 35: SRA x1, x2, x3";
        instr <= "0100000" & "00011" & "00010" & "101" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SRA report "SRA: Wrong BIS" severity error;
        assert rd = "00001" report "SRA: Wrong rd" severity error;
        assert rs1 = "00010" report "SRA: Wrong rs1" severity error;
        assert rs2 = "00011" report "SRA: Wrong rs2" severity error;
        
        report "Test 36: OR x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "110" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_OR report "OR: Wrong BIS" severity error;
        assert rd = "00001" report "OR: Wrong rd" severity error;
        assert rs1 = "00010" report "OR: Wrong rs1" severity error;
        assert rs2 = "00011" report "OR: Wrong rs2" severity error;
        
        report "Test 37: AND x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "111" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_AND report "AND: Wrong BIS" severity error;
        assert rd = "00001" report "AND: Wrong rd" severity error;
        assert rs1 = "00010" report "AND: Wrong rs1" severity error;
        assert rs2 = "00011" report "AND: Wrong rs2" severity error;
        
        report "Test 38: ECALL";
        instr <= "000000000000" & "00000" & "000" & "00000" & "1110011";
        wait for CLK_PERIOD;
        assert bis = BIS_ECALL report "ECALL: Wrong BIS" severity error;
        
        report "Test 39: EBREAK";
        instr <= "000000000001" & "00000" & "000" & "00000" & "1110011";
        wait for CLK_PERIOD;
        assert bis = BIS_EBREAK report "EBREAK: Wrong BIS" severity error;
        
        wait for CLK_PERIOD;
        
        report "=== DECODER TESTBENCH COMPLETE ===";
        report "All decoder tests passed successfully!";
        
        wait;
    end process;

end architecture decoder_tb;

architecture alu_tb of mikrainix_a16_tb is

    signal clk     : std_logic := '0';
    signal rs      : std_logic := '0';
    signal alu_in  : alu_input_t;
    signal alu_out : alu_output_t;
    
    constant CLK_PERIOD : time := 10 ns;

begin

    uut : entity work.alu
        port map (
            clk     => clk,
            rs      => rs,
            alu_in  => alu_in,
            alu_out => alu_out
        );

    clk <= not clk after CLK_PERIOD / 2;

    stimulus : process
    begin
        
        report "=== ALU TESTBENCH START ===";
        
        rs <= '1';
        wait for CLK_PERIOD;
        rs <= '0';
        wait for CLK_PERIOD;
        
        report "Test 1: LUI";
        alu_in.a <= x"12345000";
        alu_in.b <= (others => '0');
        alu_in.bis <= BIS_LUI;
        wait for CLK_PERIOD;
        assert alu_out.result = x"12345000" report "LUI failed" severity error;
        
        report "Test 2: ADDI";
        alu_in.a <= std_logic_vector(to_unsigned(7, 32));
        alu_in.b <= std_logic_vector(to_unsigned(3, 32));
        alu_in.bis <= BIS_ADDI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 10 report "ADDI failed" severity error;

        report "Test 3: SLTI";
        alu_in.a <= std_logic_vector(to_signed(5, 32));
        alu_in.b <= std_logic_vector(to_signed(10, 32));
        alu_in.bis <= BIS_SLTI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 1 report "SLTI failed" severity error;

        report "Test 4: SLTIU";
        alu_in.a <= std_logic_vector(to_unsigned(5, 32));
        alu_in.b <= std_logic_vector(to_unsigned(10, 32));
        alu_in.bis <= BIS_SLTIU;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 1 report "SLTIU failed" severity error;

        report "Test 5: XORI";
        alu_in.a <= x"000000AA";
        alu_in.b <= x"00000055";
        alu_in.bis <= BIS_XORI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 255 report "XORI failed" severity error;

        report "Test 6: ORI";
        alu_in.a <= x"000000F0";
        alu_in.b <= x"0000000F";
        alu_in.bis <= BIS_ORI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 255 report "ORI failed" severity error;

        report "Test 7: ANDI";
        alu_in.a <= x"000000FF";
        alu_in.b <= x"0000000F";
        alu_in.bis <= BIS_ANDI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 15 report "ANDI failed" severity error;

        report "Test 8: SLLI";
        alu_in.a <= std_logic_vector(to_unsigned(3, 32));
        alu_in.b <= std_logic_vector(to_unsigned(2, 32));
        alu_in.bis <= BIS_SLLI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 12 report "SLLI failed" severity error;

        report "Test 9: SRLI";
        alu_in.a <= std_logic_vector(to_unsigned(12, 32));
        alu_in.b <= std_logic_vector(to_unsigned(2, 32));
        alu_in.bis <= BIS_SRLI;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 3 report "SRLI failed" severity error;

        report "Test 10: SRAI";
        alu_in.a <= std_logic_vector(to_signed(-12, 32));
        alu_in.b <= std_logic_vector(to_unsigned(2, 32));
        alu_in.bis <= BIS_SRAI;
        wait for CLK_PERIOD;
        assert to_integer(signed(alu_out.result)) = -3 report "SRAI failed" severity error;

        report "Test 11: ADD";
        alu_in.a <= std_logic_vector(to_unsigned(5, 32));
        alu_in.b <= std_logic_vector(to_unsigned(3, 32));
        alu_in.bis <= BIS_ADD;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 8 report "ADD failed" severity error;

        report "Test 12: SUB";
        alu_in.a <= std_logic_vector(to_unsigned(10, 32));
        alu_in.b <= std_logic_vector(to_unsigned(4, 32));
        alu_in.bis <= BIS_SUB;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 6 report "SUB failed" severity error;
        
        report "Test 13: SLL";
        alu_in.a <= std_logic_vector(to_unsigned(1, 32));
        alu_in.b <= std_logic_vector(to_unsigned(4, 32));
        alu_in.bis <= BIS_SLL;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 16 report "SLL failed" severity error;
        
        report "Test 14: SLT";
        alu_in.a <= std_logic_vector(to_signed(-1, 32));
        alu_in.b <= std_logic_vector(to_signed(1, 32));
        alu_in.bis <= BIS_SLT;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 1 report "SLT failed" severity error;

        report "Test 15: SLTU";
        alu_in.a <= x"FFFFFFFF";
        alu_in.b <= std_logic_vector(to_unsigned(1, 32));
        alu_in.bis <= BIS_SLTU;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "SLTU failed" severity error;

        report "Test 16: XOR";
        alu_in.a <= x"0000AAAA";
        alu_in.b <= x"00005555";
        alu_in.bis <= BIS_XOR;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 65535 report "XOR failed" severity error;
        
        report "Test 17: SRL";
        alu_in.a <= std_logic_vector(to_unsigned(16, 32));
        alu_in.b <= std_logic_vector(to_unsigned(2, 32));
        alu_in.bis <= BIS_SRL;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 4 report "SRL failed" severity error;

        report "Test 18: SRA";
        alu_in.a <= std_logic_vector(to_signed(-8, 32));
        alu_in.b <= std_logic_vector(to_unsigned(1, 32));
        alu_in.bis <= BIS_SRA;
        wait for CLK_PERIOD;
        assert to_integer(signed(alu_out.result)) = -4 report "SRA failed" severity error;

        report "Test 19: OR";
        alu_in.a <= x"0000F0F0";
        alu_in.b <= x"00000F0F";
        alu_in.bis <= BIS_OR;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 65535 report "OR failed" severity error;

        report "Test 20: AND";
        alu_in.a <= x"0000FF00";
        alu_in.b <= x"000000FF";
        alu_in.bis <= BIS_AND;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "AND failed" severity error;

        report "Test 21: Zero flag test";
        alu_in.a <= std_logic_vector(to_unsigned(5, 32));
        alu_in.b <= std_logic_vector(to_unsigned(5, 32));
        alu_in.bis <= BIS_SUB;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "Zero result failed" severity error;
        assert alu_out.zero = '1' report "Zero flag not set" severity error;

        report "Test 22: Unsupported AUIPC";
        alu_in.a <= std_logic_vector(to_unsigned(1000, 32));
        alu_in.b <= std_logic_vector(to_unsigned(2000, 32));
        alu_in.bis <= BIS_AUIPC;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "AUIPC should return 0" severity error;

        report "Test 23: Unsupported BEQ";
        alu_in.a <= std_logic_vector(to_unsigned(5, 32));
        alu_in.b <= std_logic_vector(to_unsigned(5, 32));
        alu_in.bis <= BIS_BEQ;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "BEQ should return 0" severity error;

        report "Test 24: Unsupported LW";
        alu_in.a <= std_logic_vector(to_unsigned(1000, 32));
        alu_in.b <= std_logic_vector(to_unsigned(20, 32));
        alu_in.bis <= BIS_LW;
        wait for CLK_PERIOD;
        assert to_integer(unsigned(alu_out.result)) = 0 report "LW should return 0" severity error;

        wait for CLK_PERIOD;
        
        report "=== ALU TESTBENCH COMPLETE ===";
        report "All ALU tests passed successfully!";
        
        wait;
    end process;

end architecture alu_tb;