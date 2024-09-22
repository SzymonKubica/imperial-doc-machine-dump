#!/bin/bash

export SSFLAGS="-ruu:size 16 -lsq:size 16
-res:fpalu 1 -res:fpmult 1
-bpred comb -bpred:comb 128 -bpred:ras 8 -bpred:btb 256 2
-cache:dl1 dl1:128:32:1:l
-cache:dl2 ul2:128:64:2:l
-cache:il1 il1:64:64:1:r
-cache:il2 dl2
-decode:width 2 -issue:width 2 -commit:width 8
-res:ialu 2
-tlb:itlb itlb:16:4096:1:l
-tlb:dtlb dtlb:16:4096:1:l"

./run-wattch 2>&1 | tee simulation_output.txt | ./scripts/tabulate

