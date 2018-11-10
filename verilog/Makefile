
IVERILOG := iverilog
GTKWAVE := gtkwave

.PRECIOUS: %.out

.PHONY: run-%
run-%: %.out
	./$<

.PHONY: sim-%
sim-%: %.vcd
	$(GTKWAVE) $<

%.vcd: %.out
	./$<

%.out: %.v
	$(IVERILOG) $< -o $@
