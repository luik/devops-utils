#!/usr/bin/env bash
aws ec2 request-spot-instances --spot-price "2" --launch-specification file://i3-8xlarge-win.json