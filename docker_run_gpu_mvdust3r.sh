# Docker 이미지 설정
IMAGE="gsk1m/nvidia-cuda:12.0.0-devel-ubuntu22.04-mvdust3r"

# 이미지가 로컬에 있는지 확인
if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep "$IMAGE"; then
    echo "이미지 $IMAGE 가 로컬에 없으므로 다운로드합니다."
    if docker pull $IMAGE; then
        echo "이미지 다운로드 성공"
    else
        echo "이미지 다운로드 실패" >&2
        exit 1
    fi
else
    echo "이미지 $IMAGE 가 이미 로컬에 존재합니다."
fi

#!/bin/bash

# 사용자로부터 워크디렉토리 입력 받기
echo "작업 디렉토리를 입력하세요 (Enter를 누르면 기본 디렉토리 사용):"
read WORKDIR

# 기본 디렉토리 설정
if [ -z "$WORKDIR" ]; then
    WORKDIR="/home/gskim/Documents/practices/mvdust3r"
    echo "기본 디렉토리 사용: $WORKDIR"
fi

# 컨테이너 이름 설정
CONTAINER_NAME="gpu-practice"

# Docker 컨테이너 실행 (GPU 지원 및 이름 지정)
docker run --rm -it \
    --privileged \
    --gpus all \
    --name "$CONTAINER_NAME" \
    -v "$WORKDIR":/ws \
    -w /ws \
    --net=host \
    "$IMAGE" \
    /bin/bash -c "export PYTHONPATH=$PYTHONPATH:/ws/lib/python3.10/site-packages && python3 demo.py --weights ./checkpoints/MVDp_s2.pth"
