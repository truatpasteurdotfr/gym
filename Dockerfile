# A Dockerfile that sets up a full Gym install with test dependencies
ARG PYTHON_VERSION=3.9
FROM python:$PYTHON_VERSION
RUN apt-get -y update && apt-get install -y unzip libglu1-mesa-dev libgl1-mesa-dev libosmesa6-dev xvfb patchelf ffmpeg cmake swig

# Download mujoco
RUN mkdir -p /app/mujoco && \
    cd /app/mujoco  && \
    curl -O https://www.roboti.us/download/mjpro150_linux.zip && \
    unzip mjpro150_linux.zip && \
    echo DUMMY_KEY > /app/mujoco/mjkey.txt

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app/mujoco/mjpro150/bin

COPY . /usr/local/gym/
WORKDIR /usr/local/gym/

RUN pip install .[nomujoco,accept-rom-license] && pip install -r test_requirements.txt

ENTRYPOINT ["/usr/local/gym/bin/docker_entrypoint"]
