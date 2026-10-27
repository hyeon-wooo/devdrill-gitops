# otel-collector (비활성화)

Grafana Cloud 로 텔레메트리를 보내지 않으려고 2026-10-27 에 `cluster/app/` 밖으로 옮겼다.
infra-root 는 `cluster/app`, `cluster/storage` 만 동기화하고 prune 하므로, 여기 있는 동안
Collector(daemonset·deployment)와 ServiceAccount·RBAC 는 클러스터에 없다.

다시 켜려면:

1. 세 파일을 `cluster/app/` 으로 되돌린다.
2. `cluster/workload/devdrill-api/config.yaml` 의 `OTEL_SDK_DISABLED` 를 지운다.
