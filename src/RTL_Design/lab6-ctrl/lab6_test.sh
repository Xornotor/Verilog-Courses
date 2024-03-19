#!/bin/bash

iverilog -o ctrl.vvp ../../../Verilog_Basis_Files/lab6-ctrl/controller_test.v controller.v
vvp ctrl.vvp
