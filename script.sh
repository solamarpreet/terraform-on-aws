#!/bin/bash
apt update && apt install -y nginx
echo "working" > /tmp/userdatacheck.txt
