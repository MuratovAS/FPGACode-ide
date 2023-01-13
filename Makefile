PROJ = pwm8b

PACKAGE = sg48
DEVICE = up5k
SERIES = synth_ice40
ROUTE_ARG = -dsp
FREQ = 20
SEED = 10
PROGRAMMER = iceprog

# ----------------------------------------------------------------------------------

FPGA_SRC = ./src
PIN_DEF = ./icebreaker.pcf
TOP_FILE = $(shell echo $(FPGA_SRC)/top.v)
TB_FILE :=  $(shell echo $(FPGA_SRC)/*_tb.v)

# ----------------------------------------------------------------------------------

FORMAT = "verilog-format"
TOOLCHAIN_PATH = /opt/fpga
BUILD_DIR = build
#Creates a temporary PATH.
TOOLCHAIN_PATH := $(shell echo $$(readlink -f $(TOOLCHAIN_PATH)))
PATH := $(shell echo $(TOOLCHAIN_PATH)/*/bin | sed 's/ /:/g'):$(PATH)


all: synthesis

synthesis: $(BUILD_DIR) $(BUILD_DIR)/$(PROJ).bin
# rules for building the blif file
$(BUILD_DIR)/%.json: $(TOP_FILE) $(FPGA_SRC)/*.v
	yosys -q -l $(BUILD_DIR)/build.log -p '$(SERIES) $(ROUTE_ARG) -top top -json $@; show -format dot -prefix $(BUILD_DIR)/$(PROJ)' $< 
# asc
$(BUILD_DIR)/%.asc: $(BUILD_DIR)/%.json $(PIN_DEF)
	nextpnr-ice40 -l $(BUILD_DIR)/nextpnr.log --seed $(SEED) --freq $(FREQ) --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $<
# bin, for programming
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.asc
	icepack $< $@
# timing
$(BUILD_DIR)/%.rpt: $(BUILD_DIR)/%.asc
	icetime -d $(DEVICE) -mtr $@ $<

sim: $(BUILD_DIR) $(BUILD_DIR)/%.vcd
$(BUILD_DIR)/%.vcd: $(BUILD_DIR)/$(PROJ).out
	vvp -v -M $(TOOLCHAIN_PATH)/toolchain-iverilog/lib/ivl $<
	mv ./*.vcd $(BUILD_DIR)

$(BUILD_DIR)/%.out: $(TB_FILE)
	iverilog -o $@ -B $(TOOLCHAIN_PATH)/toolchain-iverilog/lib/ivl $(TOOLCHAIN_PATH)/toolchain-yosys/share/yosys/ice40/cells_sim.v $(TB_FILE)

# Flash memory firmware
flash: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) $<

# Flash in SRAM
prog: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) -S $<

clean:
	rm -f $(BUILD_DIR)/*

formatter:
	if [ $(FORMAT) == "istyle" ]; then istyle  -t4 -b -o --pad=block $(SRC_DIR)/*.v; fi
	if [ $(FORMAT) == "verilog-format" ]; then find ./src/*.v | xargs -t -L1 java -jar ${TOOLCHAIN_PATH}/verilog-format/bin/verilog-format.jar -s .verilog-format -f ; fi
	
toolchain:
	chmod +x ./toolchain/*.sh
	sudo rm -rf $(TOOLCHAIN_PATH)
	sudo ./toolchain/install.sh $(TOOLCHAIN_PATH)
	if [ -d ".vscode" ]; then sed -i 's@\(\"verilog.linting.path\":\)[^,]*@\1 "${TOOLCHAIN_PATH}/toolchain-iverilog/bin/"@' .vscode/settings.json; fi
	if [ -d ".vscode" ]; then sed -i 's@\(\"verilog.linting.iverilog.arguments\":\)[^,]*@\1 "-B ${TOOLCHAIN_PATH}/toolchain-iverilog/lib/ivl"@' .vscode/settings.json; fi

#secondary needed or make will remove useful intermediate files
.SECONDARY:
.PHONY: all synthesis sim flash prog clean formatter toolchain

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites
