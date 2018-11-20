# Adapted from https://github.com/ifcaro/Open-PS2-Loader/blob/master/.travis.yml

FROM ubuntu:trusty

ARG PS2SDK_REVISION

ENV PS2DEV /ps2dev
ENV PS2SDK ${PS2DEV}/ps2sdk
ENV PATH ${PATH}:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin
ENV PS2ETH ${PS2DEV}/ps2eth
ENV GSKIT ${PS2DEV}/gsKit
ENV LANG C
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --quiet=2 update
RUN apt-get install --assume-yes --quiet=2 gcc patch wget make git libc6-dev zlib1g zlib1g-dev libucl1 libucl-dev

RUN git clone --quiet https://github.com/ps2dev/ps2toolchain.git
RUN cd /ps2toolchain && sed -i -e 's|git clone https://github.com/ps2dev/ps2sdk && cd ps2sdk|git clone https://github.com/ps2dev/ps2sdk \&\& cd ps2sdk \&\& git reset --hard '${PS2SDK_REVISION}'|' -e 's|origin/master|'${PS2SDK_REVISION}'|' scripts/005-ps2sdk.sh && bash ./toolchain.sh

RUN git clone --quiet https://github.com/ps2dev/ps2sdk-ports.git
RUN cd /ps2sdk-ports/zlib && make install
RUN cd /ps2sdk-ports/libpng && make install
RUN cd /ps2sdk-ports/libjpeg && make install
RUN cd /ps2sdk-ports/freetype-2.9.1 && bash ./SetupPS2.sh

RUN git clone --quiet https://github.com/ps2dev/ps2eth
RUN cd /ps2eth && make && mkdir -p /usr/lib/ps2dev/ps2eth && tar c $(find . -name \*irx) | tar x -C /usr/lib/ps2dev/ps2eth

RUN git clone --quiet https://github.com/ps2dev/gsKit.git
RUN cd /gsKit && make install

RUN git clone --quiet https://github.com/ps2dev/ps2-packer.git
RUN cd /ps2-packer && make install

WORKDIR /src
