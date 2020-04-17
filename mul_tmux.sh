#!/bin/bash

user=`whoami`
port=22


while getopts "i:l:p:" opt
do
        case $opt in
                i)identify=$OPTARG;;
                l)user=$OPTARG;;
                p)port=$OPTARG;;
        esac
done

argAll=`echo $* | awk '{print $NF}'`

if [[ "$identify" == "" ]] ; then
        SSHCMD="ssh -o StrictHostKeyChecking=no -l $user -p $port "
else
        SSHCMD="ssh -o StrictHostKeyChecking=no  -i $identify -l $user -p $port "
fi

j=0
for i in `cat $argAll`; do
        if [[ $j -eq 0 ]] ; then
                tmux new-window -n "tmux1" "$SSHCMD$i"
                j=$((j+1))
                continue
        fi
        tmux split-window "$SSHCMD$i"
        tmux select-layout tiled
done
tmux set synchronize-panes on
