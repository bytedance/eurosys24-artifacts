#!/bin/bash

# Copyright 2024 Bytedance Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

contention=${1:-64}
random=${2:-0}

rm ./data/postprocess/cxl_dram_workload_c${contention}_r${random}.tsv
rm ./data/postprocess/cxl_dram_workload_rw_c${contention}_r${random}.tsv

if [ "$random" -eq 0 ]
then
    for workload in 0 2 3 4 5 6 7 8 9 10 11 12; do
        rm post_concurrency_w${workload}
        for concurrency in 1 2 4 8 16 32 64; do
            if [ "$contention" -ge $concurrency ]
            then
                cat ./data/ddr5/log_m_c${concurrency}_w${workload}_r${random} | awk 'NR >= 11 && NR <= 29' | awk '{printf ("%s\t%s\n",$3,$2)}'>> post_concurrency_w${workload} 
            else
                break
            fi
        done
        sort -n -k1 -o post_concurrency_w${workload} post_concurrency_w${workload} 
    done
    paste post_concurrency_w0 post_concurrency_w2 post_concurrency_w3 post_concurrency_w4 post_concurrency_w5 post_concurrency_w6 post_concurrency_w7 post_concurrency_w8 post_concurrency_w9 post_concurrency_w10 post_concurrency_w11 post_concurrency_w12 > ./data/postprocess/cxl_dram_workload_c${contention}_r${random}.tsv
    sed -i '1 i\0\t2\t3\t4\t5\t6\t7\t8\t9\t10\t11\t12\t' ./data/postprocess/cxl_dram_workload_c${contention}_r${random}.tsv
    paste post_concurrency_w6 post_concurrency_w5 post_concurrency_w4 post_concurrency_w2 post_concurrency_w3 post_concurrency_w12 post_concurrency_w0 > ./data/postprocess/cxl_dram_workload_rw_c${contention}_r${random}.tsv
    sed -i '1 i\6\t5\t4\t2\t3\t12\t0\t' ./data/postprocess/cxl_dram_workload_rw_c${contention}_r${random}.tsv
else
    for workload in 0 2 5 6; do
        rm post_concurrency_w${workload}
        for concurrency in 1 2 4 8 16 32 64; do
            if [ "$contention" -ge $concurrency ]
            then
                cat ./data/ddr5/log_m_c${concurrency}_w${workload}_r${random} | awk 'NR >= 11 && NR <= 29' | awk '{printf ("%s\t%s\n",$3,$2)}'>> post_concurrency_w${workload} 
            else
                break
            fi
        done
        sort -n -k1 -o post_concurrency_w${workload} post_concurrency_w${workload} 
    done
    paste post_concurrency_w0 post_concurrency_w2 post_concurrency_w5 post_concurrency_w6  > ./data/postprocess/cxl_dram_workload_c${contention}_r${random}.tsv
    sed -i '1 i\0\t2\t5\t6\t' ./data/postprocess/cxl_dram_workload_c${contention}_r${random}.tsv
    paste post_concurrency_w6 post_concurrency_w5 post_concurrency_w2 post_concurrency_w0 > ./data/postprocess/cxl_dram_workload_rw_c${contention}_r${random}.tsv
    sed -i '1 i\6\t5\t2\t0\t' ./data/postprocess/cxl_dram_workload_rw_c${contention}_r${random}.tsv
fi


if [ "$random" -eq 0 ]
then
    for workload in 0 2 3 4 5 6 7 8 9 10 11 12; do
        rm post_concurrency_w${workload}_only
        for concurrency in 1 2 4 8 16 32 64; do
            if [ "$contention" -ge $concurrency ]
            then
                cat ./data/ddr5/log_m_c${concurrency}_w${workload}_r${random} | awk 'NR >= 11 && NR <= 29' | awk '{printf ("%s\t%s\n",$3,$2)}'>> post_concurrency_w${workload}_only 
            else
                break
            fi
        done
        sort -n -k1 -o post_concurrency_w${workload}_only post_concurrency_w${workload}_only 
        rm ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
        cat post_concurrency_w${workload}_only > ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
        sed -i "1 i\\${workload}\t" ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
    done
else
    for workload in 0 2 5 6; do
        rm post_concurrency_w${workload}_only
        for concurrency in 1 2 4 8 16 32 64; do
            if [ "$contention" -ge $concurrency ]
            then
                cat ./data/ddr5/log_m_c${concurrency}_w${workload}_r${random} | awk 'NR >= 11 && NR <= 29' | awk '{printf ("%s\t%s\n",$3,$2)}'>> post_concurrency_w${workload}_only 
            else
                break
            fi
        done
        sort -n -k1 -o post_concurrency_w${workload}_only post_concurrency_w${workload}_only 
        rm ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
        cat post_concurrency_w${workload}_only > ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
        sed -i "1 i\\${workload}\t" ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv
    done
fi

# Clean up tmp
for workload in 0 2 3 4 5 6 7 8 9 10 11 12; do
    rm post_concurrency_w${workload}
    rm post_concurrency_w${workload}_only
done
