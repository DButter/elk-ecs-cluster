# elk-ecs-cluster
testing elk cluster with fargate ecs

## setup

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
curl https://github.com/gruntwork-io/terragrunt/releases/download/v0.34.0/terragrunt_linux_amd64 -L --output terragrunt_linux_amd64
sudo mv terragrunt /usr/local/bin/terragrunt
sudo chown root:root /usr/local/bin/terragrunt
sudo chmod 777 /usr/local/bin/terragrunt

### aws config in ~/.aws/config
'''
[default]
output = json
region = eu-central-1
credential_source = Ec2InstanceMetadata

[profile terraform]
role_arn = arn:aws:iam::047951224472:role/allowAdmin
credential_source = Ec2InstanceMetadata
region = region
'''

## execute terragrunt

AWS_PROFILE=terraform terragrunt init
AWS_PROFILE=terraform terragrunt plan
AWS_PROFILE=terraform terragrunt apply
AWS_PROFILE=terraform terragrunt destroy

## Nice picture :)
[picture](elasticCluster.png)
