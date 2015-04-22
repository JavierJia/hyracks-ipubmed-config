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
ANSWER="$DATA/orders.tbl.answer"
OUTPUT="$DATA/orders.tbl.sorted"

\rm -rf $OUTPUT
chmod +x bin/tpchclient

function waitClean {
while [ `ls -l $HOME/tmp/nc1/t1/ | wc -l ` -gt 3 ] 
do
  echo "sweeping.."
  sleep 10s
done
sleep 2s
}
#bin/tpchclient -host localhost -port 3099 \
  #  -infile-splits nc1:$DATA/orders.tbl.part1,nc2:$DATA/orders.tbl.part2\
  #  -outfile-splits nc1:$OUTPUT \
  #  -frame-limit 1000


#bin/tpchclient -host localhost -port 3099 \
  #  -infile-splits nc1:$DATA/orders.tbl.part1,nc2:$DATA/orders.tbl.part2\
  #  -outfile-splits nc1:$OUTPUT \
  #  -frame-limit 4

#waitClean
#bin/tpchclient -host localhost -port 3099 \
#  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
#  -outfile-splits nc1:$OUTPUT \
#  -frame-limit 1000 
#diff $ANSWER $OUTPUT

waitClean
bin/tpchclient -host localhost -port 3099 \
  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
  -outfile-splits nc1:$OUTPUT \
  -frame-limit 1000 -topK 5 -heapSort 
diff $ANSWER $OUTPUT


#waitClean
#bin/tpchclient -host localhost -port 3099 \
#  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
#  -outfile-splits nc1:$OUTPUT \
#  -frame-limit 4
#diff $ANSWER $OUTPUT


#bin/tpchclient -host localhost -port 3099 \
#  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
#  -outfile-splits nc1:$OUTPUT \
#  -frame-limit 1000 -frame-size 32


