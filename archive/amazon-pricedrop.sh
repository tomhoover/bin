#!/usr/bin/env bash

cd ~/src/amazon-pricedrop || exit 1
cp all.txt all.bak
cp price_drops.txt price_drops.bak
cp purchases.csv purchases.bak
cat ./*.csv | sed -e '/^Order\ Date/d' -e '/^,,title,,asin/d' -e 's/\r$//' > purchases.tmp
rm ./*.csv
head -1 purchases.bak > purchases.csv
sort -u -k1,10 -t',' purchases.tmp >> purchases.csv
echo ",,title,,asin567890,,,,,,,,target_price" > wanted.csv

./amazon-pricedrop.py

diff price_drops.bak price_drops.txt
