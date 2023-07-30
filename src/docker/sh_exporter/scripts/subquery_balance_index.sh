#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );
source $ROOT_PATH/lib/evm_methods
source $ROOT_PATH/lib/vars
#echo $ROOT_PATH
INDEXER_ADDR=`bash ${ROOT_PATH}/lib/get_indexer_address_from_proxy_endpoint.sh`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

generate_result_container()
{
  cat <<EOF
[{"labels": {"hostname": "node-1","env":"balance"}, "results": {"operator_balance": ${OPERATOR_BALANCE}, "indexer_balance": ${INDEXER_BALANCE} } }]
EOF
}

INDEXER_OPERATOR=$( echo $(call_contract_method  "eth_call"  "0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX" "0xf1485b4cfa7f4cd75f0b1395240f15b81a757cbb") | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')
INDEXER_OPERATOR_ADDR_NOPREFIX=`echo $INDEXER_OPERATOR | cut -c 3-45`

OPERATOR_BALANCE=$(hex_to_decimal $(call_method  "eth_getBalance" "$INDEXER_OPERATOR" "") 1 30 )

INDEXER_BALANCE=$(hex_to_decimal $(call_contract_method  "eth_call" "0x70a08231000000000000000000000000$INDEXER_ADDR_NOPREFIX" "0xcee50ee839a2ab3914cf4c3cbac78f6f11e0c937") 1 30 )



echo "$(generate_result_container)"

exit 0
