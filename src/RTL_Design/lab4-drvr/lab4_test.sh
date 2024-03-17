#!/bin/bash

iverilog -o drvr.vvp ../../../Verilog_Basis_Files/lab4-drvr/driver_test.v driver.v
vvp drvr.vvp
