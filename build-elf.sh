#!/bin/sh

PS2SDK_REVISION=05bb1b6

rm OPNPS2LD*.ELF
docker build --tag pvalkone/opl:latest --build-arg PS2SDK_REVISION=${PS2SDK_REVISION} .
docker run --volume "$PWD:/src" --rm --name opl pvalkone/opl:latest /bin/bash -c "git add --all && VMC=1 GSM=1 HIRES=1 make clean rebuild"
OPLVERSION="$(docker run --volume "$PWD:/src" --rm --name opl pvalkone/opl:latest /bin/bash -c 'git add --all && make oplversion')-VMC-GSM-HIRES"
mv OPNPS2LD.ELF "./OPNPS2LD-${OPLVERSION}.ELF"
git reset
