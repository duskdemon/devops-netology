# Домашнее задание к занятию "12.5 Сетевые решения CNI"
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)  

## выполнение:  

Использем кластер, созданный в ходе предыдущего ДЗ, т.к. с моей рабочей машины уже настроено взаимодействие с ним.  
создаем неймспейс  
```
dusk@DESKTOP-DQUFL9J:~/.kube$ kubectl create ns net-pol
namespace/net-pol created
```
с помощью шаблонов из "kubernetes-for-beginners/16-networking/20-network-policy/" развертываем 3 деплоймента, предварительно поменяв неймспейс на net-pol  
```
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl apply -f ./manifests/main/
deployment.apps/frontend created
service/frontend created
deployment.apps/backend created
service/backend created
deployment.apps/cache created
service/cache created

dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl get pods --namespace=net-pol
NAME                       READY   STATUS    RESTARTS   AGE
backend-869fd89bdc-tt9fc   1/1     Running   0          5m36s
cache-b7cbd9f8f-k6mnt      1/1     Running   0          5m36s
frontend-c74c5646c-5p4wq   1/1     Running   0          5m36s
```
переключимся на созданный неймспейс  
```
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl config set-context --current --namespace=net-pol
Context "kubespray" modified.
```
проверяем доступность между подами  
```
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 cache
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-k6mnt - 10.233.71.7
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 frontend
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-5p4wq - 10.233.75.6
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 backend
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-tt9fc - 10.233.97.135
```
применяем политику запрета ingress и проверяем доступность, трафик заблокирован  
```
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl apply -f manifests/network-policy/00-default.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 backend
command terminated with exit code 28
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 frontend
command terminated with exit code 28
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 cache
command terminated with exit code 28
```
Удаляем политику и снова проверяем доступность, трафик опять ходит  
```
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl delete networkpolicy default-deny-ingress
networkpolicy.networking.k8s.io "default-deny-ingress" deleted
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl get networkpolicy
No resources found in net-pol namespace.
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 cache
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-k6mnt - 10.233.71.7
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 frontend
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-5p4wq - 10.233.75.6
dusk@DESKTOP-DQUFL9J:~/20-network-policy$ kubectl exec backend-869fd89bdc-tt9fc -- curl -s -m 1 backend
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-tt9fc - 10.233.97.135
```

## Задание 2: изучить, что запущено по умолчанию
Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования: 
* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.  

## выполнение:  

Скачиваем в домашнюю директорию __calicoctl__ и получаем информацию приведенными командами (поскольку скачал более свежую версию программы, использую флаг __--allow-version-mismatch__)  
```
dusk@DESKTOP-DQUFL9J:~$ ./calicoctl get nodes -o wide --allow-version-mismatch
NAME    ASN       IPV4             IPV6   
node1   (64512)   10.129.0.3/24           
node2   (64512)   10.129.0.4/24           
node3   (64512)   10.129.0.10/24          
node4   (64512)   10.129.0.31/24          
node5   (64512)   10.129.0.26/24          

dusk@DESKTOP-DQUFL9J:~$ ./calicoctl get ipPool --allow-version-mismatch
NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()      

dusk@DESKTOP-DQUFL9J:~$ ./calicoctl get profile --allow-version-mismatch
NAME                                                 
projectcalico-default-allow                          
kns.default                                          
kns.kube-node-lease                                  
kns.kube-public                                      
kns.kube-system                                      
kns.net-pol                                          
ksa.default.default                                  
ksa.kube-node-lease.default                          
ksa.kube-public.default                              
ksa.kube-system.attachdetach-controller              
ksa.kube-system.bootstrap-signer                     
ksa.kube-system.calico-node                          
ksa.kube-system.certificate-controller               
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns                              
ksa.kube-system.cronjob-controller                   
ksa.kube-system.daemon-set-controller                
ksa.kube-system.default                              
ksa.kube-system.deployment-controller                
ksa.kube-system.disruption-controller                
ksa.kube-system.dns-autoscaler                       
ksa.kube-system.endpoint-controller                  
ksa.kube-system.endpointslice-controller             
ksa.kube-system.endpointslicemirroring-controller    
ksa.kube-system.ephemeral-volume-controller          
ksa.kube-system.expand-controller                    
ksa.kube-system.generic-garbage-collector            
ksa.kube-system.horizontal-pod-autoscaler            
ksa.kube-system.job-controller                       
ksa.kube-system.kube-proxy                           
ksa.kube-system.namespace-controller                 
ksa.kube-system.node-controller                      
ksa.kube-system.nodelocaldns                         
ksa.kube-system.persistent-volume-binder             
ksa.kube-system.pod-garbage-collector                
ksa.kube-system.pv-protection-controller             
ksa.kube-system.pvc-protection-controller            
ksa.kube-system.replicaset-controller                
ksa.kube-system.replication-controller               
ksa.kube-system.resourcequota-controller             
ksa.kube-system.root-ca-cert-publisher               
ksa.kube-system.service-account-controller           
ksa.kube-system.service-controller                   
ksa.kube-system.statefulset-controller               
ksa.kube-system.token-cleaner                        
ksa.kube-system.ttl-after-finished-controller        
ksa.kube-system.ttl-controller                       
ksa.net-pol.default
```
