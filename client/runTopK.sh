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
INPUT="nc1:$DATA/orders.tbl.sorted.reverse.part1,nc1:$DATA/orders.tbl.sorted.reverse.part2"
INPUT="nc1:$DATA/orders.tbl.sorted.part1,nc1:$DATA/orders.tbl.sorted.part2"
INPUT="nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2"
OUTPUT="$DATA/orders.tbl.sorted"
FRAME_LIMIT=1000

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

#for topk in 5 50 500 5000 50000 500000 5000000 50000000 ; do
for topk in 5 50 500; do 

#topk=0
#while [ $topk -lt 10 ]; do
#  topk=$(($topk +1))
#for topk in 500000 ; do
#topk=300000
#while [ $topk -lt 2000000 ]; do
#  topk=$(($topk +100000))

  waitClean
  echo "heap sort topk: $topk"
  bin/tpchclient -host localhost -port 3099 \
    -infile-splits $INPUT\
    -outfile-splits nc1:$OUTPUT \
    -frame-limit $FRAME_LIMIT -topK $topk -heapSort 
  TOPK_RESULT="${OUTPUT}.hybrid.${topk}"
  mv ${OUTPUT} ${TOPK_RESULT}
  #done


  #topk=40000
  #while [ $topk -lt 200000 ]; do
  #  topk=$(($topk +10000))

  #for topk in 5 50 500 5000 50000 500000 5000000 50000000 ; do
  #  waitClean
  #  echo "external sort topk: $topk"
  #
  bin/tpchclient -host localhost -port 3099 \
    -infile-splits $INPUT\
    -outfile-splits nc1:$OUTPUT \
    -frame-limit $FRAME_LIMIT -topK $topk
  SORT_RESULT="${OUTPUT}.external.${topk}"
  mv ${OUTPUT} ${SORT_RESULT}

  diff ${TOPK_RESULT} ${SORT_RESULT}
done

#waitClean
#bin/tpchclient -host localhost -port 3099 \
  #  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
  #  -outfile-splits nc1:$OUTPUT \
  #  -frame-limit 4
#  diff $ANSWER $OUTPUT


#bin/tpchclient -host localhost -port 3099 \
  #  -infile-splits nc1:$DATA/orders.tbl.part1,nc1:$DATA/orders.tbl.part2\
  #  -outfile-splits nc1:$OUTPUT \
  #  -frame-limit 1000 -frame-size 32


