vsim -t 10ps -voptargs="+acc" work.mikrainix_a16_tb(alu_tb)

add wave -divider "Clock & Control"
add wave -radix binary /mikrainix_a16_tb/clk
add wave -radix binary /mikrainix_a16_tb/rs

add wave -divider "ALU Inputs"
add wave -radix binary /mikrainix_a16_tb/alu_in.a
add wave -radix binary /mikrainix_a16_tb/alu_in.b
add wave /mikrainix_a16_tb/alu_in.bis

add wave -divider "ALU Outputs"
add wave -radix binary /mikrainix_a16_tb/alu_out.result
add wave -radix binary /mikrainix_a16_tb/alu_out.zero

configure wave -timelineunits ns

add list -notrigger /mikrainix_a16_tb/clk
add list /mikrainix_a16_tb/rs
add list -radix binary /mikrainix_a16_tb/alu_in.a
add list -radix binary /mikrainix_a16_tb/alu_in.b
add list /mikrainix_a16_tb/alu_in.bis
add list -radix binary /mikrainix_a16_tb/alu_out.result
add list /mikrainix_a16_tb/alu_out.zero

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