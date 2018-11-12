
IVERILOG ?= iverilog
GTKWAVE ?= gtkwave

MAKEDEPS := ../lib/make-deps

.PRECIOUS: %.out %.vcd %.d

%.d: %.v $(MAKEDEPS)
	$(MAKEDEPS) $(@:.d=.blif) $< > $@
	$(MAKEDEPS) $(@:.d=.out) $< >> $@

%.vcd: %.out
	./$<

%.out: %.v %.d
	$(IVERILOG) $< -o $@

.PHONY: sim
sim: $(V:.v=.vcd)
	$(GTKWAVE) $<

.PHONY: run
run: $(V:.v=.out)
	./$<

.PHONY: clean
clean:
	rm -f *.bin *.blif *.asc *.out *.d *.vcd

include $(wildcard *.d)
