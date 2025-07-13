#!/bin/bash

# Nome do cluster
clusterName="meu-cluster"

# Caminho do arquivo temporário
configPath="/tmp/kind-config.yaml"

# Gera arquivo de configuração do cluster Kind
cat <<EOF > "$configPath"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 80
        hostPort: 8080
        protocol: TCP
      - containerPort: 443
        hostPort: 8443
        protocol: TCP
  - role: worker
  - role: worker
EOF

echo "🛠️  Criando cluster Kind '$clusterName' com config em $configPath..."
kind create cluster --name "$clusterName" --config "$configPath"

echo "🌐 Aplicando ingress-nginx para Kind..."
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

echo "⏳ Esperando ingress-nginx-controller ficar pronto (até 90s)..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "✅ Ingress NGINX instalado e pronto!"

echo "🔍 Verificando ingress-nginx..."
kubectl get pods -n ingress-nginx
