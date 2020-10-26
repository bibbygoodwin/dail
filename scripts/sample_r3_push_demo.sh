#!/bin/bash

# gen weight = 0.001, lr 1e-5
# 7/10 worked! and the alignment is good 10/10

# start new tmux sesson
SESS_NAME="sample_r3_push_demo"
DOC="empty"
#VENV_DIR="../.virtualenv/cdil/bin/activate"
VENV_DIR="~/Desktop/Research/2.DAIL/cdil/venv/bin/activate"
tmux kill-session -t $SESS_NAME
tmux new-session -d -s $SESS_NAME

BEGIN=0
END=0
TOTAL_GPU=4

for ((i=BEGIN; i<=END; i++)); do
gpu_num=$((i % TOTAL_GPU))

PYTHON_CMD="source ${VENV_DIR} && python train.py --algo ddpg --agent_type create_demo --load_expert_dir ./target_expert/reacher3_push/alldemo --save_dataset_dir ./target_demo/reacher3_push --edomain reacher3_push --ldomain reacher2_push --seed 100${i} --doc r3_push_demo --n_demo 200"

if [ $i -ne $BEGIN ]
then
    tmux selectp -t $SESS_NAME:1
    tmux split-window -h
    tmux send-keys -t $SESS_NAME:1 "$PYTHON_CMD" "C-m"
else
    tmux selectp -t $SESS_NAME:1
    tmux send-keys -t $SESS_NAME:1 "$PYTHON_CMD" "C-m"
fi

sleep 0.5

tmux select-layout tiled
done
tmux a -t $SESS_NAME
