# Nome do cluster
$clusterName = "meu-cluster"

# Arquivo config Kind com portas mapeadas
$configYaml = @"
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
"@

# Salva config temporário
$configPath = "$env:TEMP\kind-config.yaml"
$configYaml | Out-File -Encoding utf8 $configPath

Write-Host "Criando cluster Kind '$clusterName' com config em $configPath..."
kind create cluster --name $clusterName --config $configPath

Write-Host "Aplicando ingress-nginx para Kind..."
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

Write-Host "Esperando ingress-nginx-controller ficar pronto (até 120 segundos)..."

kubectl wait --namespace ingress-nginx `
  --for=condition=Ready pod `
  --selector=app.kubernetes.io/component=controller `
  --timeout=90s

Write-Host "Ingress NGINX instalado e pronto!"

Write-Host "Verificando ingress-nginx..."
kubectl get pods -n ingress-nginx
