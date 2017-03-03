#!/usr/bin/env bash
aws ec2 request-spot-instances --spot-price "0.5" --launch-specification file://i3-xlarge-win.json