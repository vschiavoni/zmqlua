FROM ubuntu:14.04
MAINTAINER aurelien.havet@unine.ch

WORKDIR /root

RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:george-edison55/cmake-3.x && \
  apt-get update && \
  apt-get install -y git gcc g++ make cmake lua5.1 liblua5.1-0-dev && \
  git clone --recursive https://github.com/Lorel/luazmq.git && \
  cd luazmq && \
  mkdir cmake-make && \
  cd cmake-make && \
  cmake ..
  
RUN cd luazmq/cmake-make && \
  make && \
  make install/local
RUN apt-get install -y wget
RUN mkdir -p /usr/local/lib/lua/5.1/ &&  \
  mkdir -p /usr/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/zmq.lua /usr/local/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/luazmq.so /usr/lib/lua/5.1/ && \
  cp /root/luazmq/cmake-make/x86_64/lib/libzmq.so.4.2.0 /usr/lib/lua/5.1/ && \
  wget -O /usr/local/lib/lua/5.1/rx.lua -x https://raw.githubusercontent.com/bjornbytes/RxLua/master/rx.lua
RUN apt-get install -y chrpath
WORKDIR /usr/lib/lua/5.1/
RUN chrpath luazmq.so -r /usr/lib/lua/5.1/ 
RUN rm -rf /root/luazmq/
COPY stream_web_server.lua /root/tmp/
RUN mkdir /root/tmp/utils/
COPY utils/pstring.lua /root/tmp/utils/ 
WORKDIR /root/tmp
EXPOSE 80
ENTRYPOINT ["lua","stream_web_server.lua"]  