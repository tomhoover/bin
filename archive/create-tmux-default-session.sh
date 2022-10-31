#!/usr/bin/env sh

tmux new-session -d -s default

tmux new-window -t default:1 -n 'Server1' 'ssh root@10.x.x.x'
tmux new-window -t default:2 -n 'Server2' 'ssh root@10.x.x.x'
tmux new-window -t default:3 -n 'Server3' 'ssh root@10.x.x.x'
tmux new-window -t default:4 -n 'Server4' 'ssh root@10.x.x.x'
tmux new-window -t default:5 -n 'Server5' 'ssh root@10.x.x.x'

tmux select-window -t default:1
tmux -2 attach-session -t default
