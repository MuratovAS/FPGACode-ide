PROJ = pwm8b
PIN_DEF = ./icebreaker.pcf

PACKAGE = sg48
DEVICE = up5k
SERIES = synth_ice40
FREQ = 20
SEED = 10
PROGRAMMER = iceprog

BUILD_DIR = ./build
SRC_DIR = ./src
TB_DIR = ./tb
TOP_FILE = ./top.v

SRC_FILE := $(shell echo src/* | sed 's@[^ ]*_tb.v@@g')
SRC_FILE := $(shell echo src/* | sed 's@[^ ]*_tb.v@@g')
TB_FILE :=  $(shell echo src/* | sed 's@[^ ]*/top.v@@g')

all: $(BUILD_DIR) $(BUILD_DIR)/$(PROJ).bin

(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

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
	vvp -M /opt/toolchain-iverilog/lib/ivl -v $<
	mv ./*.vcd $(BUILD_DIR)

$(BUILD_DIR)/%.out: $(TB_FILE)
	iverilog -B /opt/toolchain-iverilog/lib/ivl  -o $(BUILD_DIR)/$(PROJ).out $(TB_FILE)


flash: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) $<


prog: $(BUILD_DIR)/$(PROJ).bin
	$(PROGRAMMER) -S $<


clean:
	rm -f $(BUILD_DIR)/*
	rm -f *.orig src/*.orig tb/*.orig
formatter:
	istyle  -t4 -b -o --pad=block */*.v

#secondary needed or make will remove useful intermediate files
.SECONDARY:
.PHONY: all sim flash prog clean formatter

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites
