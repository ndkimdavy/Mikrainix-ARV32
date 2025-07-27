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
        
        report "Test 1: ADD x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "000" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_ADD report "ADD: Wrong BIS" severity error;
        assert rd = "00001" report "ADD: Wrong rd" severity error;
        assert rs1 = "00010" report "ADD: Wrong rs1" severity error;
        assert rs2 = "00011" report "ADD: Wrong rs2" severity error;
        assert opcode = "0110011" report "ADD: Wrong opcode" severity error;
        assert funct3 = "000" report "ADD: Wrong funct3" severity error;
        assert funct7 = "0000000" report "ADD: Wrong funct7" severity error;
        
        report "Test 2: ADDI x1, x2, 100";
        instr <= "000001100100" & "00010" & "000" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_ADDI report "ADDI: Wrong BIS" severity error;
        assert rd = "00001" report "ADDI: Wrong rd" severity error;
        assert rs1 = "00010" report "ADDI: Wrong rs1" severity error;
        assert imm(11 downto 0) = "000001100100" report "ADDI: Wrong immediate" severity error;
        assert imm(31 downto 12) = (31 downto 12 => '0') report "ADDI: Wrong sign extension" severity error;
        
        report "Test 3: LUI x5, 0x12345";
        instr <= "00010010001101000101" & "00101" & "0110111";
        wait for CLK_PERIOD;
        assert bis = BIS_LUI report "LUI: Wrong BIS" severity error;
        assert rd = "00101" report "LUI: Wrong rd" severity error;
        assert imm(31 downto 12) = "00010010001101000101" report "LUI: Wrong immediate upper" severity error;
        assert imm(11 downto 0) = (11 downto 0 => '0') report "LUI: Wrong immediate lower" severity error;
        
        report "Test 4: BEQ x1, x2, 8";
        instr <= "0" & "000000" & "00010" & "00001" & "000" & "0100" & "0" & "1100011";
        wait for CLK_PERIOD;
        assert bis = BIS_BEQ report "BEQ: Wrong BIS" severity error;
        assert rs1 = "00001" report "BEQ: Wrong rs1" severity error;
        assert rs2 = "00010" report "BEQ: Wrong rs2" severity error;
        
        report "Test 5: JAL x1, 100";
        instr <= "0" & "0001100100" & "0" & "00000000" & "00001" & "1101111";
        wait for CLK_PERIOD;
        assert bis = BIS_JAL report "JAL: Wrong BIS" severity error;
        assert rd = "00001" report "JAL: Wrong rd" severity error;
        
        report "Test 6: LW x1, 20(x2)";
        instr <= "000000010100" & "00010" & "010" & "00001" & "0000011";
        wait for CLK_PERIOD;
        assert bis = BIS_LW report "LW: Wrong BIS" severity error;
        assert rd = "00001" report "LW: Wrong rd" severity error;
        assert rs1 = "00010" report "LW: Wrong rs1" severity error;
        assert funct3 = "010" report "LW: Wrong funct3" severity error;
        assert imm(11 downto 0) = "000000010100" report "LW: Wrong immediate" severity error;
        
        report "Test 7: SW x3, 8(x2)";
        instr <= "0000000" & "00011" & "00010" & "010" & "01000" & "0100011";
        wait for CLK_PERIOD;
        assert bis = BIS_SW report "SW: Wrong BIS" severity error;
        assert rs1 = "00010" report "SW: Wrong rs1" severity error;
        assert rs2 = "00011" report "SW: Wrong rs2" severity error;
        assert funct3 = "010" report "SW: Wrong funct3" severity error;
        
        report "Test 8: SLL x1, x2, x3";
        instr <= "0000000" & "00011" & "00010" & "001" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SLL report "SLL: Wrong BIS" severity error;
        assert funct3 = "001" report "SLL: Wrong funct3" severity error;
        assert funct7 = "0000000" report "SLL: Wrong funct7" severity error;
        
        report "Test 9: SUB x1, x2, x3";
        instr <= "0100000" & "00011" & "00010" & "000" & "00001" & "0110011";
        wait for CLK_PERIOD;
        assert bis = BIS_SUB report "SUB: Wrong BIS" severity error;
        assert funct7 = "0100000" report "SUB: Wrong funct7" severity error;
        
        report "Test 10: SRAI x1, x2, 4";
        instr <= "0100000" & "00100" & "00010" & "101" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_SRAI report "SRAI: Wrong BIS" severity error;
        assert funct3 = "101" report "SRAI: Wrong funct3" severity error;
        assert funct7 = "0100000" report "SRAI: Wrong funct7" severity error;
        
        report "Test 11: ADDI x1, x2, -1";
        instr <= "111111111111" & "00010" & "000" & "00001" & "0010011";
        wait for CLK_PERIOD;
        assert bis = BIS_ADDI report "ADDI negative: Wrong BIS" severity error;
        assert imm = x"FFFFFFFF" report "ADDI: Wrong sign extension for -1" severity error;
        
        report "Test 12: ECALL";
        instr <= "000000000000" & "00000" & "000" & "00000" & "1110011";
        wait for CLK_PERIOD;
        assert bis = BIS_ECALL report "ECALL: Wrong BIS" severity error;
        
        report "Test 13: Unknown instruction";
        instr <= x"FFFFFFFF";
        wait for CLK_PERIOD;
        assert bis = BIS_UNKNOWN report "Unknown: Should return BIS_UNKNOWN" severity error;
        
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
        
        report "Test 1: LUI (load 0x12345000)";
        alu_in.a <= x"12345000";
        alu_in.b <= x"00000000";
        alu_in.bis <= BIS_LUI;
        wait for CLK_PERIOD;
        assert alu_out.result = x"12345000" report "LUI failed" severity error;
        
        report "Test 2: AUIPC (PC + immediate)";
        alu_in.a <= x"00001000";
        alu_in.b <= x"12345000";
        alu_in.bis <= BIS_AUIPC;
        wait for CLK_PERIOD;
        assert alu_out.result = x"12346000" report "AUIPC failed" severity error;
        
        report "Test 3: JAL (PC + offset)";
        alu_in.a <= x"00001000";
        alu_in.b <= x"00000064";
        alu_in.bis <= BIS_JAL;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00001064" report "JAL failed" severity error;
        
        report "Test 4: BEQ (5 == 5 = true)";
        alu_in.a <= x"00000005";
        alu_in.b <= x"00000005";
        alu_in.bis <= BIS_BEQ;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000001" report "BEQ equal failed" severity error;
        
        report "Test 5: BEQ (5 == 3 = false)";
        alu_in.a <= x"00000005";
        alu_in.b <= x"00000003";
        alu_in.bis <= BIS_BEQ;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "BEQ not equal failed" severity error;
        
        report "Test 6: BNE (5 != 3 = true)";
        alu_in.a <= x"00000005";
        alu_in.b <= x"00000003";
        alu_in.bis <= BIS_BNE;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000001" report "BNE not equal failed" severity error;
        
        report "Test 7: BLT (-1 < 1 = true)";
        alu_in.a <= x"FFFFFFFF";
        alu_in.b <= x"00000001";
        alu_in.bis <= BIS_BLT;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000001" report "BLT signed failed" severity error;
        
        report "Test 8: BLTU (0xFFFFFFFF > 1 = false)";
        alu_in.a <= x"FFFFFFFF";
        alu_in.b <= x"00000001";
        alu_in.bis <= BIS_BLTU;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "BLTU unsigned failed" severity error;
        
        report "Test 9: LW address calc (base + offset)";
        alu_in.a <= x"00001000";
        alu_in.b <= x"00000014";
        alu_in.bis <= BIS_LW;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00001014" report "LW address calc failed" severity error;
        
        report "Test 10: SW address calc (base + offset)";
        alu_in.a <= x"00002000";
        alu_in.b <= x"00000008";
        alu_in.bis <= BIS_SW;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00002008" report "SW address calc failed" severity error;
        
        report "Test 11: ADD (5 + 3 = 8)";
        alu_in.a <= x"00000005";
        alu_in.b <= x"00000003";
        alu_in.bis <= BIS_ADD;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000008" report "ADD failed" severity error;
        assert alu_out.zero = '0' report "ADD zero flag error" severity error;

        report "Test 12: SUB (10 - 4 = 6)";
        alu_in.a <= x"0000000A";
        alu_in.b <= x"00000004";
        alu_in.bis <= BIS_SUB;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000006" report "SUB failed" severity error;
        
        report "Test 13: Zero flag (5 - 5 = 0)";
        alu_in.a <= x"00000005";
        alu_in.b <= x"00000005";
        alu_in.bis <= BIS_SUB;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "SUB zero failed" severity error;
        assert alu_out.zero = '1' report "Zero flag not set" severity error;
        
        report "Test 14: AND (0xFF00 & 0x00FF = 0x0000)";
        alu_in.a <= x"0000FF00";
        alu_in.b <= x"000000FF";
        alu_in.bis <= BIS_AND;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "AND failed" severity error;
        assert alu_out.zero = '1' report "AND zero flag error" severity error;
        
        report "Test 15: OR (0xF0F0 | 0x0F0F = 0xFFFF)";
        alu_in.a <= x"0000F0F0";
        alu_in.b <= x"00000F0F";
        alu_in.bis <= BIS_OR;
        wait for CLK_PERIOD;
        assert alu_out.result = x"0000FFFF" report "OR failed" severity error;

        report "Test 16: XOR (0xAAAA ^ 0x5555 = 0xFFFF)";
        alu_in.a <= x"0000AAAA";
        alu_in.b <= x"00005555";
        alu_in.bis <= BIS_XOR;
        wait for CLK_PERIOD;
        assert alu_out.result = x"0000FFFF" report "XOR failed" severity error;
        
        report "Test 17: SLL (1 << 4 = 16)";
        alu_in.a <= x"00000001";
        alu_in.b <= x"00000004";
        alu_in.bis <= BIS_SLL;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000010" report "SLL failed" severity error;
        
        report "Test 18: SRL (16 >> 2 = 4)";
        alu_in.a <= x"00000010";
        alu_in.b <= x"00000002";
        alu_in.bis <= BIS_SRL;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000004" report "SRL failed" severity error;

        report "Test 19: SRA (-8 >> 1 = -4)";
        alu_in.a <= x"FFFFFFF8";
        alu_in.b <= x"00000001";
        alu_in.bis <= BIS_SRA;
        wait for CLK_PERIOD;
        assert alu_out.result = x"FFFFFFFC" report "SRA failed" severity error;

        report "Test 20: SLT (-1 < 1 = true)";
        alu_in.a <= x"FFFFFFFF";
        alu_in.b <= x"00000001";
        alu_in.bis <= BIS_SLT;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000001" report "SLT signed failed" severity error;

        report "Test 21: SLTU (0xFFFFFFFF > 1 = false)";
        alu_in.a <= x"FFFFFFFF";
        alu_in.b <= x"00000001";
        alu_in.bis <= BIS_SLTU;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "SLTU unsigned failed" severity error;

        report "Test 22: ADDI (7 + 3 = 10)";
        alu_in.a <= x"00000007";
        alu_in.b <= x"00000003";
        alu_in.bis <= BIS_ADDI;
        wait for CLK_PERIOD;
        assert alu_out.result = x"0000000A" report "ADDI failed" severity error;

        report "Test 23: FENCE (should return 0)";
        alu_in.a <= x"12345678";
        alu_in.b <= x"87654321";
        alu_in.bis <= BIS_FENCE;
        wait for CLK_PERIOD;
        assert alu_out.result = x"00000000" report "FENCE failed" severity error;

        wait for CLK_PERIOD;
        
        report "=== ALU TESTBENCH COMPLETE ===";
        report "All ALU tests passed successfully!";
        
        wait;
    end process;

end architecture alu_tb;