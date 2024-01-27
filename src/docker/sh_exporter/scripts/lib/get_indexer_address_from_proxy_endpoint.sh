#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );
source $ROOT_PATH/../.env


INDEXER_ADDR=`curl -s http://indexer_proxy:$(INDEXER_PROXY_PORT || 8375)/healthy | jq -r ".indexer"`

echo $INDEXER_ADDR
exit 0