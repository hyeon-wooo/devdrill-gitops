# #! /bin/bash

kubectl create namespace argocd

# ArgoCD 설치
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# argocd-cm ConfigMap 수정 (폴링 주기를 60초로 설정)
kubectl patch cm argocd-cm -n argocd --type merge -p '{"data": {"timeout.reconciliation": "30s"}}'
# 설정 적용을 위해 repo-server 재시작
kubectl rollout restart deployment argocd-repo-server -n argocd

# Gateway API
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/experimental-install.yaml
helm upgrade --install ngf oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric \
  --create-namespace \
  -n nginx-gateway \
  --set service.type=NodePort \
  --version 1.5.0

# Harbor Secret
kubectl create secret docker-registry harbor-auth \
  --docker-server=XXXXXXXX \
  --docker-username=XXXXXXXX \
  --docker-password=XXXXXXXX \
  --namespace=XXXXXXXX


# ESO
kubectl create secret generic doppler-token-auth \
    --namespace XXXXXXXX \
    --from-literal=dopplerToken=XXXXXXXX

helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --version 1.1.1 \
  --atomic \
  --set logLevel=warn \
  --wait --timeout=180s

# Node Label 및 Taint 설정
./setup-node/master-node.sh
./setup-node/devdrill-node.sh

# Secret 적용: ArgoCD <-> GitHub 연동, Grafana Cloud 연동
kubectl apply -f ./secret/github-repo-auth.yaml
kubectl apply -f ./secret/grafana-cloud.yaml

# Root Application 적용
kubectl apply -f ./root.yaml
