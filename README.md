# Swiss knife for Subquery indexers

This project collects the optimal infrastructure that makes it easier to work with the infrastructure and improve the quality of its indexer.


# Infrastructure
![dgrm_1](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/7e5e1bbc-cbb1-4b1a-acfb-0ebce31bac07)



## What is inside?
Inside the package, you can always support the indexer on the current version without the risk of damaging the configuration :)

The solution is based on
- Postgres
- Subquerynetwork/indexer-coordinator
- Redis
- Subquerynetwork/indexer-proxy
- Trafik
- Grafana
- Node exporter
- Wireguard

## Requirements

 - Any Linux dist
 - docker-compose (https://github.com/docker/compose)
 - docker (https://www.docker.com/)
 - Hard drive NVME FROM 3TB
 - 64GB memory
 - Fast and stable ethernet connection

## New setup
```
cd /opt
git clone https://github.com/web3cdnservices/subquery-indexer-toolkit.git
cd subquery-indexer-toolkit
bash ./tools/generate_initial_configuration
```
Script will generate keys and request for domain name for indexer and email.
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/02422cd4-626a-4c53-b923-a19bc0203aae)

Next step preparing system and deploy all requrement software.
```
bash ./tools/start_indexer_with_wireguard 
```
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/d0a372c3-9d5a-45c3-8fc2-17f83df748aa)

**After this command all services succesfully initialized. Next step - Connect indexer wallet to coordinator and generate operator wallet.** 
```
Your SSL certificated will be requested automatically and reissue if needed.
```

![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/dcaba754-3669-4052-9acb-6f334acff2c4)


## Upgrade
```
cd /opt/subquery-indexer-toolkit
git pull
bash ./tools/start_indexer_with_wireguard 
```
**All your configs will be safe. You not need manually edit configurations anymore.**


## Connecting to wireguard network
**You shuld install wireguard client on your home pc**
- Macos (https://apps.apple.com/us/app/wireguard/id1451685025?mt=12)
- Linux (see repos. yum install wireguard, emerge -av wireguard, apt install wireguard)
- Windows (https://www.wireguard.com/install/)
  PS also you can have access to coordinator/grafana pr any service anywhere with your android,iphone. (Just import config)
  - https://play.google.com/store/apps/details?id=com.wireguard.android
  - https://apps.apple.com/us/app/wireguard/id1441195209
  
Archive **SubqueryIndexerHandbook.tar.gz** containes wireguard folder with 2 configuration files.
You need only one. Secondary for secondary device or for team.

Fell free copy paste configuratin and connect with it. Nothing nedd to change.

## Internal addresses
**By default Wireguard mask 10.253.1.0/24, but you can set you own in .env file**
Internal network mask: 172.29.13.0/24
All addresses and services accessible via private network!

|  Service |  Address | Annotation |
| :------------ | :------------ | :------------ |
|  Postgres |  172.29.13.2 | |
|  Redis | 172.29.13.4  | |
| Indexer Coordinator  |  [http://172.29.13.3:8000](http://172.29.13.3:8000 "http://172.29.13.3:8000") | |
| Indexer Proxy  |  [http://172.29.13.5:8375](http://172.29.13.5:8375 "http://172.29.13.5:8375") | |
| Traefik  |  172.29.13.6 | ports 8082(metrics), 80(public), 443(public with Letsencrypt) |
| Prometheus  |  [http://172.29.13.8:9090](http://172.29.13.8:9090 "http://172.29.13.8:9090") | |
| Node Exporter  |  [http://172.29.13.9:9100](http://172.29.13.9:9100 "http://172.29.13.9:9100") | |
| Grafana  |  [http://172.29.13.10:3000](http://172.29.13.10:3000 "http://172.29.13.10:3000") | |

Wireguard by default use 816 port. But you can set it manually in .env file. This file NEVER overwrites, Script preventing override.


# Inbox monitoring
- Postgres statistic
- Internal metrics from Subquery
- Traefik metrics (for load counting and error counter)
- Node exporter

  Some screenshots from just created instance.

Node exporter.
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/48db3d6a-387a-4711-8b8a-be0dfae1559d)

Postgres.
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/0badd3e8-ca1e-447d-86e6-572c7694d1b2)

Traefik.
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/48aae68f-7f4f-4314-aeb7-c77cca6bb816)

Basic indexer stat.
![image](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/94730cae-0c2c-4cae-8fc4-621c9808aed0)


*** New dashboards ***
![screencapture-192-168-155-8-3000-d-c8889d8b-d737-4e86-bdaa-9926870775f2-subquery-indexer-heartbeat-2023-07-28-16_27_36](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/949b1738-0ca3-4dbe-a699-03a92b89756c)

***New features for monitoring & alerting indexers***
![image_2023-07-30_05-15-03](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/299320f7-42f4-4a98-baaf-b3b1f738aa26)

*** revision 3 ***
![subquery_dashboar_demo_3](https://github.com/web3cdnservices/subquery-indexer-toolkit/assets/115787312/7cca8b12-2145-494a-8a48-c577c91f0bde)



  #### Guys, project from indexer for indexers. Fill free for Issues.
  ```
  Very soon postgres migration for low space servers! Be patient.
```
