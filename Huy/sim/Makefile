# Variables
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
SIM_DIR = sim
OUTPUT = singlecycle
VCD_FILE = singlecycle_wave.vcd
TEXT_OUTPUT = tb_singlecycle.txt
RTL_DIR = ../rtl
DV_DIR = ../dv

# Source files
RTL_SOURCES =  $(RTL_DIR)/alu.sv \
	             $(RTL_DIR)/brc.sv \
               $(RTL_DIR)/comparator32b_signed.sv \
               $(RTL_DIR)/controlunit.sv \
               $(RTL_DIR)/datagen.sv \
               $(RTL_DIR)/fullAdder32b.sv \
               $(RTL_DIR)/immgen.sv \
               $(RTL_DIR)/instrmem.sv \
               $(RTL_DIR)/lsu.sv \
               $(RTL_DIR)/mux4to1.sv \
               $(RTL_DIR)/regfile.sv \
               $(RTL_DIR)/shift.sv \
               $(RTL_DIR)/singlecycle.sv \
               $(RTL_DIR)/data_mem.sv \
               $(RTL_DIR)/input_buffer.sv \
               $(RTL_DIR)/output_buffer.sv \
               $(RTL_DIR)/decoder_input_lsu.sv \
               $(RTL_DIR)/mux_output_lsu.sv \
               $(RTL_DIR)/reg_32bit.sv \

DV_SOURCES = $(DV_DIR)/tb_singlecycle.sv

# Default target
all: build run

# Build, run and create wave
all_wave: build run wave

# Build target
build: $(OUTPUT)

# Rule to compile the Verilog sources
$(OUTPUT): $(RTL_SOURCES) $(DV_SOURCES)
	$(IVERILOG) -o $@ $^ -s tb_singlecycle -g2012

# Run target - Xuất kết quả ra file alu_tb.txt
run: build
	$(VVP) $(OUTPUT) | tee $(TEXT_OUTPUT)

# Wave target
wave: 
	$(GTKWAVE) $(VCD_FILE)

# Clean up
clean:
	rm -f $(OUTPUT) $(VCD_FILE) $(TEXT_OUTPUT)

# Help
help:
	@echo " make build      : build the design"
	@echo " make run        : run simulation and save output to .txt"
	@echo " make wave       : open waveform"
	@echo " make all        : build and run simulation"
	@echo " make all_wave   : build, run simulation and open waveform"
	@echo " make clean      : remove simulation files"
