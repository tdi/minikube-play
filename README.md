# Minikube playground 

This is a playground to play with kubernetes (k8s) in its one-node local cluster modem with a help from minikube. Minikube will run a virtualized, ready to play k8s cluster. 

# Install 

Install the minikube:

```bash 
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.13.1/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

```
Install kubectl:

```bash
curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

Start minikube by executing: `minikube start`. Some very helpful minikube commands are:

- `status` - check the status of the minikube,
- `ip` - check IP address of the minikube cluster,
- `logs` - show logs,
- `service` - show URL for a service running in the k8s cluster; we will use this command later.

#Play 

We can manage the k8s cluster with kubectl command. Let's see nodes of our cluster.

```bash
➜  kuberctl get nodes
NAME       STATUS    AGE
minikube   Ready     76d
```

A very detailed information for a given node can be achived via `kubectl describe node minikube`. You can also start a fancy Web dashboard ! `kubectl dashboard` will automatically open in your default Web browser, to get only the URL, add `--url`.

Let's run a deployment using Docker image `darek/goweb:1.0` and exposes port 8080. 

```bash
➜ kubectl run goweb --image=darek/goweb:1.0 --port=8080
```
Let's see pods and deployments:

```bash
➜ kubectl get pods
NAME                    READY     STATUS    RESTARTS   AGE
goweb-907329357-dnycx   1/1       Running   0          2m

➜ kubectl get deployments
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
goweb     1         1         1            1           3m
```

Remember that in order to get a detailed insight into pods and deployments with a `describe command`. You can also see logs from a pod with a `kubectl logs PODNAME` command.

Let's define a service, which will group our pods, expose a port and provide discoverability. Type `NodePort` says that the port will be exposed.

```bash
➜ kubectl expose deployment goweb --type=NodePort
➜ kubectl get services
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
goweb        10.0.0.191   <nodes>       8080/TCP   9s
kubernetes   10.0.0.1     <none>        443/TCP    76d
```

In order to access the service to its exposed port, you can use minikube's helped command: ` minikube service goweb`. It will open your browser right to the address:port of the service. If you have a httpie tool installed, you use this oneliner:

```bash
http $(minikube service  goweb --url)
HTTP/1.1 200 OK
Content-Length: 130
Content-Type: text/plain; charset=utf-8
Date: Sun, 11 Dec 2016 17:35:09 GMT

hi from d75e0a562f0f ! version 1.0
Accept-Encoding:[gzip, deflate]
Accept:[*/*]
User-Agent:[HTTPie/0.9.2]
Connection:[keep-alive]
```

Let's now scale the service to 4 pods:

```bash
➜ kubectl scale --replicas=4 deployment/goweb
```
Now, when you check the deployment, you should see 4 pods running:

```
➜ kubectl get deployment
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
goweb     4         4         4            4           33m
```

Let's check if service is keeping our pods safe, let's kill one:

```
➜ kubectl get pods
NAME                    READY     STATUS    RESTARTS   AGE
goweb-988856142-0dc3a   1/1       Running   0          2m
goweb-988856142-dxqvb   1/1       Running   0          1m
goweb-988856142-jbdyl   1/1       Running   0          1m
goweb-988856142-xhm5y   1/1       Running   0          6m
➜ kubectl delete pod goweb-988856142-xhm5y
pod "goweb-988856142-xhm5y" deleted
➜ kubectl get pods
NAME                    READY     STATUS              RESTARTS   AGE
goweb-988856142-0dc3a   1/1       Running             0          3m
goweb-988856142-dxqvb   1/1       Running             0          2m
goweb-988856142-xhm5y   1/1       Running             0          7m
goweb-988856142-z1p7b   0/1       ContainerCreating   0          1s
``` 

The above listing shows that immediately k8s healed our service, taking it back to intended 4 pods running. Let's now do an update:

```
➜ kubectl set image deployment/goweb goweb=darek/goweb:2.0
```

Go to the Web brower and check if a container is anouncing a 2.0 version:

```bash
http $(minikube service  goweb --url)
HTTP/1.1 200 OK
Content-Length: 130
Content-Type: text/plain; charset=utf-8
Date: Sun, 11 Dec 2016 17:35:09 GMT

hi from e95e0d562e0a ! version 2.0
Accept-Encoding:[gzip, deflate]
Accept:[*/*]
User-Agent:[HTTPie/0.9.2]
Connection:[keep-alive]
```
You can also verify if a pod is indeed updated to 2.0 by executing `kubectl describe pod PODID` or accessing the logs, where you should see version 2.0: `2016/12/11 17:51:38 Starting goweb 2.0`. 


We can now delete the cluster and stop the minikube.

```bash
➜ kubectl delete service,deployment goweb
service "goweb" deleted
deployment "goweb" deleted
➜ minikube stop
```

# Author 
Dariusz Dwornikowski @tdi


