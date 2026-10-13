transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/University/Year\ 2/ECE241/fake_fpga/LABS/LAB3/Part4 {C:/University/Year 2/ECE241/fake_fpga/LABS/LAB3/Part4/part4.v}

