# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

## Задание 1: **Выполнение:**  

```
dusk@kube-12-02-2:~$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node created
dusk@kube-12-02-2:~$ kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           42s
dusk@kube-12-02-2:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-6f7bx   1/1     Running   0          47s
hello-node-6d5f754cc9-lbrbk   1/1     Running   0          47s
```

## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

## Задание 2: **Выполнение:**  

Создаем служебный аккаунт,  
```
dusk@kube-12-02-2:~$ kubectl get sa logvwr -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-29T18:50:42Z"
  name: logvwr
  namespace: default
  resourceVersion: "789"
  uid: 0b76e99b-4337-4bbd-959e-64867a202b9c
```  
секрет  
```
apiVersion: v1
kind: Secret
metadata:
  name: logvwr
  annotations:
    kubernetes.io/service-account.name: logvwr
type: kubernetes.io/service-account-token
data:
  username: bG9ndndy
  password: WnoxMjM0NTY3IQ==
```  
 и токен  
```
dusk@kube-12-02-2:~$ kubectl describe secret logvwr
Name:         logvwr
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: logvwr
              kubernetes.io/service-account.uid: 0b76e99b-4337-4bbd-959e-64867a202b9c

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGci...
username:   6 bytes
ca.crt:     1111 bytes
namespace:  7 bytes
password:   10 bytes
```
__~/.kube/config:__
```
dusk@kube-12-02-2:~$ cat ~/.kube/config 
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/dusk/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Mon, 29 Aug 2022 18:42:07 UTC
        provider: minikube.sigs.k8s.io
        version: v1.26.1
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Mon, 29 Aug 2022 18:42:07 UTC
        provider: minikube.sigs.k8s.io
        version: v1.26.1
      name: context_info
    namespace: default
    user: minikube
  name: minikube
- context:
    cluster: ""
    user: dusk
  name: podvwr
current-context: podvwr
kind: Config
preferences: {}
users:
- name: dusk
  user:
    token: eyJhbGci...
- name: minikube
  user:
    client-certificate: /home/dusk/.minikube/profiles/minikube/client.crt
    client-key: /home/dusk/.minikube/profiles/minikube/client.key
```

## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)  

## Задание 3: **Выполнение:**  

```
dusk@kube-12-02-2:~$ kubectl scale --replicas=5 deployment hello-node
deployment.apps/hello-node scaled
dusk@kube-12-02-2:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-6f7bx   1/1     Running   0          106m
hello-node-6d5f754cc9-6n72p   1/1     Running   0          10s
hello-node-6d5f754cc9-jtz6p   1/1     Running   0          10s
hello-node-6d5f754cc9-lbrbk   1/1     Running   0          106m
hello-node-6d5f754cc9-sbc55   1/1     Running   0          10s
```
