#!/bin/bash

iverilog -o alu.vvp ../../../Verilog_Basis_Files/lab5-alu/alu_test.v alu.v
vvp alu.vvp
