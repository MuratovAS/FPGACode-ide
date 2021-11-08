sudo apt install python3
sudo apt install python3-pip
sudo pip3 install -U apio
apio install -a
apio drivers --ftdi-enable
apio upload


micro -plugin install yosyslint

xdot

yosys
nextpnr-ice40
iverilog
icestorm


echo $(SRC) | sed 's@./[^ ]*_tb.v@@g' | sed 's| |\n|g' > $(BUILD_DIR)/build_file.txt
echo $(SRC) | sed 's@./[^ ]*top.v@@g' | sed 's| |\n|g' > $(BUILD_DIR)/sim_file.txt