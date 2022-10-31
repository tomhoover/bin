#!/usr/bin/env bash

ls /pool && exit

fusermount -uz /pool
mount /pool

grep mhddfs /var/log/*log | mail -s "remounted /pool" tom@hisword.net
