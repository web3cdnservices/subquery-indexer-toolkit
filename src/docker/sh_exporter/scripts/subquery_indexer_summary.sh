#!/bin/bash
ROOT_PATH=$( dirname -- "$( readlink -f -- "$0"; )"; );

source $ROOT_PATH/lib/evm_methods
source $ROOT_PATH/.env

source $ROOT_PATH/lib/contracts

INTERNAL_COORDINATOR_URL="http://indexer_coordinator:${COORDINATOR_PORT:-8000}/"

INDEXER_ADDR=`bash $ROOT_PATH/lib/get_indexer_address_from_proxy_endpoint.sh`
INDEXER_ADDR_NOPREFIX=`echo $INDEXER_ADDR | cut -c 3-45`

generate_result_container()
{
  cat <<EOF
[{"labels": {"env":"indexer-summary"}, "results": {"self_stake": ${SELF_STAKED_BALANCE:-0}, "total_stake": ${INDEXER_TOTAL_STAKE:-0},"total_deployments":${INDEXER_TOTAL_DEPLOYMENTS:-0},"count_active_paygs": ${COUNT_INEXER_ACTIVE_PAYGS:-0} } }]
EOF
}

INDEXER_OPERATOR=$( echo $(call_contract_method  "eth_call"  "0x88c662aa000000000000000000000000$INDEXER_ADDR_NOPREFIX" $INDEXER_REGISTRY_CONTRACT) | rev |  cut -c 1-40 | rev | awk '{print "0x"$0}')
INDEXER_OPERATOR_ADDR_NOPREFIX=`echo $INDEXER_OPERATOR | cut -c 3-45`

#OPERATOR_BALANCE=$(hex_to_decimal $(call_method  "eth_getBalance" "$INDEXER_OPERATOR" "") 1 4 )

SELF_STAKED_BALANCE=$(hex_to_decimal $(call_contract_method  "eth_call" "0x1c503039000000000000000000000000${INDEXER_ADDR_NOPREFIX}000000000000000000000000${INDEXER_ADDR_NOPREFIX}" $INDEXER_STAKING_MANAGER) 1 40 )


INDEXER_TOTAL_STAKE=$(hex_to_decimal $(call_contract_method  "eth_call" "0xe9260898000000000000000000000000${INDEXER_ADDR_NOPREFIX}" $INDEXER_STAKING_MANAGER) 1 40)


INDEXER_TOTAL_DEPLOYMENTS=$(hex_to_decimal $(call_contract_method  "eth_call" "0x349ef7e3000000000000000000000000${INDEXER_ADDR_NOPREFIX}" $INDEXER_QUERY_REGISTRY) 1 40)

USER_ACTIVE_PAYGS=$(curl -s "${INTERNAL_COORDINATOR_URL}graphql" -H 'content-type: application/json' --data-raw '{"operationName":"UsersQuery","variables":{},"query":"query UsersQuery {\n  getAlivePaygs {\n    id\n    overflow\n    threshold\n    expiration\n  }\n}\n"}' )

COUNT_INEXER_ACTIVE_PAYGS=$(echo $USER_ACTIVE_PAYGS |  jq ".data.getAlivePaygs | length")


echo "$(generate_result_container)"

exit 0