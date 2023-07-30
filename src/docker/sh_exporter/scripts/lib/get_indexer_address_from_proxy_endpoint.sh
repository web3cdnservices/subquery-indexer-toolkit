#!/bin/bash

INDEXER_ADDR=`curl -s http://indexer_proxy:80/healthy | jq -r ".indexer"`

echo $INDEXER_ADDR
exit 0
