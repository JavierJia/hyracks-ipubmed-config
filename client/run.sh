#!/bin/bash - 
#===============================================================================
#
#          FILE: run.sh
# 
#         USAGE: ./run.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Jianfeng Jia (), jianfeng.jia@gmail.com
#  ORGANIZATION: ics.uci.edu
#       CREATED: 03/18/2015 01:31:48 AM PDT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

set -o nounset                              # Treat unset variables as an error
DATA="/home/jianfeng/data/tpch"
OUTPUT="$DATA/orders.tbl.sorted"

\rm -rf $OUTPUT
chmod +x bin/tpchclient

bin/tpchclient -host localhost -port 3099 \
  -infile-splits nc1:$DATA/orders.tbl.part1,nc2:$DATA/orders.tbl.part2\
  -outfile-splits nc1:$OUTPUT \
  -frame-limit 4 

