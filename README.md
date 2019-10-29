# Ethereum-multi-nodes-setup
Setup Ethereum private chain at one server with more nodes.





# ENV requirement

Test system version: Ubuntu 18.04 LTS

Geth Version: 1.9.6-stable





# How to use

## Create files

```
bash setup.sh <node numbers>
```

This shell script will create all files for Ethereum needed.

`node number` is Ethereum node numbers you want to setup.

## Start Ethereum

```
bash start.sh <node numbers>
```

This shell script will start Ethereum.



## clean

```
bash clean.sh <node numbers>
```

This shell script will stop all geth processes and delete all files.



## Easy test

```
bash re-setup.sh <node numbers>
```

This shell script will execuate `clean.sh`, `setup.sh` and `start.sh`.

