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


if [ "$random" -eq 0 ] 
then
    for workload in 0 2 3 4 5 6 7 8 9 10 11 12; do
        if [ "$contention" -gt 16 ]
        then
            paste ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv > ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i '1d' ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i "1 i\cxl\tdram\t" ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
        else
            paste ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}_rs.tsv ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}_rs.tsv  > ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i '1d' ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i "1 i\cxl\tdram\tdram-r\tcxl-r\t" ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
        fi
    done
else
    for workload in 0 2 5 6; do
        if [ "$contention" -gt 16 ]
        then
            paste ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv > ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i '1d' ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i "1 i\cxl\tdram\t" ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
        else
            paste ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}.tsv ./data/postprocess/cxl_dram_workload${workload}_c${contention}_r${random}_rs.tsv ./data/postprocess/cxl_cxl_workload${workload}_c${contention}_r${random}_rs.tsv > ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i '1d' ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
            sed -i "1 i\cxl\tdram\tdram-r\tcxl-r\t" ./data/postprocess/cxl_mix_workload${workload}_c${contention}_r${random}.tsv
        fi
    done
fi

