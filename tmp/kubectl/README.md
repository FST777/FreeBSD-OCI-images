Kubectl is the Kubernetes command line interface. It allows to manage
Kubernetes cluster by providing a wide set of commands that allows to
communicate with the Kubernetes API in a friendly way.

# Image location
- View the available tags [here](https://github.com/FST777/FreeBSD-OCI-images/pkgs/container/kubectl)
- Pull using `ghcr.io/fst777/kubectl:latest`

# Image specific notes
Quick usage examples:
```
podman pull ghcr.io/fst777/kubectl
podman run --rm kubectl
podman run --rm kubectl version
podman run --name kubectl -v /local/kube/config:/.kube/config kubectl config view
```
