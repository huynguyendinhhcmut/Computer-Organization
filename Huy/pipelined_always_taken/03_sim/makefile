# Author: Hai Cao
# Copyright 2024

.PHONY: sim
sim:
	@xrun -access +rwc -f ./flist

.PHONY: wave
wave:
	@(simvision wave.shm &)


.PHONY: gui
gui:
	@xrun -gui -access +rwc -f ./flist -input restore.tcl


.PHONY: clean
clean:
	@echo "-> CLEAN"
	@rm -rf x* *.vcd *.shm *.log



.PHONY: create_filelist
create_filelist:
	@rm -f flist
	@echo "# =============== Included tesbench files ==============="
	@find ./../01_bench \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;
	@echo "# =============== Included source code files ==============="
	@find ./../00_src \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;

	@echo "-sv" >> flist
	@echo "-timescale 1ns/100ps" >> flist
	@echo "# TESTBENCH FILES" >> flist
	@find ./../01_bench \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) >> flist
	@echo "# SOURCE CODE FILES" >> flist
	@find ./../00_src \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \)  >> flist








