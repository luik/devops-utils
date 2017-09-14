#!/usr/bin/env bash
aws ec2 request-spot-instances --spot-price "0.1" --launch-specification file://i3-large.json
