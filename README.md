# About

Project in development.

## Project setup

On windows, I recommend to install [dos2unix](https://sourceforge.net/projects/dos2unix/) so a carriage return isn't added at the end when creating the secrets.

Init the swarm:

```bash
docker swarm init
```

Create the secrets for the adminer service:

```bash
echo '' | docker secret create adminer_auth_user -
echo '' | docker secret create adminer_auth_password_hash -
```

On Windows:

```bash
'secret' | dos2unix | docker secret create adminer_auth_password_hash -
```

Create the secrets for the Caddy service:

```bash
echo '' | docker secret create caddy_cloudflare_api_token -
```

Create the secrets for the PostgresSQL service:

```bash
echo secret | dos2unix | docker secret create postgres_user -
echo secret | dos2unix | docker secret create postgres_password -
echo secret | dos2unix | docker secret create postgres_db -
echo secret | dos2unix | docker secret create postgres_erp_db_user -
echo secret | dos2unix | docker secret create postgres_erp_db_name -
echo secret | dos2unix | docker secret create postgres_erp_db_password -
```

If you need to remove secrets:

```bash
docker secret rm postgres_user
```

Check the Makefile help with:

```bash
make help
```

Deploy the service:

```bash
make deploy-prod
```

Undeploy the service:

```bash
make undeploy
```

Fix website permissions if needed:

```bash
docker exec -it <php_container_id> bash
ls -l
chown -R www-data:www-data .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
ls -l
```

## Development

Check container logs:

```bash
docker logs -f --tail <number_of_lines> <container_id>
```

Example of image build, push and pull:

```bash
cd ./postgres
docker build -t marcgraub/risaquerol-postgres .
docker push marcgraub/risaquerol-postgres
docker pull marcgraub/risaquerol-postgres
```

Reload the Caddy server to test Caddyfile changes:

```bash
docker exec -it <caddy_container_id> sh
caddy reload -c /etc/caddy/Caddyfile
```

Convert script to Unix text file (in vscode, at the bottom right corner, you can change the end of line sequence to LF):

```bash
dos2unix ./docker/utils/docker-logs
```

## Deploying with Terraform

Modify the file 'terraform/cloud-init.yaml' and replace all the \<username\> and \<public_ssh_key\> with the corresponding values.

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Manual server setup (Debian)

Install some basic packages:

```bash
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release dos2unix jq make git -y
```

Add the docker repository for Debian:

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install docker:

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Setup the docker service:

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo usermod -aG docker <user>
```

Open some ports for the docker swarm:

```bash
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp
```

Sync files with rsync from Windows (use CMD):

```bash
rsync -avz -e "C:\ProgramData\chocolatey\lib\rsync\tools\bin\ssh.exe" * <user>@<server_ip>:<directory>
```

Configure ufw:

```bash
sudo ufw allow proto tcp from any to any port 80,443
sudo ufw status
```

### Unlimited bash history

```bash
nano ~/.bashrc
```

Set these values to -1 and save:

```bash
HISTSIZE=-1
HISTFILESIZE=-1
```

Apply the changes to the current session:

```bash
source ~/.bashrc
```

Watch out for the impact in the disk space, to clear the history:

```bash
history -c
```
