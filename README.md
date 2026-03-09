# DevDrill GitOps Repository

쿠버네티스 클러스터의 애플리케이션 배포를 위한 **GitOps** 레포지토리입니다. ArgoCD를 기반으로 클러스터의 상태를 선언적으로 관리하고 자동으로 동기화합니다.

## 📂 디렉터리 구조

```text
├── cluster/
│   ├── app/
│   └── workload/
└── init/
```

### 1. `cluster/`

ArgoCD를 통해 클러스터에 배포되는 애플리케이션 및 워크로드의 매니페스트입니다.

- **`app/`**: ArgoCD가 변경 감지 및 클러스터에 반영할 리소스들이 위치합니다.
  - Observability, Gateway, Secret Store 등 클러스터 중추 애플리케이션
  - 워크로드 배포를 위한 Application 리소스

- **`workload/`**: 클러스터에서 동작하는 개별 서비스들의 리소스가 위치합니다.

### 2. `init/`

쿠버네티스 클러스터의 최초 프로비저닝 및 GitOps(ArgoCD) 초기 연동을 구성하는 데 필요한 리소스 및 셸 스크립트가 위치하며, 클러스터 세팅 초기에 단 한번만 수동으로 실행합니다.

- `setup-node/`: 클러스터에 참여하는 Master, Worker (devdrill) 노드의 Label 및 Taint 등을 세팅하는 셸 스크립트
- `secret/`: ArgoCD <-> GitHub 연동, Grafana Cloud 연동 등 클러스터에 필요한 secret 리소스
- `root.yaml`: App of Apps 패턴 적용을 위한 최상위 애플리케이션 리소스
- `run.sh`: ArgoCD와 Gateway API 등 필요한 애플리케이션 설치부터 setup-node/, secret/, root.yaml 적용까지 일괄적으로 수행하는 셸 스크립트
