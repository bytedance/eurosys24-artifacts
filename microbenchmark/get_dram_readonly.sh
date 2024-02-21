#!/usr/bin/bash

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

source_numa=0

# numactl -H | grep cpu
max_cpu_per_node=11

node_0_0=( 0 1 2 3 4 5 6 7 8 9 10 11 )
node_0_1=( 96 97 98 99 100 101 102 103 104 105 106 107 )
node_1_0=( 12 13 14 15 16 17 18 19 20 21 22 23 )
node_1_1=( 108 109 110 111 112 113 114 115 116 117 118 119 )
node_2_0=( 24 25 26 27 28 29 30 31 32 33 34 35 )
node_2_1=( 120 121 122 123 124 125 126 127 128 129 130 131 )
node_3_0=( 36 37 38 39 40 41 42 43 44 45 46 47 )
node_3_1=( 132 133 134 135 136 137 138 139 140 141 142 143 )
node_4_0=( 48 49 50 51 52 53 54 55 56 57 58 59 )
node_4_1=( 144 145 146 147 148 149 150 151 152 153 154 155 )
node_5_0=( 60 61 62 63 64 65 66 67 68 69 70 71 )
node_5_0=( 156 157 158 159 160 161 162 163 164 165 166 167 )
node_6_0=( 72 73 74 75 76 77 78 79 80 81 82 83 )
node_6_1=( 168 169 170 171 172 173 174 175 176 177 178 179 )
node_7_0=( 84 85 86 87 88 89 90 91 92 93 94 95 )
node_7_1=( 180 181 182 183 184 185 186 187 188 189 190 191 )

# Processor on same NUMA node
for dst_numa in 0 1 2 3 4 5 6 7; do
    for concurrency in 1 4 8 12 16 20; do
        for random in 0 1; do
            if [[ $random -eq 0 ]]
            then
                if [ "$concurrency" -gt "$max_cpu_per_node" ]; then
                    suffix_0=${dst_numa}_0
                    array_name_0_s=node_$suffix_0[1]
                    eval "start_node_0=\${$array_name_0_s}"
                    end_node_index_0=11
                    array_name_0_e=node_$suffix_0[$end_node_index_0]
                    eval "end_node_0=\${$array_name_0_e}"
                    suffix_1=${dst_numa}_1
                    end_node_index_1=$((concurrency - max_cpu_per_node))
                    array_name_1_s=node_$suffix_1[0]
                    eval "start_node_1=\${$array_name_1_s}"
                    array_name_1_e=node_$suffix_1[$end_node_index_1]
                    eval "end_node_1=\${$array_name_1_e}"
                    echo d${dst_numa}_c${concurrency}_w0_r${random}
                    ./mlc --loaded_latency -j$source_numa -k${start_node_0}-${end_node_0},${start_node_1}-${end_node_1} &> log_d${dst_numa}_c${concurrency}_w0_r${random}
                else
                    suffix_0=${dst_numa}_0
                    array_name_0_s=node_$suffix_0[1]
                    eval "start_node_0=\${$array_name_0_s}"
                    end_node_index_0=$concurrency
                    array_name_0_e=node_$suffix_0[$end_node_index_0]
                    eval "end_node_0=\${$array_name_0_e}"
                    echo d${dst_numa}_c${concurrency}_w0_r${random}
                    ./mlc --loaded_latency -j$source_numa -k${start_node_0}-${end_node_0} &> log_d${dst_numa}_c${concurrency}_w0_r${random}
                fi
            else
                if [ "$concurrency" -gt "$max_cpu_per_node" ]; then
                    suffix_0=${dst_numa}_0
                    array_name_0_s=node_$suffix_0[1]
                    eval "start_node_0=\${$array_name_0_s}"
                    end_node_index_0=11
                    array_name_0_e=node_$suffix_0[$end_node_index_0]
                    eval "end_node_0=\${$array_name_0_e}"
                    suffix_1=${dst_numa}_1
                    end_node_index_1=$((concurrency - max_cpu_per_node))
                    array_name_1_s=node_$suffix_1[0]
                    eval "start_node_1=\${$array_name_1_s}"
                    array_name_1_e=node_$suffix_1[$end_node_index_1]
                    eval "end_node_1=\${$array_name_1_e}"
                    echo d${dst_numa}_c${concurrency}_w0_r${random}
                    ./mlc --loaded_latency -j$source_numa -k${start_node_0}-${end_node_0},${start_node_1}-${end_node_1}  -U &> log_d${dst_numa}_c${concurrency}_w0_r${random}
                else
                    suffix_0=${dst_numa}_0
                    array_name_0_s=node_$suffix_0[1]
                    eval "start_node_0=\${$array_name_0_s}"
                    end_node_index_0=$concurrency
                    array_name_0_e=node_$suffix_0[$end_node_index_0]
                    eval "end_node_0=\${$array_name_0_e}"
                    echo d${dst_numa}_c${concurrency}_w0_r${random}
                    ./mlc --loaded_latency -j$source_numa -k${start_node_0}-${end_node_0} -U &> log_d${dst_numa}_c${concurrency}_w0_r${random}
                fi
            fi
        done
    done
done


# Mixed processor
for concurrency in 1 2 4 8 16 32 64; do
    for random in 0 1; do
        if [[ $random -eq 0 ]]
        then
            echo m_c${concurrency}_w0_r${random}
            ./mlc --loaded_latency -j$source_numa -k1-${concurrency} &> log_m_c${concurrency}_w0_r${random}
        else
            echo m_c${concurrency}_w0_r${random}
            ./mlc --loaded_latency -j$source_numa -k1-${concurrency} -U &> log_m_c${concurrency}_w0_r${random}
        fi
    done
done
