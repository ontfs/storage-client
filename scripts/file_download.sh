#!/bin/bash
./main file download --fileHash=$1 --maxPeerCnt=2 --decryptPwd="onchain" --inorder=true --outFilePath=$2
