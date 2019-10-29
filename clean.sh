#!/bin/bash
node_number=$1

echo '################################'
echo '#             Clean            #'
echo '################################'


echo '[1] stop Ethereum.'
killall -9 geth

echo '[2] delete files.'
n=1
while (( $n<=$node_number ))
do
    qd=qdata_$n
    rm -rf $qd
    let n++
done

echo '################################'
echo '#             DONE!            #'
echo '################################'
