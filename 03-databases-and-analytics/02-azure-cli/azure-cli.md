#### 1. Login to Azure

```sh
# login
az login
```

#### 2. Create MongoDB database

- Create **Resource group**

```sh
az group create --name homework-m3-rg --location northeurope
```

- Create **Azure Cosmos DB account with MongoDB API**

```sh
az cosmosdb create \
--name homework-m3-mongodb-acc \
--resource-group homework-m3-rg \
--kind MongoDB \
--server-version 7.0 \
--locations regionName=northeurope failoverPriority=0 isZoneRedundant=False \
--default-consistency-level Eventual \
--enable-automatic-failover false
```

- Set Network settings

```sh
az cosmosdb update \
--name homework-m3-mongodb-acc \
--resource-group homework-m3-rg \
--ip-range-filter "0.0.0.0,46.10.209.232"
```

- Create MongoDB Database

```sh
az cosmosdb mongodb database create \
--account-name homework-m3-mongodb-acc \
--resource-group homework-m3-rg \
--name homework-m3-personal-data-db
```

- Create MongoDB Collection

```sh
az cosmosdb mongodb collection create \
--account-name homework-m3-mongodb-acc \
--resource-group homework-m3-rg \
--database-name homework-m3-personal-data-db \
--name homework-m3-pd-collection \
--shard sex \
--max-throughput 1000
```

- Get the Connection String

```sh
az cosmosdb keys list \
--type connection-strings \
--name homework-m3-mongodb-acc \
--resource-group homework-m3-rg
```

- Connect to DB

- Select DB
