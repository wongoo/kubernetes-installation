#!/bin/sh

if [ "$CURR_NODE_IP" == "" ]
then
    export CURR_NODE_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
    echo "current ip: $CURR_NODE_IP"
fi
