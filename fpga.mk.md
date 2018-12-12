# `fpga.mk` - build system for FPGA projects

Targets:

- `make flash V=...` - upload your project to the board
   - `make blif V=...` - synthesize (create a `.blif`)
   - `make bin V=...` - place and route (create a `.bin`)
- `make run V=...` - run in Icarus Verilog
- `make sim V=...` - run and open `.vcd` file in GTKWave
- `make test` - run all `*_tb.v` files

Variables:

- `V=source.v` - use `source.v` as main file
- `BOARD=board`, - select board to build for (supported: `icestick`, `bx`)
- `TOP=topmod` - use `topmod` as top-level module for synthesis
- `VERBOSE=1` - don't suppress output
- `USE_SUDO=1` - use `sudo` when uploading the project
