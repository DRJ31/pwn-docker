FROM ubuntu:focal

WORKDIR /root

ADD ./pwn2.yml .

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -e 's|archive.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' \
        -e 's|security.ubuntu.com|mirrors.tuna.tsinghua.edu.cn|g' \
        -i /etc/apt/sources.list

RUN apt update && apt upgrade -y \
    && apt install -y git gdb wget ca-certificates build-essential libglib2.0-dev libc6-dbg tmux \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && $HOME/miniconda3/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && $HOME/miniconda3/bin/pip install pwntools

RUN $HOME/miniconda3/bin/conda env create -f pwn2.yml \
    && $HOME/miniconda3/bin/conda init bash

SHELL [ "/root/miniconda3/bin/conda", "run", "-n", "pwn2", "/bin/bash", "-c" ]

RUN pip install pwntools

RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh && cd .. \
    && git clone https://github.com/scwuaptx/Pwngdb \
    && cat Pwngdb/.gdbinit | tail -n +2 >> /root/.gdbinit

RUN apt remove --purge git wget build-essential -y && apt autoremove -y

CMD [ "/bin/bash" ]
