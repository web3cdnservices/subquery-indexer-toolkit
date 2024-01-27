#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );
source $ROOT_PATH/lib/evm_methods
source $ROOT_PATH/lib/vars
source $ROOT_PATH/.env

INDEXER_ADDR=`bash ${ROOT_PATH}/lib/get_indexer_address_from_proxy_endpoint.sh`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

generate_result_container()
{
  cat <<EOF
[{"labels": {"env":"balance"}, "results": {"operator_balance": ${OPERATOR_BALANCE_}, "indexer_balance": ${INDEXER_BALANCE_} } }]
EOF
}

INDEXER_OPERATOR=$( echo $(call_contract_method  "eth_call"  "0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX" "0xf1485b4cfa7f4cd75f0b1395240f15b81a757cbb") | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')
INDEXER_OPERATOR_ADDR_NOPREFIX=`echo $INDEXER_OPERATOR | cut -c 3-45`

OPERATOR_BALANCE=$(hex_to_decimal $(call_method  "eth_getBalance" "$INDEXER_OPERATOR" "") 1 30 )

INDEXER_BALANCE=$(hex_to_decimal $(call_contract_method  "eth_call" "0x70a08231000000000000000000000000$INDEXER_ADDR_NOPREFIX" "0xcee50ee839a2ab3914cf4c3cbac78f6f11e0c937") 1 30 )

INDEXER_BALANCE_=$([[ -z "$INDEXER_BALANCE" ]] && echo 0 || echo $INDEXER_BALANCE)
OPERATOR_BALANCE_=$([[ -z "$OPERATOR_BALANCE" ]] && echo 0 || echo $OPERATOR_BALANCE)

#echo "Operator Balance $OPERATOR_BALANCE MATIC"
#echo "Indexer balance $INDEXER_BALANCE kSQT"

echo "$(generate_result_container)"

exit 0
