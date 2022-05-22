set MGC_DESIGN_NAME "ota"
set MGC_PORT_LIST {ip in phi1 phi1_b phi2 phi2_b op on i_bias cm}

# flatten design and make ports

load "${MGC_DESIGN_NAME}.mag"
box 0 0 0 0
select

flatten "${MGC_DESIGN_NAME}_flat"

load "${MGC_DESIGN_NAME}_flat"
box 0 0 0 0
select

foreach port $MGC_PORT_LIST {
    findlabel $port
    port make
}

# special handling of power ports
findlabel VDD
port make 
port use power
port class inout
findlabel VSS
port make
port use ground
port class inout

save "${MGC_DESIGN_NAME}_flat.mag"

# lvs extraction
extract all
ext2spice lvs
ext2spice -o "../../netlist/${MGC_DESIGN_NAME}/${MGC_DESIGN_NAME}_layout_lvs.spice"

# pex extraction
ext2spice cthresh 0
ext2spice -o "../../netlist/${MGC_DESIGN_NAME}/${MGC_DESIGN_NAME}_layout_pex.spice"

# output gds and lef
# gds write "${MGC_DESIGN_NAME}.gds"
# lef write "${MGC_DESIGN_NAME}.lef"

# unset variables
unset MGC_DESIGN_NAME
unset MGC_PORT_LIST

quit
