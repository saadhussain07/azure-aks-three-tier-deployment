#!/bin/bash
REGION="westus"
RGP="day11-demo-rg"
CLUSTER_NAME="day11-demo-cluster"
ACR_NAME="day11demoacr"
SQLSERVER="saadhussainsql1829"
DB="mhcdb"

# Create Resource group
az group create --name $RGP --location $REGION

# Deploy AKS
az aks create --resource-group $RGP --name $CLUSTER_NAME --enable-addons monitoring --generate-ssh-keys --location $REGION

# Deploy ACR
az acr create --resource-group $RGP --name $ACR_NAME --sku Standard --location $REGION

# Authenticate ACR with AKS
az aks update -n $CLUSTER_NAME -g $RGP --attach-acr $ACR_NAME

# Create SQL Server and DB
az sql server create -l $REGION -g $RGP -n $SQLSERVER -u sqladmin -p P2ssw0rd1234

az sql db create -g $RGP -s $SQLSERVER -n $DB --service-objective S0

# Allow Azure services through the SQL firewall
az sql server firewall-rule create \
  --resource-group $RGP \
  --server $SQLSERVER \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0