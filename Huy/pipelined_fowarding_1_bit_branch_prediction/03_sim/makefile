
.PHONY: sim
sim:
	@xrun -access +rwc -f ./flist.f

.PHONY: wave
wave:
	@(simvision wave.shm &)


.PHONY: gui
gui:
	@xrun -gui -access +rwc -f ./flist.f -input restore.tcl


.PHONY: clean
clean:
	@echo "-> CLEAN"
	@rm -rf x* *.vcd *.shm *.log



.PHONY: create_filelist
create_filelist:
	@rm -f flist.f
	@echo "# =============== Included tesbench files ==============="
	@find ./../01_bench \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;
	@echo "# =============== Included source code files ==============="
	@find ./../00_src \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;

	@echo "-sv" >> flist.f
	@echo "-timescale 1ns/100ps" >> flist.f
	@echo "" >> flist.f
	@echo "# SOURCE CODE FILES" >> flist.f
	@find ./../00_src \( -name "*.svh" -o -name "*.vh" -o -name "*.v" -o -name "*.sv" \) \
	 | awk -F'/' '{print NF, $$0}' \
	 | sort -k1,1nr \
	 | cut -d' ' -f2- >> flist.f

	@echo "" >> flist.f
	@echo "# TESTBENCH FILES" >> flist.f
	@find ./../01_bench \( -name "*.svh" -o -name "*.vh" -o -name "*.v" -o -name "*.sv" \) \
	 | awk -F'/' '{print NF, $$0}' \
	 | sort -k1,1nr \
	 | cut -d' ' -f2- >> flist.f
