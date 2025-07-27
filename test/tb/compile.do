transcript on

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

vcom -93 -work work {../mikrainix_arv32/src/arv32_pkg.vhd}
vcom -93 -work work {../mikrainix_arv32/src/arv32_pkg_body.vhd}
vcom -93 -work work {../mikrainix_arv32/src/bank_reg.vhd}
vcom -93 -work work {../mikrainix_arv32/src/alu.vhd}
vcom -93 -work work {../mikrainix_arv32/src/decoder.vhd}

vcom -93 -work work {../test/tb/mikrainix_a16_tb.vhd}

quit