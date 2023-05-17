FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

RUN mkdir /root/work/

RUN sed -i '/developer\.download\.nvidia\.com\/compute\/cuda\/repos/d' /etc/apt/sources.list.d/* && \
    sed -i '/developer\.download\.nvidia\.com\/compute\/machine-learning\/repos/d' /etc/apt/sources.list.d/* && \
    apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub

RUN apt update && apt install -y less sudo
RUN apt install -y language-pack-ja && localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8 && ldconfig
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV CUDA_VISIBLE_DEVICES 0

RUN apt install -y python3 python3-pip python3-protobuf && ldconfig && \
    pip3 install -U pip && \
    pip3 install tqdm numpy pandas sklearn && \
    # ここの行
    pip3 install torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html && \
    pip3 install torch_optimizer sentencepiece transformers==4.17.0 && \
    pip3 install boto3 requests regex && \
    ldconfig

RUN apt update && apt install -y libmysqlclient-dev && pip3 install mysqlclient && \
    pip3 install optuna && pip3 install unidecode && \
    ldconfig

RUN apt-get update && apt-get -y install zsh && apt-get -y install git && apt-get -y install vim
# RUN cd ~/ && git clone https://github.com/TakumaMatsubara/my_setting && cp my_setting/.zshrc ~/
# COPY deberta-preprocess /root/work/deberta-preprocess
# RUN cd /root/work/deberta-preprocess && python3 run.py

# COPY en_core_sci_scibert-0.5.0.tar.gz /root/work/
# COPY en_core_sci_sm-0.5.0.tar.gz /root/work/
# RUN pip3 install -U spacy[cuda111]==3.2.4 && pip3 install scispacy && pip3 install /root/work/en_core_sci_scibert-0.5.0.tar.gz && pip3 install /root/work/en_core_sci_sm-0.5.0.tar.gz

RUN pip3 install -U datasets && pip3 install -U tensorboard && pip3 install -U wandb && pip3 install -U requests &&  pip3 install black && ldconfig
# RUN git clone -b 22.04-dev https://github.com/NVIDIA/apex && cd apex && pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
RUN rm -r /root/work

RUN useradd --uid 19082 -m matsubara.19082 && usermod -aG sudo matsubara.19082 && echo "matsubara.19082:passwd" | chpasswd && su matsubara.19082 && exit

USER matsubara.19082

ARG WANDB_KEY=9f5251083c7d34e3eb05a29f29babdb5d7af5435
RUN python3 -c "import wandb; wandb.login(key='${WANDB_KEY}')"

RUN cd ~/ && git clone https://github.com/TakumaMatsubara/my_setting && cp my_setting/.zshrc ~/
RUN pip install dgl-cu113 dglgo -f https://data.dgl.ai/wheels/repo.html

RUN git config --global user.email tamosongyuan3@gmail.com
RUN git config --global user.name TakumaMatsubara
RUN mkdir /home/matsubara.19082/.ssh
COPY ./id_rsa /home/matsubara.19082/.ssh/id_rsa

WORKDIR /workspace/
CMD ["/usr/bin/zsh"]
