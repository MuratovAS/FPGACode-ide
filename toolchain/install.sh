#!/bin/sh

TOOLCHAIN_PATH=$(readlink -f $1)
LOCAL_DIR=$(dirname $(readlink -f $0))

mkdir -p $TOOLCHAIN_PATH

cd $TOOLCHAIN_PATH && cat $LOCAL_DIR/toolchain.txt \
                    | sed '/^#other/q' | sed '/^#/d' \
                    | xargs $LOCAL_DIR/getFPGAwars.sh
ls *.tar.gz | while read i; \
              do \
                rm -rf ${i%%.tar.gz}; \
                mkdir ${i%%.tar.gz}; \
                tar xzf $i -C ${i%%.tar.gz}; \
                rm $i; \
              done


cd $TOOLCHAIN_PATH && cat $LOCAL_DIR/toolchain.txt \
                  | sed '/^#/d' | grep "istyle" \
                  && mkdir -p ./istyle/bin && cd ./istyle/bin \
                  && $LOCAL_DIR/getGithub.sh MuratovAS/istyle-verilog-formatter istyle \
                  && chmod 775 istyle

cd $TOOLCHAIN_PATH && cat $LOCAL_DIR/toolchain.txt \
                  | sed '/^#/d' | grep "vcd" \
                  && mkdir -p ./vcd/bin && cd ./vcd/bin \
                  && $LOCAL_DIR/getGithub.sh MuratovAS/simpleVCD vcd \
                  && chmod 775 vcd

cd $TOOLCHAIN_PATH && cat $LOCAL_DIR/toolchain.txt \
                  | sed '/^#/d' | grep "verilog-format" \
                  && mkdir -p ./verilog-format/bin && cd ./verilog-format/bin \
                  && curl -L https://github.com/ericsonj/verilog-format/raw/master/bin/verilog-format-LINUX.zip > verilog-format-LINUX.zip \
                  && unzip verilog-format-LINUX.zip \
                  && rm verilog-format-LINUX.zip verilog-format

