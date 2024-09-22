#!/bin/bash

echo -n "ruu_size,16,lsq_size,8,fpalu_count,4,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:4:l,dl2_cache_config,ul2:1024:64:4:l,il1_cache_config,il1:521:32:1:l,il2_cache_config,dl2,bpred_type,bimod,bpred_ras,8,bpred_btb_size,512,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS=""
./run-wattch 2>&1 | tee default.txt | ./scripts/tabulate

echo -n "ruu_size,16,lsq_size,16,fpalu_count,4,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:4:l,dl2_cache_config,ul2:1024:64:4:l,il1_cache_config,il1:521:32:1:l,il2_cache_config,dl2,bpred_type,bimod,bpred_ras,8,bpred_btb_size,512,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16"
./run-wattch 2>&1 | tee ruu-lsq.txt | ./scripts/tabulate

echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:4:l,dl2_cache_config,ul2:1024:64:4:l,il1_cache_config,il1:521:32:1:l,il2_cache_config,dl2,bpred_type,bimod,bpred_ras,8,bpred_btb_size,512,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16 -res:fpalu 1 -res:fpmult 1"
./run-wattch 2>&1 | tee fp-alu-1.txt | ./scripts/tabulate


echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:4:l,dl2_cache_config,ul2:1024:64:4:l,il1_cache_config,il1:521:32:1:l,il2_cache_config,dl2,bpred_type,comb,bpred_ras,8,bpred_btb_size,256,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16
-res:fpalu 1 -res:fpmult 1
-bpred comb -bpred:comb 128 -bpred:ras 8 -bpred:btb 256 2
"
./run-wattch 2>&1 | tee bpred-tweaked.txt | ./scripts/tabulate


echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:1:l,dl2_cache_config,ul2:128:64:2:l,il1_cache_config,il1:64:64:1:r,il2_cache_config,dl2,bpred_type,comb,bpred_ras,8,bpred_btb_size,256,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16
-res:fpalu 1 -res:fpmult 1
-bpred comb -bpred:comb 128 -bpred:ras 8 -bpred:btb 256 2
-cache:dl1 dl1:128:32:1:l
-cache:dl2 ul2:128:64:2:l
-cache:il1 il1:64:64:1:r
-cache:il2 dl2
"
./run-wattch 2>&1 | tee cache-tweaked.txt | ./scripts/tabulate


echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,2,issue_width,2,commit_width,8,ialu_count,4,dl1_cache_config,dl1:128:32:1:l,dl2_cache_config,ul2:128:64:2:l,il1_cache_config,il1:64:64:1:r,il2_cache_config,dl2,bpred_type,comb,bpred_ras,8,bpred_btb_size,256,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16
-res:fpalu 1 -res:fpmult 1
-bpred comb -bpred:comb 128 -bpred:ras 8 -bpred:btb 256 2
-cache:dl1 dl1:128:32:1:l
-cache:dl2 ul2:128:64:2:l
-cache:il1 il1:64:64:1:r
-cache:il2 dl2
-decode:width 2 -issue:width 2 -commit:width 8
"
./run-wattch 2>&1 | tee issue-decode-commit-tweaked.txt | ./scripts/tabulate


echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,2,issue_width,2,commit_width,8,ialu_count,4,dl1_cache_config,dl1:128:32:1:l,dl2_cache_config,ul2:128:64:2:l,il1_cache_config,il1:64:64:1:r,il2_cache_config,dl2,bpred_type,comb,bpred_ras,8,bpred_btb_size,256,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,32,itlb_assoc,4,dtlb_assoc,4"
export SSFLAGS="-ruu:size 16 -lsq:size 16
-res:fpalu 1 -res:fpmult 1
-bpred comb -bpred:comb 128 -bpred:ras 8 -bpred:btb 256 2
-cache:dl1 dl1:128:32:1:l
-cache:dl2 ul2:128:64:2:l
-cache:il1 il1:64:64:1:r
-cache:il2 dl2
-decode:width 2 -issue:width 2 -commit:width 8
-res:ialu 2
"
./run-wattch 2>&1 | tee less-alu.txt | ./scripts/tabulate


echo -n "ruu_size,16,lsq_size,16,fpalu_count,1,fpmult_count,1,decode_width,4,issue_width,4,commit_width,4,ialu_count,4,dl1_cache_config,dl1:128:32:4:l,dl2_cache_config,ul2:1024:64:4:l,il1_cache_config,il1:521:32:1:l,il2_cache_config,dl2,bpred_type,bimod,bpred_ras,8,bpred_btb_size,512,bpred_btb_assoc,2,itlb_sets,16,dtlb_sets,16,itlb_assoc,1,dtlb_assoc,1"
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
-tlb:dtlb dtlb:16:4096:1:l
"
./run-wattch 2>&1 | tee simulator-output.txt | ./scripts/tabulate

