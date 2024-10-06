# k3d 

k3d is a wrapper CLI that helps you to easily create **k3s clusters** inside docker. **Nodes** of a k3d cluster are docker containers running a k3s image. All Nodes of a k3d cluster are part of the same docker network.

## Creating a k3s cluster with containerised nodes

```
❯ k3d cluster create my-cluster --agents 2

INFO[0000] Prep: Network                                
INFO[0000] Created network 'k3d-my-cluster'             
INFO[0000] Created image volume k3d-my-cluster-images   
INFO[0000] Starting new tools node...                   
INFO[0000] Pulling image 'ghcr.io/k3d-io/k3d-tools:5.7.4' 
INFO[0001] Creating node 'k3d-my-cluster-server-0'      
INFO[0003] Pulling image 'docker.io/rancher/k3s:v1.30.4-k3s1' 
INFO[0006] Starting node 'k3d-my-cluster-tools'         
INFO[0055] Creating node 'k3d-my-cluster-agent-0'       
INFO[0055] Creating node 'k3d-my-cluster-agent-1'       
INFO[0055] Creating LoadBalancer 'k3d-my-cluster-serverlb' 
INFO[0056] Pulling image 'ghcr.io/k3d-io/k3d-proxy:5.7.4' 
INFO[0067] Using the k3d-tools node to gather environment information 
INFO[0067] Starting new tools node...                   
INFO[0067] Starting node 'k3d-my-cluster-tools'         
INFO[0068] Starting cluster 'my-cluster'                
INFO[0068] Starting servers...                          
INFO[0068] Starting node 'k3d-my-cluster-server-0'      
INFO[0071] Starting agents...                           
INFO[0071] Starting node 'k3d-my-cluster-agent-1'       
INFO[0071] Starting node 'k3d-my-cluster-agent-0'       
INFO[0074] Starting helpers...                          
INFO[0074] Starting node 'k3d-my-cluster-serverlb'      
INFO[0081] Injecting records for hostAliases (incl. host.k3d.internal) and for 5 network members into CoreDNS configmap... 
INFO[0083] Cluster 'my-cluster' created successfully!   
INFO[0083] You can now use it like this:                
kubectl cluster-info
```

Every cluster will consist of one more containers:
- 1 (or more) server node container (k3s)
- (optionally) 1 loadbalancer container as an entrypoint to the cluster (nginx)
- (optionally) 1 (or more) agent node containers (k3s)

Usage:
k3d cluster create NAME [flags]

Flags:
-a, --agents int

```
❯ docker ps

CONTAINER ID   IMAGE                                 COMMAND                  CREATED              STATUS              PORTS                                                                                                                                  NAMES
afe9841318ae   ghcr.io/k3d-io/k3d-tools:5.7.4        "/app/k3d-tools noop"    About a minute ago   Up About a minute                                                                                                                                          k3d-my-cluster-tools
a9d8ceb9eaee   ghcr.io/k3d-io/k3d-proxy:5.7.4        "/bin/sh -c nginx-pr…"   About a minute ago   Up About a minute   80/tcp, 0.0.0.0:50158->6443/tcp                                                                                                        k3d-my-cluster-serverlb
4cefb24e40d0   rancher/k3s:v1.30.4-k3s1              "/bin/k3d-entrypoint…"   About a minute ago   Up About a minute                                                                                                                                          k3d-my-cluster-agent-1
a69764961b5d   rancher/k3s:v1.30.4-k3s1              "/bin/k3d-entrypoint…"   About a minute ago   Up About a minute                                                                                                                                          k3d-my-cluster-agent-0
5c982b487c48   rancher/k3s:v1.30.4-k3s1              "/bin/k3d-entrypoint…"   About a minute ago   Up About a minute                                                                                                                                          k3d-my-cluster-server-0
```

![alt text](<Screenshot 2024-10-03 at 18.00.10.png>)

- port 6443 is opened to k3d-k3s-default-serverlb, a useful load-balancer proxy
  - redirects connection to 6443 into the server node
  - port (above 50122) on machine is randomly chosen
- Opting out of the load balancer: ```k3d cluster create -a 2 --no-lb```
  - port would be open straight to the server node



## Kubeconfig

K3d sets up a kubeconfig file, which can be viewed with the command `k3d kubeconfig get my-cluster`. This contains information about:
- clusters
- users
- namespaces
- authentication mechanisms

