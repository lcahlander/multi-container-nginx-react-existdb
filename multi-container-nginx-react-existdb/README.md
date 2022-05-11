# multi-container-nginx-react-existdb

![eXist-db%20AWS.png](eXist-db%20AWS.png)

Inspired by this presentation: [My DockerCon 2020 Talk — Build & Deploy Multi-Container Application to AWS](https://medium.com/@outlier.developer/my-dockercon-2020-talk-build-deploy-multi-container-application-to-aws-af64cc5e190d)

# NGINX Plus

## Build NGINX+ image
This is required for now until docker-compose supports build secrets
```
DOCKER_BUILDKIT=1 docker build \
--no-cache \
--secret id=nginx-key,src=nginx/nginx-repo.key \
--secret id=nginx-crt,src=nginx/nginx-repo.crt \
-t nginxplus -f nginx/Dockerfile.plus ./nginx 
```

## Run compose stack

If you do not have `docker-compose`, then (on a mac) run `brew install docker-compose`.

The following needs to be done outside of the VPN.

```bash
docker-compose up -d
```

## Build and Install XAR

1. `cd backend/xar`
2. `mvn clean package`
3. Open [http://localhost:8080](http://localhost:8080)
4. Click on `login` in the upper right corner.
5. Login as `admin` with no password
6. Click on `Package Manager`
7. Click on `Upload`
8. Select the `.xar` file in *backend/xar/target*
9. Open [http://localhost/](http://localhost/)
