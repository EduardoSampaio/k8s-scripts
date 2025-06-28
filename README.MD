# 🐳 Guia Completo Kubernetes com Kind

> Comandos práticos e exemplos de uso para clusters locais com Kind + kubectl  

---

## 📦 Criar e Gerenciar Clusters com Kind

| Comando                                     | Descrição                                                                 |
|--------------------------------------------|---------------------------------------------------------------------------|
| `kind create cluster`                      | Cria um cluster padrão com o nome `kind`                                  |
| `kind create cluster --name NOME`          | Cria cluster com nome customizado                                         |
| `kind create cluster --config=arquivo.yaml`| Cria cluster com configuração customizada (ex: nodes, ingress, etc)       |
| `kind get clusters`                        | Lista todos os clusters criados com Kind                                  |
| `kind delete cluster`                      | Remove o cluster com nome padrão (`kind`)                                 |
| `kind delete cluster --name NOME`          | Remove cluster com nome específico                                        |
| `kind load docker-image IMG --name NOME`   | Carrega uma imagem local no cluster Kind especificado                     |

---

## 🔀 Contexto e Acesso ao Cluster

| Comando                                    | Descrição                                                 |
|-------------------------------------------|-----------------------------------------------------------|
| `kubectl cluster-info --context kind-NOME`| Mostra informações do cluster Kind                        |
| `kubectl config use-context kind-NOME`    | Define o contexto atual para o cluster Kind               |
| `kubectl config current-context`          | Mostra o contexto atual                                   |
| `kubectl config get-contexts`             | Lista todos os contextos disponíveis                      |
| `kubectl config set-context --current --namespace=NAMESPACE` | Define o namespace padrão                        |

---

## 📋 Recursos e Namespace

| Comando                            | Descrição                                        |
|-----------------------------------|--------------------------------------------------|
| `kubectl get all`                 | Lista todos os recursos no namespace atual       |
| `kubectl get pods`                | Lista os pods                                    |
| `kubectl get svc`                 | Lista os serviços                                |
| `kubectl get deployments`         | Lista os deployments                             |
| `kubectl get nodes`               | Lista os nós do cluster                          |
| `kubectl label node NOME ingress-ready=true` | Marca node como pronto para Ingress          |
| `kubectl get ns`                  | Lista todos os namespaces                        |
| `kubectl get pods -n NAMESPACE`   | Lista pods de um namespace específico            |

---

## 🔄 Rollouts e Revisões

| Comando                                       | Descrição                                              |
|----------------------------------------------|--------------------------------------------------------|
| `kubectl rollout status deployment NOME`     | Mostra o status da atualização (rolling update)        |
| `kubectl rollout history deployment NOME`    | Lista o histórico de revisões                          |
| `kubectl rollout undo deployment NOME`       | Faz rollback para a versão anterior                    |
| `kubectl rollout undo deployment NOME --to-revision=X` | Restaura para a revisão específica         |

---

## 📁 Aplicar, Criar e Deletar Recursos

| Comando                                | Descrição                                           |
|----------------------------------------|-----------------------------------------------------|
| `kubectl apply -f arquivo.yaml`        | Aplica/cria/atualiza recursos via YAML              |
| `kubectl create -f arquivo.yaml`       | Cria recursos (erro se já existir)                  |
| `kubectl delete -f arquivo.yaml`       | Remove os recursos definidos no YAML                |
| `kubectl edit deployment NOME`         | Edita diretamente um deployment (abre editor)       |
| `kubectl set image deployment NOME container=imagem:tag` | Atualiza imagem de container no deployment |

---

## 🧪 Diagnóstico e Execução

| Comando                     | Descrição                                           |
|----------------------------|-----------------------------------------------------|
| `kubectl version --short`  | Mostra a versão do cliente e do servidor Kubernetes |
| `kubectl api-resources`    | Lista os tipos de recursos disponíveis              |
| `kubectl describe pod POD` | Mostra detalhes e eventos de um pod específico      |
| `kubectl logs POD`         | Mostra os logs de um pod                            |
| `kubectl exec -it POD -- sh` | Abre terminal interativo dentro de um pod        |
| `kubectl port-forward svc/SVC 8080:80` | Redireciona porta local para serviço do cluster |

---

## ⚙️ Exemplo de Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: goserver
  labels:
    app: goserver
  annotations:
    kubernetes.io/change-cause: "Deploy inicial do goserver"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: goserver
  template:
    metadata:
      labels:
        app: goserver
    spec:
      containers:
        - name: goserver
          image: yamidudu/hello.go:v4
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: goserver-env
```

---

## 🧾 Exemplo de ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: goserver-env
data:
  NAME: GoServer
  VERSION: "v4"
```

---

## 🌐 Exemplo de Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: goserver-svc
spec:
  selector:
    app: goserver
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

---

## 🌍 Exemplo de Ingress (Traefik ou NGINX)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: goserver-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
    - host: goserver.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: goserver-svc
                port:
                  number: 80
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: minha-aplicacao-secret
type: Opaque
data:
  USUARIO: dXN1YXJpby1leGVtcGxv  # Base64 de "usuario-exemplo"
  SENHA: c2VuaGEtc2VjcmV0        # Base64 de "senha-secret"

```

```yaml
#no deployment
env:
  - name: USUARIO
    valueFrom:
      secretKeyRef:
        name: minha-aplicacao-secret
        key: USUARIO
  - name: SENHA
    valueFrom:
      secretKeyRef:
        name: minha-aplicacao-secret
        key: SENHA

```

