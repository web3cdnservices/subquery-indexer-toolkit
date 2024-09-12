#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );
source $ROOT_PATH/lib/evm_methods
source $ROOT_PATH/lib/contracts
source $ROOT_PATH/.env

INDEXER_ADDR=`bash ${ROOT_PATH}/lib/get_indexer_address_from_proxy_endpoint.sh`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

generate_result_container()
{
  cat <<EOF
[{"labels": {"env":"balance"}, "results": {"operator_balance": ${OPERATOR_BALANCE_:-0}, "indexer_balance": ${INDEXER_BALANCE_:-0} } }]
EOF
}

INDEXER_OPERATOR=$( echo $(call_contract_method  "eth_call"  "0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX" $INDEXER_REGISTRY_CONTRACT) | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')
INDEXER_OPERATOR_ADDR_NOPREFIX=`echo $INDEXER_OPERATOR | cut -c 3-45`

if [[ "$INDEXER_OPERATOR_ADDR_NOPREFIX" == "0x" ]]; then
OPERATOR_BALANCE_=0
else

OPERATOR_BALANCE=$(hex_to_decimal $(call_method  "eth_getBalance" "$INDEXER_OPERATOR" "") 1 30 )
OPERATOR_BALANCE_=$([[ -z "$OPERATOR_BALANCE" ]] && echo 0 || echo $OPERATOR_BALANCE)
fi

INDEXER_BALANCE=$(hex_to_decimal $(call_contract_method  "eth_call" "0x70a08231000000000000000000000000$INDEXER_ADDR_NOPREFIX" $SQTOKEN_CONTRACT) 1 30 )

INDEXER_BALANCE_=$([[ -z "$INDEXER_BALANCE" ]] && echo 0 || echo $INDEXER_BALANCE)


#echo "Indexer $INDEXER_OPERATOR_ADDR_NOPREFIX "
##echo "Operator Balance $OPERATOR_BALANCE MATIC"
#echo "Indexer balance $INDEXER_BALANCE kSQT"

echo "$(generate_result_container)"

exit 0