# multi-container-nginx-react-existdb

![eXist-db%20AWS.png](eXist-db%20AWS.png)

Inspired by this presentation: [My DockerCon 2020 Talk — Build & Deploy Multi-Container Application to AWS](https://medium.com/@outlier.developer/my-dockercon-2020-talk-build-deploy-multi-container-application-to-aws-af64cc5e190d)

# NGINX Plus

## Licensing
Obtain nginx-repo.crt and nginx-repo.key from MyF5 or get a trial here: https://www.nginx.com/free-trial-request/

Place them in the `nginx` subfolder of this repository

```bash
├── backend
├── client
├── db
├── docker-compose.yml
├── env
├── eXist-db AWS.graffle
├── eXist-db AWS.png
├── .git
├── .gitignore
├── LICENSE
├── nginx
│   ├── configs
│   ├── Dockerfile
│   ├── Dockerfile.plus
│   ├── nginx-repo.crt # NGINX Plus License Certificate
│   └── nginx-repo.key # NGINX Plus License Key
└── README.md
```

## Build and configure OpenID Connect module for Auth0

First, get the module:

```bash
cd nginx
git clone https://github.com/nginxinc/nginx-openid-connect
cd nginx-openid-connect 
```

Then run the configure script to set OAuth parameters for `openid_connect_configuration.conf`
```bash
./configure.sh --auth_jwt_key request \
  --client_id <Auth0_Client_ID> \
  --pkce_enable \
  https://<Auth0_Domain>/.well-known/openid-configuration
cp openid_connect_configuration.conf ../configs
cd ../..
```

## Build NGINX+ image
This is required for now until docker-compose supports build secrets (just recently added in [this PR](https://github.com/docker/compose/pull/9386))
```
DOCKER_BUILDKIT=1 docker build \
--no-cache \
--secret id=nginx-key,src=nginx/nginx-repo.key \
--secret id=nginx-crt,src=nginx/nginx-repo.crt \
-t nginxplus -f nginx/Dockerfile.plus ./nginx 
```

## Configuring Auth0 Settings
In your application settings add a new "Allowed Callback URLs" that is equal to https://server-fqdn/_codexch. (I used http://localhost:80/_codexch in my dev install)

Then, change "Token Endpoint Authentication Method" to "None" in Auth0 for your Application. This is required for PKCE authorisation code flow.

## Run compose stack
```bash
docker-compose up -d
```

## Build and Install XAR

1. `cd backend/xar`
2. `mvn clean package`
3. Open [http://localhost/exist](http://localhost/exist)
4. Click on `login` in the upper right corner.
5. Login as `admin` with no password
6. Click on `Package Manager`
7. Click on `Upload`
8. Select the `.xar` file in *backend/xar/target*
9. Open [http://localhost/](http://localhost/)
