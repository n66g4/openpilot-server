FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
RUN sed -i 's@http://archive.ubuntu.com/ubuntu/@http://mirrors.aliyun.com/ubuntu/@g' /etc/apt/sources.list 

RUN apt-get update -q \
    && apt-get install -y git ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/openpilot
WORKDIR /root/openpilot

RUN git clone -b main --depth=1 https://github.com/n66g4/openpilot-server.git
WORKDIR /root/openpilot/openpilot-server

# replace config with your domain
RUN sed -i 's@lirou.fun@lirou.fun@g' /root/openpilot/openpilot-server/config.txt 

RUN sed -i 's@/usr/bin/ffmpeg@/usr/bin/ffmpeg@g' /root/openpilot/openpilot-server/config.txt

# 复制可执行文件
COPY opserver_linux_amd64 /root/openpilot/openpilot-server/
RUN chmod +x /root/openpilot/openpilot-server/opserver_linux_amd64

RUN mkdir op

ENTRYPOINT ["/root/openpilot/openpilot-server/opserver_linux_amd64"]
