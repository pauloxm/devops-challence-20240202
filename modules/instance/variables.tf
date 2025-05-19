variable "region" {
  description = "Define qual a região onde a instancia sera criada"
  default     = "us-east-1"
}

variable "name" {
  description = "Nome da Instância"
  default     = "server-01"
}

variable "env" {
  description = "Ambiente da aplicação"
  default     = "dev"
}

variable "instance_type" {
  description = "Configuração de hardware da máquina"
  default     = "t2.micro"
}

variable "repo" {
  description = "Repositorio da aplicação"
  default     = "https://github.com/pauloxm/devops-challence-20240202"
}

variable "ssh_user" {
  description = "Usuario criado na Instancia ec2"
  default = "ubuntu"
}

variable "key_name" {
  description = "Nome da chave SSH criada na AWS"
  default = "chaves-aws"
}

variable "private_key" {
  description = "Nome da parte privada da chave SSH criada na AWS"
  default = "aws-key"
}

variable "public_key" {
  description = "Nome da parte publica da chave SSH criada na AWS"
  default = "aws-key.pub"
}

variable "private_key_path" {
  description = "Diretorio local onde será armazenada a chave privada"
  default = "certs"
}