PROJ = pwm8b

PACKAGE = sg48
DEVICE = up5k
SERIES = synth_ice40
FREQ = 20
SEED = 10
PROGRAMMER = iceprog

# ----------------------------------------------------------------------------------

PIN_DEF = ./icebreaker.pcf
SRC_DIR = ./src
BUILD_DIR = ./build
TOOLCHAIN_PATH = /opt/fpga

FORMAT = "verilog-format"

# ----------------------------------------------------------------------------------

SRC_FILE := $(shell echo $(SRC_DIR)/top.v)
TB_FILE :=  $(shell echo $(SRC_DIR)/*_tb.v)

#Automatically search for files, allows you not to write "Include". Disconnected due to incompatibility with linter
#SRC_FILE := $(shell echo $(SRC_DIR)/* | sed 's@[^ ]*_tb.v@@g')
#TB_FILE :=  $(shell echo $(SRC_DIR)/* | sed 's@[^ ]*/top.v@@g')

#Creates a temporary PATH.
TOOLCHAIN_PATH := $(shell echo $$(readlink -f $(TOOLCHAIN_PATH)))
PATH := $(shell echo $(TOOLCHAIN_PATH)/*/bin | sed 's/ /:/g'):$(PATH)

all: $(BUILD_DIR) $(BUILD_DIR)/$(PROJ).bin
# rules for building the blif file
$(BUILD_DIR)/%.json: $(SRC_FILE)
	yosys -q -l $(BUILD_DIR)/build.log -p '$(SERIES) -top top -json $(BUILD_DIR)/$(PROJ).json; show -format dot -prefix $(BUILD_DIR)/$(PROJ)' $(SRC_FILE)
# asc
$(BUILD_DIR)/%.asc: $(BUILD_DIR)/%.json $(PIN_DEF)
	nextpnr-ice40 -q -l $(BUILD_DIR)/nextpnr.log --seed $(SEED) --freq $(FREQ) --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $<
# bin, for programming
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.asc
	icepack $< $@
# timing
$(BUILD_DIR)/%.rpt: $(BUILD_DIR)/%.asc
	icetime -d $(DEVICE) -mtr $@ $<

sim: $(BUILD_DIR)/%.vcd
$(BUILD_DIR)/%.vcd: $(BUILD_DIR)/$(PROJ).out
	vvp -M $(TOOLCHAIN_PATH)/toolchain-iverilog/lib/ivl -v $<
	mv ./*.vcd $(BUILD_DIR)
$(BUILD_DIR)/%.out: $(TB_FILE)
	iverilog -B $(TOOLCHAIN_PATH)/toolchain-iverilog/lib/ivl  -o $(BUILD_DIR)/$(PROJ).out $(TB_FILE)

flash: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) $<

prog: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) -S $<

clean:
	rm -f $(BUILD_DIR)/*

formatter:
	if [ $(FORMAT) == "istyle" ]; then istyle  -t4 -b -o --pad=block $(SRC_DIR)/*.v; fi
	if [ $(FORMAT) == "verilog-format" ]; then find ./src/*.v | xargs -t -L1 java -jar ${TOOLCHAIN_PATH}/verilog-format/bin/verilog-format.jar -s .verilog-format -f ; fi
	
toolchain:
	chmod +x ./toolchain/*.sh
	sudo ./toolchain/install.sh $(TOOLCHAIN_PATH)
	if [ -d ".vscode" ]; then sed -i 's@\(\"verilog.linting.path\":\)[^,]*@\1 "${TOOLCHAIN_PATH}/toolchain-iverilog/bin/"@' .vscode/settings.json; fi
	if [ -d ".vscode" ]; then sed -i 's@\(\"verilog.linting.iverilog.arguments\":\)[^,]*@\1 "-B ${TOOLCHAIN_PATH}/toolchain-iverilog/lib/ivl"@' .vscode/settings.json; fi

#secondary needed or make will remove useful intermediate files
.SECONDARY:
.PHONY: all sim flash prog clean formatter toolchain

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites
