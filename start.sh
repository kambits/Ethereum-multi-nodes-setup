#!/bin/bash
node_number=$1
echo '################################'
echo '#        Start Ethereum        #'
echo '################################'

### init genesis.json
echo '[1] init genesis.json.'
n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n
    
    geth --nousb --datadir $qd/dd init $qd/genesis.json 

    let n++
done
sleep 1

### start quorum
echo '[2] start Ethereum.'
n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n

    nohup geth --nousb --identity "Blocktest" --rpc --rpcapi eth,web3,personal,admin,miner,txpool,net --rpcport "$[$n+22000]" --rpccorsdomain "*" --rpcaddr 0.0.0.0 --datadir $qd/dd --port "$[$n+30300]" --nodiscover --miner.gaslimit 18446744073709551615 --miner.gastarget 18446744073709551615 --allow-insecure-unlock --mine --miner.threads 5 --verbosity 4 >$qd/logs/geth.log 2>&1 &
    
    sleep 1
    let n++
done


echo '################################'
echo '#            DONE!             #'
echo '################################'