```bash
❯ k3d kubeconfig get my-cluster 
---
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzTWpjNU56QTNPRFl3SGhjTk1qUXhNREF6TVRVMU16QTJXaGNOTXpReE1EQXhNVFUxTXpBMgpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzTWpjNU56QTNPRFl3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFRa1RqOEdPQm1rbEg0L1F6UkdyNVg4VlRXdmJPbmZ1Mkx5TUk0Vy83K1YKRzRVWUtSMjB3d0hSWWxXTjhKM1NPNURmMnh4ZVRwTGpibzFsejk2cU10MmtvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVUtQNmJwUGZHKzZlUnRJNU1yOWt6ClNUNERGY1l3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUlnY1AvaFNRYkRuQzFhU0UraWl6OHYrVkd2a3BMV0VIazkKNWZsd0k3aWc0dlFDSVFDd0RGQk8xNElvSDFBWHFPRFE4d0hrd0w0WHpEalQ1RG1obU5aSGdTcGhUZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://0.0.0.0:50158
  name: k3d-my-cluster
contexts:
- context:
    cluster: k3d-my-cluster
    user: admin@k3d-my-cluster
  name: k3d-my-cluster
current-context: k3d-my-cluster
kind: Config
preferences: {}
users:
- name: admin@k3d-my-cluster
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrRENDQVRlZ0F3SUJBZ0lJZDFEVjFoNzU4UDB3Q2dZSUtvWkl6ajBFQXdJd0l6RWhNQjhHQTFVRUF3d1kKYXpOekxXTnNhV1Z1ZEMxallVQXhOekkzT1Rjd056ZzJNQjRYRFRJME1UQXdNekUxTlRNd05sb1hEVEkxTVRBdwpNekUxTlRNd05sb3dNREVYTUJVR0ExVUVDaE1PYzNsemRHVnRPbTFoYzNSbGNuTXhGVEFUQmdOVkJBTVRESE41CmMzUmxiVHBoWkcxcGJqQlpNQk1HQnlxR1NNNDlBZ0VHQ0NxR1NNNDlBd0VIQTBJQUJJdnJ1ZzBCTkVOQzdCTU0KNFFhL0FoaE1nNlplbUIyWWlsa1JnanNFR3ZONENLRlhpRlQwcWVIYVNTNEpwK1ZkcCtXczR5MEYvZ21FZ1FFUgpDeTVXYm1HalNEQkdNQTRHQTFVZER3RUIvd1FFQXdJRm9EQVRCZ05WSFNVRUREQUtCZ2dyQmdFRkJRY0RBakFmCkJnTlZIU01FR0RBV2dCUjdldVNqcU9NNUYwUm9sUWFTQXFTVFVJTHF5REFLQmdncWhrak9QUVFEQWdOSEFEQkUKQWlBcHVrc2ltSG1YdDZKeWQzY2ZvRHorNGdqYlExbVFFZ25lL3BXSm42MXB6UUlnVXNxUGRXd1RFTzF4LzFRNApPSi9CRUJRNjZBV0FIcjIvWURzT3JRc0hqb009Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0KLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdFkyeHAKWlc1MExXTmhRREUzTWpjNU56QTNPRFl3SGhjTk1qUXhNREF6TVRVMU16QTJXaGNOTXpReE1EQXhNVFUxTXpBMgpXakFqTVNFd0h3WURWUVFEREJock0zTXRZMnhwWlc1MExXTmhRREUzTWpjNU56QTNPRFl3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFRYlZqMTdvZlBSdjRJRVlodnk3RmdmbXJQVHlMRnZQRzdCN0QrUzdyMGoKWEhtRHBpeXFJSEowK2dkOFFLeThQb3h2OFh2VmpINVZkYVBOZ3JDTVY0dU1vMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVWUzcmtvNmpqT1JkRWFKVUdrZ0trCmsxQ0M2c2d3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUlnTUdIaW9rRUdOSEg3ZTZJQVIzUGhRNVU2dzlub1llQWMKRDFsVHFjNUo1OXNDSVFDWXd6am9qa2RTaVlyYzN1WDhHQ1M3TmZWRnRiYS9HWnRKbnBEems0WUgzQT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSU1kcmd3VHpWNnVuZFVQVFNNMkJ1d0xPb2xRRkpYdW82NGwzUkw2cCs5bTBvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFaSt1NkRRRTBRMExzRXd6aEJyOENHRXlEcGw2WUhaaUtXUkdDT3dRYTgzZ0lvVmVJVlBTcAo0ZHBKTGdtbjVWMm41YXpqTFFYK0NZU0JBUkVMTGxadVlRPT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo=
```

# kubectl

kubectl controls the Kubernetes cluster manager.

 Find more information at: <https://kubernetes.io/docs/reference/kubectl/>


