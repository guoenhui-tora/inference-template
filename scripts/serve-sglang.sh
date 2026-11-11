#!/usr/bin/env bash
# 复制为 run 内的 serve.sh，再修改本次 SGLang 命令。
set -euo pipefail
export TZ=Asia/Shanghai
# CPU/NUMA 绑定由 docker.sh 管理。
export SGLANG_SET_CPU_AFFINITY=0
run_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
export RUN_DIR="$run_dir"
cd -- "$run_dir"
# 由 Docker 启动时，端口和服务名取 docker.sh 传入的连接信息。
model_path=${MODEL_PATH:-/models/model}
model_name=${MODEL_NAME:-model-name}
port=${PORT:-8000}
describe=false
if [[ ${1:-} == --describe ]]; then describe=true; shift; fi

# 普通性能对照按模型关闭 thinking。
command=(sglang serve
    --model-path "$model_path" --served-model-name "$model_name"
    --host 127.0.0.1 --port "$port"
    --tensor-parallel-size 4
    "$@")
printf 'Serve command: '; printf '%q ' "${command[@]}"; printf '\n'
if "$describe"; then exit 0; fi
exec "${command[@]}"
