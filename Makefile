help:
	@cat Makefile

DATA?="${HOME}/Data"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
#HOST_SRC?=$(shell dirname `pwd`)
HOST_SRC=$(HOME)/portfolio/semantic-segm
DOCKER_SRC=/workspace

build:
	docker build -t keras --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run -it -v $(HOST_SRC):$(DOCKER_SRC) -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras bash

ipython: build
	$(DOCKER) run -it -v $(HOST_SRC):$(DOCKER_SRC) -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras ipython

notebook: build
	$(DOCKER) run -it -v $(HOST_SRC):$(DOCKER_SRC) -v $(DATA):/data --net=host --env KERAS_BACKEND=$(BACKEND) keras

test: build
	$(DOCKER) run -it -v $(HOST_SRC):$(DOCKER_SRC) -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras py.test $(TEST)
