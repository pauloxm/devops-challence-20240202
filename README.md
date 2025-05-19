# Infra Challenge 20240202

## Descrição do Projeto

Este é o projeto para submissão no [Coodesh](https://coodesh.com/). Este reposotório contém um projeto de IaC contendo código Terraform e Ansible, nele será construída uma instância ec2 (free tier) na AWS utilizando o Ubuntu 22.04. Espera-se que o código seja executado com sucesso e que sejam expostos os dados mínimos necessários para execução de uma pipeline usando CodePipeline da própria AWS, esta pipeline fará a leitura deste repositório e irá disparar a execução do TF e, na sequencia, o código Ansible para devida preparação da Instancia. Através do Ansible serão instalados os pacotes requeridos no projeto.

## Tecnologias Utilizadas

- Ansible
- AWS CodePipeline
- AWS EC2
- AWS S3
- Git / Github
- Terraform
- Host Ubuntu 22.04

- **Terraform**
- **Ansible**
- **AWS**:
  - EC2
  - IAM
  - S3
  - VPC


## Pré-requisitos

- Terraform instalado (versão 1.0+ recomendada)
- Conta AWS com credenciais configuradas
- AWS CLI instalada e configurada (opcional, mas recomendado)

## Como Instalar

Informo que todas as atividades listadas abaixo foram realizadas a partir de um host popOS 22.04 LTS.

### Instalação do Terraform

A instalação do Terraform ocorrerá seguindo a documentação do fabricante para instalação em distribuições Debian Like.

```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Fonte: https://developer.hashicorp.com/terraform/install

### Instalação do Ansible

A instalação do Ansible ocorrerá seguindo a documentação do fabricante para instalação em Ubuntu.

```sh
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

Fonte: https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu


### Execução Manual

Clone o repositório localmente

```sh
git clone https://github.com/pauloxm/devops-challence-20240202.git
```

Exporte a sua Access Key ID e Secret Access Key. Utilize os comandos abaixo.

```sh
export AWS_ACCESS_KEY_ID= <ID>
export AWS_SECRET_ACCESS_KEY= <SECRET>
```

```sh
terraform init
```

Gerando plano

```sh
terraform plan -out plan.out
```

Provisionando na AWS

```sh
terraform apply plan.out
```


## Como Utilizar o Projeto

O repositório possui 2 Branches criadas:

> main
> bucket

A Branch __bucket__ estão os arquivos do projeto Terraform para criação de um Remote State na AWS.

A branch __main__ estão os arquivos do projeto principal. Nele estão os arquivos do projeto Terraform e Ansible distribuidos da seguinte maneira:

- Criação de uma instância EC2
- Configuração de segurança com Security Group e Ingress Rule em IPv4.
- Configuração de rede incluindo a criação de VPC, subnet, Internet Gateway, Route Table.
- Provisionamento de um bucket S3 para utilização como remote state do Terraform.
- Geração de par de chaves SSH para acesso à instância.

```sh
.
├── module                        # Diretório com o módulo server, criado com a finalidade de deixar o projeto mais organizado
│   ├── instance/                 # Subsdiretório de criação da estrutura na AWS
│   │   ├── ec2.tf                # Arquivo com as instruções de criação da instancia
│   │   ├── network.tf            # Arquivo com as instruções de criação de rede, security group e ingress rules
│   │   ├── output.tf             # Arquivo com o output "instance_ip" que será importado e apresentado no arquivo output.tf do módulo principal
│   │   └── variables.tf          # Arqivo com a declaração das variáveis que serão utilizadas no módulo
│   │
├── roles                         # Diretório com as roles do Ansible
│   ├── Basic/                    # Diretório Basic (Role Basic)
│   │   ├── defaults              # Subdiretório defaults
│   │   |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   ├── handlers              # Subdiretório handlers
│   │   |   ├── main.yml          # Arquivo com processos dependentes, só serão acionados mediante condição satisfeita nas tarefas principais
│   │   ├── meta                  # Subdiretório meta
│   │   |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   ├── tasks                 # Subdiretório tasks
│   │   |   ├── main.yml          # Arquivo com as tarefas de instalação do pacote do python e habilitar o UFW com as regras requeridas no projeto
│   │   ├── tests                 # Subdiretório tests
│   │   |   ├── minventory        # Criado pelo ansible-galaxy, sem utilização
│   │   |   ├── test.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   └── vars                  # Subdiretório vars
│   │        └─ main.yml          # Criado pelo ansible-galaxy, sem utilização
│   │
│   ├── Nginx/                    # Diretório Nginx (Role Nginx)
│   │   ├── defaults              # Subdiretório defaults
│   │   |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   ├── handlers              # Subdiretório handlers
│   │   |   ├── main.yml          # Arquivo com processos dependentes, só serão acionados mediante condição satisfeita nas tarefas principais
│   │   ├── meta                  # Subdiretório meta
│   │   |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   ├── tasks                 # Subdiretório tasks
│   │   |   ├── main.yml          # Arquivo com as tarefas de instalação e configuração do Nginx e certificado SSL auto assinado
│   │   ├── tests                 # Subdiretório tests
│   │   |   ├── minventory        # Criado pelo ansible-galaxy, sem utilização
│   │   |   ├── test.yml          # Criado pelo ansible-galaxy, sem utilização
│   │   └── vars                  # Subdiretório vars
│   │       └── main.yml          # Arquivo com a declaração de variável com o caminho do arquivo de configuração do Nginx
│   │
│   └── Security/                 # Diretório Security (Role Security)
│       ├── defaults              # Subdiretório defaults
│       |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│       ├── handlers              # Subdiretório handlers
│       |   ├── main.yml          # Arquivo com processos dependentes, só serão acionados mediante condição satisfeita nas tarefas principais
│       ├── meta                  # Subdiretório meta
│       |   ├── main.yml          # Criado pelo ansible-galaxy, sem utilização
│       ├── tasks                 # Subdiretório tasks
│       |   ├── main.yml          # Arquivo com as tarefas de instalação do fail2ban e parametrizações de segurança do SSH Server
│       ├── tests                 # Subdiretório tests
│       |   ├── minventory        # Criado pelo ansible-galaxy, sem utilização
│       |   ├── test.yml          # Criado pelo ansible-galaxy, sem utilização
│       └── vars                  # Subdiretório vars
│           └── main.yml          # Arquivo com a declaração de variável com o caminho do arquivo de configuração do ssh
│
├── backend.tf                    # Arquivo com as instruções de conexão com o provider, requisito de versão do Terraform e a declaração das tags padrão
├── main.tf                       # Arquivo responsável por realizar a chamada do módulo 'instance'
├── outputs.tf                    # Arquivo com o output "instance_public_ip" que será o valor importado do arquivo output.tf do módulo 'instance'
├── playbook.yml                  # Arquivo principal com a chamada das Roles do Ansible: Basic, Nginx e Security
├── variables.tf                  # Arqivo com a declaração das variáveis que serão utilizadas no módulo
└── README.md                     # Arquivo com a documentação do projeto
```

>  This is a challenge by [Coodesh](https://coodesh.com/)