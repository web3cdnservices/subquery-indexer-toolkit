#!/bin/bash

INDEXER_ADDR=`curl -s http://indexer_proxy:8375/healthy | jq -r ".indexer"`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

indexer_operator_contract_payload()
{
  cat <<EOF
{"jsonrpc":"2.0","id":4,"method":"eth_call","params": [{"from":"0x0000000000000000000000000000000000000000","data":"0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX","to":"0xf1485b4cfa7f4cd75f0b1395240f15b81a757cbb"},"latest"]}
EOF
}
operator_contract_get_matic_balance()
{
  cat <<EOF
{"jsonrpc": "2.0","method": "eth_getBalance","params": ["$INDEXER_OPERATOR", "latest"],"id": 1}
EOF
}

indexer_contract_get_sqt_balance()
{
  cat <<EOF
{"jsonrpc":"2.0","id":2,"method":"eth_call","params":[{"from":"0x0000000000000000000000000000000000000000","data":"0x70a08231000000000000000000000000$INDEXER_ADDR_NOPREFIX","to":"0xcee50ee839a2ab3914cf4c3cbac78f6f11e0c937"},"latest"]}
EOF
}
generate_result_container()
{
  cat <<EOF
{"labels": {"hostname": "node-1","env":"balance"}, "results": {"operator_balance": ${OPERATOR_BALANCE}, "indexer_balance": ${INDEXER_BALANCE} } }
EOF
}

INDEXER_OPERATOR=$(curl -s 'https://polygon-rpc.com' --data-raw "$(indexer_operator_contract_payload)" | jq -r ".result" | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')


OPERATOR_BALANCE=$(echo "ibase=16; $(curl -s 'https://polygon-rpc.com' --data-raw "$(operator_contract_get_matic_balance)" | jq -r ".result" | sed "s/0x//" | sed 's/^0*//' | tr [:lower:] [:upper:]) " | bc | cut -c 1-4 )

INDEXER_BALANCE=$(echo "ibase=16; $(curl -s 'https://polygon-rpc.com' --data-raw "$(indexer_contract_get_sqt_balance)" | jq -r ".result" | sed "s/0x//" | sed 's/^0*//' | tr [:lower:] [:upper:]) " | bc | cut -c 1-4)


#echo "Operator Balance $OPERATOR_BALANCE MATIC"
#echo "Indexer balance $INDEXER_BALANCE kSQT"

echo "$(generate_result_container)"

exit 0
