################################################################################
# Emerging technologies, Systems & Security
#
#   date: Nov 26 2024
#   author: VlJo
################################################################################
# Project to test
#
# launch with: source /home/jvliegen/Desktop/temp/ch1/scripts/tcl/vivado_proj.tcl
################################################################################

set pname "Slower_clock"
  set path D:/School/MA/HWSW/VHDL/Oef_2
  set srcpath D:/School/MA/HWSW/Source_code/HWSW/Oef_2_chip_enable

set part "xc7vx485tffg1761-2"
set board "xilinx.com:vc707:part0:1.4"

# delete older versions
cd $path
exec rm -Rf $pname

# create project
create_project $pname $path/$pname -part $part
set_property board_part $board [current_project]
set_property target_language VHDL [current_project]

# suppress messages that say "don't do inidividual add_files/import_files
set_msg_config -suppress -id {Vivado 12-3645} 

# suppress messages like: WARNING: [Vivado 12-3523] Attempt to change 'Component_Name' from 'icap_buffer' to 'icap_buffer' is not allowed and is ignored.
set_msg_config -suppress -id {Vivado 12-3523} 



# TOP LEVEL COMPONENTS
################################################################################
add_files -norecurse $srcpath/hdl/PKG_hwswcd.vhd

add_files -norecurse $srcpath/hdl/alu.vhd
add_files -norecurse $srcpath/hdl/control.vhd
add_files -norecurse $srcpath/hdl/immediate_gen.vhd
add_files -norecurse $srcpath/hdl/reg_file.vhd
add_files -norecurse $srcpath/hdl/riscv.vhd
add_files -norecurse $srcpath/hdl/riscv_microcontroller.vhd

# TESTBENCHES
################################################################################
add_files -fileset sim_1 -norecurse $srcpath/hdl/tb/dmem_model.vhd
add_files -fileset sim_1 -norecurse $srcpath/hdl/tb/imem_model.vhd
add_files -fileset sim_1 -norecurse $srcpath/hdl/tb/basicIO_model.vhd
add_files -fileset sim_1 -norecurse $srcpath/hdl/tb/riscv_microcontroller_tb.vhd

