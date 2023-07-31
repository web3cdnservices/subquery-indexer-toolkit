#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );

source $ROOT_PATH/lib/evm_methods
source $ROOT_PATH/lib/vars
INDEXER_ADDR=`bash $ROOT_PATH/lib/get_indexer_address_from_proxy_endpoint.sh`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

generate_result_container()
{
  cat <<EOF
[{"labels": {"env":"indexer-summary"}, "results": {"self_stake": ${SELF_STAKED_BALANCE}, "total_stake": ${INDEXER_TOTAL_STAKE},"total_deployments":$INDEXER_TOTAL_DEPLOYMENTS,"count_active_paygs": ${COUNT_INEXER_ACTIVE_PAYGS} } }]
EOF
}

INDEXER_OPERATOR=$( echo $(call_contract_method  "eth_call"  "0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX" "0xf1485b4cfa7f4cd75f0b1395240f15b81a757cbb") | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')
INDEXER_OPERATOR_ADDR_NOPREFIX=`echo $INDEXER_OPERATOR | cut -c 3-45`

#OPERATOR_BALANCE=$(hex_to_decimal $(call_method  "eth_getBalance" "$INDEXER_OPERATOR" "") 1 4 )

SELF_STAKED_BALANCE=$(hex_to_decimal $(call_contract_method  "eth_call" "0x1c503039000000000000000000000000${INDEXER_ADDR_NOPREFIX}000000000000000000000000${INDEXER_ADDR_NOPREFIX}" "0x379190a8638d2234533eb6fa4575012fd21eaea5") 1 40 )


INDEXER_TOTAL_STAKE=$(hex_to_decimal $(call_contract_method  "eth_call" "0xe9260898000000000000000000000000${INDEXER_ADDR_NOPREFIX}" "0x379190a8638d2234533eb6fa4575012fd21eaea5") 1 40)


INDEXER_TOTAL_DEPLOYMENTS=$(hex_to_decimal $(call_contract_method  "eth_call" "0x349ef7e3000000000000000000000000${INDEXER_ADDR_NOPREFIX}" "0x7d77597ff06795eb1fa796f8e959ed3184e34299") 1 40)

USER_ACTIVE_PAYGS=$(curl -s "${INTERNAL_COORDINATOR_URL}graphql" -H 'content-type: application/json' --data-raw '{"operationName":"UsersQuery","variables":{},"query":"query UsersQuery {\n  getAlivePaygs {\n    id\n    overflow\n    threshold\n    expiration\n  }\n}\n"}' )

COUNT_INEXER_ACTIVE_PAYGS=$(echo $USER_ACTIVE_PAYGS |  jq ".data.getAlivePaygs | length")


echo "$(generate_result_container)"

exit 0
