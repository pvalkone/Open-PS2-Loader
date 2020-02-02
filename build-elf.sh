#!/bin/sh
PS2SDK_REVISION=e2afe92

rm OPNPS2LD*.ELF
docker build --tag pvalkone/opl:latest --build-arg PS2SDK_REVISION=${PS2SDK_REVISION} .
# VBoxManage sharedfolder add "default" --name "OPL" --hostpath "$(pwd)" --automount
docker run --volume "/OPL:/src" --rm --name opl pvalkone/opl:latest /bin/bash -c "git add --all && HIRES=1 make clean rebuild"
OPLVERSION="$(docker run --volume "/OPL:/src" --rm --name opl pvalkone/opl:latest /bin/bash -c 'git add --all && make oplversion')-HIRES"
mv OPNPS2LD.ELF "./OPNPS2LD-${OPLVERSION}.ELF"
git reset
