#!/bin/sh
python3 update_money.py $PWD/ money.xml
gnumeric money.xml &
