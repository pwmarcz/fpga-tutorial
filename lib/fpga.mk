
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

.PHONY: run-%
run-%: %.out
	./$<

.PHONY: sim-%
sim-%: %.vcd
	$(GTKWAVE) $<

.PHONY: clean
clean:
	rm -f *.bin *.blif *.asc *.out *.d

include $(wildcard *.d)
