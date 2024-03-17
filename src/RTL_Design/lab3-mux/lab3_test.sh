#!/bin/bash

iverilog -o mux.vvp ../../../Verilog_Basis_Files/lab3-mux/multiplexor_test.v multiplexor.v
vvp mux.vvp
