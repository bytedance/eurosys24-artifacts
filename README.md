# Artifacts of EuroSys 2024 Paper "Exploring Performance and Cost Optimization with ASIC-Based CXL Memory"

## Directory structure

```
<eurosys24-artifacts>
│   README.md
└───InferLLM: modified version of InferLLM for bandwidth test
└───data
│   │   cxl: measurement result on the CXL server
│   │   ddr5: measurement result on the DDR5 server
└───microbenchmark
│       │  get_cxl.sh 
│       │  get_dram_readonly.sh 
│       │  get_dram_rs.sh 
│       │  get_dram.sh 
│       │  collect_workload_concurrency_cxl_remote_socket.sh 
│       │  collect_workload_concurrency_cxl.sh 
│       │  collect_workload_concurrency_ddr_remote_numa.sh 
│       │  collect_workload_concurrency_ddr.sh 
│       │  collect_workload_concurrency_ddr_remote_socket.sh 
│       │  collect_workload_concurrency_mix.sh 
└───spark: this folder contains all environment and scripts used in spark evaluation
│   │   conf: spark environment setup
|   |   start*.sh: scripts to launch spark cluster
```
