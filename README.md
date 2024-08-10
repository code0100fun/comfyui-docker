# ComfyUI Docker

## Build image

```
sudo docker  build --build-arg USERID=$(id -u) --build-arg USERNAME=comfyui -t comfyui .
```

## Run container

```
sudo docker run -it --rm -p 7860:7860 -v /mnt/ai/comfyui/output:/data -v /mnt/ai/models:/mnt/ai/models --gpus all --name comfyui comfyui
```

## Run with docker-compose

```
sudo docker-compose up
```

