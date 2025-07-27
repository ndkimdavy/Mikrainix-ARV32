vsim -t 10ps -voptargs="+acc" work.mikrainix_a16_tb(decoder_tb)

add wave -divider "Clock & Control"
add wave -radix binary /mikrainix_a16_tb/clk
add wave -radix binary /mikrainix_a16_tb/rs

add wave -divider "Instruction Input"
add wave -radix binary /mikrainix_a16_tb/instr
add wave -radix binary /mikrainix_a16_tb/opcode
add wave -radix binary /mikrainix_a16_tb/funct3
add wave -radix binary /mikrainix_a16_tb/funct7

add wave -divider "Decoded Outputs"
add wave /mikrainix_a16_tb/bis
add wave -radix unsigned /mikrainix_a16_tb/rd
add wave -radix unsigned /mikrainix_a16_tb/rs1
add wave -radix unsigned /mikrainix_a16_tb/rs2
add wave -radix binary /mikrainix_a16_tb/imm

configure wave -timelineunits ns

add list -notrigger /mikrainix_a16_tb/clk
add list /mikrainix_a16_tb/rs
add list -radix binary /mikrainix_a16_tb/instr
add list /mikrainix_a16_tb/bis
add list -radix unsigned /mikrainix_a16_tb/rd
add list -radix unsigned /mikrainix_a16_tb/rs1
add list -radix unsigned /mikrainix_a16_tb/rs2
add list -radix binary /mikrainix_a16_tb/imm

noview structure
noview signals
noview objects
noview processes 
noview library
view wave
view list

wave zoom range 0ns 500ns
wave zoom full

run 500ns