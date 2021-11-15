FROM alpine

#init
ARG HOME_DIR=/root/
WORKDIR $HOME_DIR/prj
ENTRYPOINT ["bash"]
RUN apk update

#lib
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
RUN apk add *.apk
RUN rm *.apk
RUN apk add --no-cache zlib libbz2 musl libstdc++
RUN ln -s `ls -1 /lib/*.so* | awk '!/ld-linux-/'` \
          /usr/glibc-compat/lib/
RUN ln -s `ls -1 /usr/lib/*.so* | awk '!/libcrypto/' | awk '!/libssl/'` \
          /usr/glibc-compat/lib/
RUN ln -s `find /usr/lib/ -type f -name "libbz2.*"` \
          /usr/glibc-compat/lib/libbz2.so.1.0
RUN apk add --no-cache usbutils

#util
RUN apk add --no-cache bash curl

#tui
RUN apk add --no-cache fzf
RUN mkdir -p /opt/micro/bin && cd /opt/micro/bin \
                            && curl https://getmic.ro | bash
ENV MICRO_CONFIG_HOME="$HOME_DIR/config/micro"
ENV MICRO_TRUECOLOR="1"
ENV EDITOR="micro"
ENV VISUAL="micro"
ENV TERM="xterm-256color"
ENV COLORTERM="truecolor"
ENV SHELL="/bin/bash"

#download&install toolchain
RUN apk add --no-cache make
ADD script/getFPGAwars.sh /opt
ADD toolchain.txt /opt
RUN cd /opt/ && cat ./toolchain.txt | sed '/^#/d' \
                                    | xargs ./getFPGAwars.sh
RUN cd /opt/ && ls *.tar.gz | while read i; do \
                                rm -rf ${i%%.tar.gz}; \
                                mkdir ${i%%.tar.gz}; \
                                tar xzf $i -C ${i%%.tar.gz}; \
                                rm $i; \
                              done
RUN rm /opt/toolchain.txt

#download&install tool
ADD script/getGithub.sh /opt
RUN mkdir -p /opt/istyle/bin && cd /opt/istyle/bin \
                             && /opt/getGithub.sh MuratovAS/istyle-verilog-formatter istyle \
                             && chmod 775 istyle

RUN mkdir -p /opt/vcd/bin && cd /opt/vcd/bin \
                             && /opt/getGithub.sh MuratovAS/simpleVCD vcd \
                             && chmod 775 vcd
ADD script/vcdRun.sh /opt

#conf
RUN echo "export PATH=`echo /opt/*/bin | sed 's/ /:/g'`:$PATH" \
          >> $HOME_DIR/.bashrc

RUN echo "if ! [ -d $MICRO_CONFIG_HOME/plug ]; then \
          echo 'Install plugins for micro'; \
          micro -plugin install fzfinder yosyslint quickfix manipulator; \
          fi " >> $HOME_DIR/.bashrc
          #detectindent