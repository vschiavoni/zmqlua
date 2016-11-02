FROM ubuntu:14.04
MAINTAINER aurelien.havet@unine.ch
WORKDIR /root
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:george-edison55/cmake-3.x && \
  apt-get update && \
  apt-get install -y git gcc g++ make cmake lua5.1 liblua5.1-0-dev wget chrpath && \
  git clone --recursive https://github.com/Lorel/luazmq.git && \
  cd luazmq && \
  mkdir cmake-make && \
  cd cmake-make && \
  cmake .. &&\
  make && \
  make install/local &&\
  mkdir -p /usr/local/lib/lua/5.1/ &&  \
  mkdir -p /usr/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/zmq.lua /usr/local/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/luazmq.so /usr/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/libzmq.so.4.2.0 /usr/lib/lua/5.1/ && \
  cd /usr/lib/lua/5.1/ && chrpath luazmq.so -r /usr/lib/lua/5.1/ && \
  rm -rf /root/luazmq/ && \
  wget -O /usr/local/lib/lua/5.1/rx.lua -x https://raw.githubusercontent.com/bjornbytes/RxLua/master/rx.lua && \
  mkdir -p /root/tmp/utils/ && \
  apt-get -y remove git gcc g++ make cmake liblua5.1-0-dev wget chrpath && apt-get -y autoremove

COPY stream_web_server.lua /root/tmp/
COPY utils/pstring.lua /root/tmp/utils/ 
WORKDIR /root/tmp
EXPOSE 80
ENTRYPOINT ["lua","stream_web_server.lua"]  