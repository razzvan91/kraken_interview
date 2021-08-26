#!/bin/bash
#problem 4

#Below command is looking for the pods that are scheduled but not yet in READY state.

kubectl get po -l app=ltc --no-headers | awk -v col=3 '{print $col}' | tee pod_status.txt
a=$(wc -l pod_status.txt | awk '{print $1}')
b=$(grep -o -i Ready pod_status.txt | wc -l)

if [ $a -gt $b ]; then
  echo "We have $b ready pods out of $a"
fi

rm pod_status.txt
echo "---"
kubectl get pods -A
