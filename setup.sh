#!/bin/bash
node_number=$1
ip=$(hostname -i)
echo '################################'
echo '#   Configuring for '$node_number' nodes.   #'
echo '################################'
### Create directories for each node's configuration ###

echo '[1] create the folders'


n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n
    mkdir -p $qd/logs
    mkdir -p $qd/dd/geth
    let n++
done

### Make static-nodes.json and store keys ###

echo '[2] Creating Enodes and static-nodes.json.'

echo "[" > static-nodes.json
n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n

    # Generate the node's Enode and key
    enode=`bootnode -genkey "$qd"/dd/nodekey`
    enode=`bootnode -nodekey "$qd"/dd/nodekey -writeaddress`

    # Add the enode to static-nodes.json
    echo ' '$enode'@'$ip' '
    sep=`[[ $n !=  $node_number ]] && echo ","`
    echo '  "enode://'$enode'@'$ip':'$[$n+30300]'"'$sep >> static-nodes.json
    let n++
done
echo "]" >> static-nodes.json

### copy static-nodes.json in to qdata_n/dd folder #############################

echo '[3] copy static-nodes.json into qdata folder'
n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n
    
    cp static-nodes.json $qd/dd/static-nodes.json

    let n++
done
rm -rf static-nodes.json

#### Create accounts, keys and genesis.json file #######################

echo '[4] Creating Ether accounts and genesis.json.'

cat > genesis.json <<EOF
{
  "alloc": {
EOF

n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n

    # Generate an Ether account for the node
    touch $qd/passwords.txt
    account=`geth --datadir="$qd"/dd --password "$qd"/passwords.txt account new | awk 'NR==4' | awk '{print $6}'`

    # Add the account to the genesis block so it has some Ether at start-up
    sep=`[[ $n != $node_number ]] && echo ","`
    cat >> genesis.json <<EOF
    "${account}": {
      "balance": "1000000000000000000000000000"
    }${sep}
EOF

    let n++
done

cat >> genesis.json <<EOF
  },
  "config": {
    "chainId": 1155,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0
  },
  "nonce": "0x000000000000002a",
  "difficulty": "0x1",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x",
  "gasLimit": "0xFFFFFFFFFFFFFFFF"
}
EOF

#### Copy genesis.json into qdata_n folder #######################

echo '[5] copy genesis.json into qdata folder.'

n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n
    cp genesis.json $qd/genesis.json
    let n++
done

rm -rf genesis.json 


echo '################################'
echo '#             DONE!            #'
echo '################################'
