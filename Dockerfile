FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ARG TZ=America/Chicago

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=$TZ

RUN apt-get update && apt-get install -y \
  git git-lfs \
  tzdata

RUN apt install -y python3 python3-pip

RUN rm -rf /var/lib/apt/lists/*
RUN git lfs install

RUN pip install --no-cache-dir --upgrade pip
RUN pip install gitpython

ARG USERNAME=comfyui
ARG USERID=1000

RUN useradd -u $USERID $USERNAME
RUN usermod -a -G $USERNAME $USERNAME
RUN mkdir -p /home/$USERNAME
RUN chown -R $USERNAME /home/$USERNAME
WORKDIR /home/$USERNAME

USER $USERNAME

ENV HOME=/home/$USERNAME \
    PATH=/home/$USERNAME/.local/bin:$PATH
ENV COMFY_UI_HOME=/home/$USERNAME/ComfyUI
    
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR $COMFY_UI_HOME
RUN pip install -r requirements.txt

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager ${COMFY_UI_HOME}/custom_nodes/ComfyUI-Manager && \
  pip install -r ${COMFY_UI_HOME}/custom_nodes/ComfyUI-Manager/requirements.txt

EXPOSE 8188
    
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--output-directory", "/$HOME/output"]
