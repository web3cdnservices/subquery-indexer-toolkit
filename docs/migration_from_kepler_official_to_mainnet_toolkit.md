# How to migrate Subquery indexer from `kepler Official docker-composer` to `Toolkit Mainnet Solution`
## Who can use it?
`Anyone. Migration script support Original Subquery Composer scripts and Toolkit.` 

`PS. for long-live processes please always use tmux or screen. (tmux new)`

## # Setup software & prepare env.
`Run command from root.`
```
bash <(curl -s https://raw.githubusercontent.com/web3cdnservices/subquery-indexer-toolkit/mainnet/tools/migrate_from_kepler_to_mainnet_toolkit)
```

## OPTIONAL (Enable external access from WEB to grafana. will require subdomain.)
```
/usr/src/subquery-indexer-toolkit-mainnet/tools/enable_external_access_to_grafana
```


## OPTIONAL (Enable external access from WEB to COORDINATOR. will require subdomain And login&password for basic auth)
```
/usr/src/subquery-indexer-toolkit-mainnet/tools/enable_external_access_to_coordinator
```


## Run indexer.  (first run took 2-3 minutes. We use only sources, for prevent problems)
```
/usr/src/subquery-indexer-toolkit-mainnet/tools/start_indexer_with_wireguard
```




## Whats in? (Actions)
 - Detect old indexer configuration (location & database password)
 - Detect your postgres version
 - Stop old projects and old testnet indexer
 - stop&disable nginx
 - Install Mainnet indexer
 - Generate configuration, certificates, and move database.
 - Start new full-featured indexer.

PS after installation, backup your passwords and keys. All data located in:
`/usr/src/subquery-indexer-toolkit-mainnet/SubqueryIndexerHandbook.tar.gz`
