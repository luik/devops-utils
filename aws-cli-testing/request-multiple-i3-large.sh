#!/usr/bin/env bash
for i in `seq 1 3`
do
    index=$(($i + 50))
    sed "s/10.0.0.101/10.0.0.${index}/" i3-large.json > i3-large-${index}.json
    aws ec2 request-spot-instances --spot-price "0.1" --launch-specification file://i3-large-${index}.json
    rm -f i3-large-${index}.json
done
