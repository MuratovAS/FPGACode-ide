#!/bin/sh

TOOLCHAIN_PATH=$(readlink -f $1)
LOCAL_DIR=$(dirname $(readlink -f $0))

mkdir -p $TOOLCHAIN_PATH

cd $TOOLCHAIN_PATH && cat $LOCAL_DIR/toolchain.txt \
                    | sed '/^#/d' \
                    | xargs $LOCAL_DIR/getFPGAwars.sh
ls *.tar.gz | while read i; \
              do \
                rm -rf ${i%%.tar.gz}; \
                mkdir ${i%%.tar.gz}; \
                tar xzf $i -C ${i%%.tar.gz}; \
                rm $i; \
              done

cd $TOOLCHAIN_PATH \
                  && mkdir -p ./istyle/bin && cd ./istyle/bin \
                  && $LOCAL_DIR/getGithub.sh MuratovAS/istyle-verilog-formatter istyle \
                  && chmod 775 istyle

#cd $TOOLCHAIN_PATH \
#                  && mkdir -p ./vcd/bin && cd ./vcd/bin \
#                  && $LOCAL_DIR/getGithub.sh MuratovAS/simpleVCD vcd \
#                  && chmod 775 vcd


