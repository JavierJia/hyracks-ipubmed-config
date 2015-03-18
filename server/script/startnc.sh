#/*
# Copyright 2009-2013 by The Regents of the University of California
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# you may obtain a copy of the License from
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#*/
hostname

MY_NAME=`hostname`
#Get the IP address of the cc
#CCHOST_NAME=`cat conf/master`
CURRENT_PATH=`pwd`
#CCHOST=`ssh ${CCHOST_NAME} "cd ${CURRENT_PATH}; bin/getip.sh"`
CCHOST="127.0.0.1"

#Import cluster properties
. conf/cluster.properties

#Clean up temp dir

function buildnc {
  rm -rf $NCTMP_DIR
  mkdir -p $NCTMP_DIR

  #Clean up log dir
  rm -rf $NCLOGS_DIR
  mkdir -p $NCLOGS_DIR

  #Clean up I/O working dir
  io_dirs=$(echo $IO_DIRS | tr "," "\n")
  for io_dir in $io_dirs
  do
    rm -rf $io_dir
    mkdir $io_dir
  done

  #Set JAVA_HOME
  export JAVA_HOME=$JAVA_HOME

  IPADDR="127.0.0.1"
  #echo $IPADDR

  #Set JAVA_OPTS
  export JAVA_OPTS=$NCJAVA_OPTS

  #Enter the temp dir
  cd $NCTMP_DIR

  #Launch hyracks nc
  cmd="$HYRACKS_HOME/bin/hyracksnc -cc-host $CCHOST -cc-port $CC_CLUSTERPORT -cluster-net-ip-address $IPADDR  -data-ip-address $IPADDR -result-ip-address $IPADDR \
      -node-id $NODEID -iodevices "${IO_DIRS}" &> $NCLOGS_DIR/$NODEID.log &"
  echo $cmd
  eval $cmd
  sleep 3
  cd $HYRACKS_HOME
}

. conf/nc1.properties
buildnc

. conf/nc2.properties
buildnc

