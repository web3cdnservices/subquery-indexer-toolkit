#!/bin/sh
set -x
# Mainnet
addPeers() {
  sleep $1;
  shift;


}

addPeers 10 &
