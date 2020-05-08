# Introdução
Este repositório tem 2 objetivos **independentes**. São eles:
1. Provisionar instância na cloud:

  - [x] Crie uma instância n1-standard-1 (GCP) ou t2.micro (AWS) Linux utilizando Terraform.
  - [x] A instância deve ter aberta somente às portas 80 e 443 para todos os endereços
  - [x] A porta SSH (22) deve estar acessível somente para um range IP definido.
  - [x] Inputs: A execução do projeto deve aceitar dois parâmetros:
    - [x] O IP ou range necessário para a liberação da porta SSH
    - [x] A região da cloud em que será provisionada a instância
  - [x] Outputs: A execução deve imprimir o IP público da instância
  - [x] Pré-instalar o docker na instância que suba automáticamente a imagem do Apache, tornando a página padrão da ferramenta visualizável ao acessar o IP público da instância


2. Realizar deploy da aplicação no subdiretório "kubernetes/app" utilizando Kubernetes em um ambiente local:

  - [x]  Construir a imagem docker da aplicação
  - [x]  Criar os manifestos de recursos kubernetes para rodar a aplicação (_deployments, services, ingresses, configmap_ e qualquer outro que você considere necessário)
  - [x]  Criar um _script_ para a execução do _deploy_ em uma única execução.
  - [x]  A aplicação deve ter seu _deploy_ realizado com uma única linha de comando em um cluster kubernetes **local**
  - [x]  Todos os _pods_ devem estar rodando
  - [ ]  A aplicação deve responder à uma URL específica configurada no _ingress_
  - [ ]  Utilizar Helm [HELM](https://helm.sh)
  - [x]  Divisão de recursos por _namespaces_
  - [ ]  Utilização de _health check_ na aplicação
  - [x]  Fazer com que a aplicação exiba seu nome ao invés de **"Olá, candidato!"**

Neste repositório há 2 subdiretórios: **kubernetes** e **terraform**. Os tópicos a seguir explicam como estes diretórios estão configurados e quais as alterações necessárias para execução.

# Provisionando instância na GCP com Terraform
No subdiretório do terraform os _scripts_ necessitam de credenciais da GCP para realizar a autenticação da conta antes de realizar o provisionamento das máquinas, portanto é necessário o _download_ das credenciais em ".json". Também é necessário que já exista uma conta de serviço e que o google-cloud-sdk esteja instalado.

Veja a documentação antes de prosseguir:
- [Instalação do google-cloud-sdk](https://cloud.google.com/sdk/docs/downloads-apt-get)
- [Configuração da conta de serviço e credenciais](https://cloud.google.com/docs/authentication/getting-started)

É recomendado que se crie um subdiretório chamado "**credencials**" para armazenar o arquivo de credenciais ".json". Este subdiretório já está no .gitignore, portanto se houver qualquer alteração neste repositório, não será realizado o _commit_ deste subdiretório acidentalmente. Também é recomendado que o arquivo de credenciais tenha o nome "account.json", pois isso diminui a quantidade de alterações necessárias no arquivo "variables.tf".

Siga os comandos:
```bash
$ cp /<caminho para seu arquivo>/account.json /<caminho para este repositório>/desafios-devops/credencials/
```

Antes de realizar o provisionamento é preciso que seja informado o **nome do projeto** e o **nome do usuário**.

- Para alterar o **nome do projeto** abra o arquivo _terraform/variables.tf_ e procure o trecho de código com a variável _gcp_project_ e altere o valor _default_ para o valor desejado.

  ```ruby
  variable "gcp_project" {
    description = "Google Cloud Platform project"
    default     = "my_project"
  }
  ```

- Para alterar o **nome do usuário** abra o arquivo _terraform/variables.tf_ e procure o trecho de código com a variável _gcp_username_ e altere o valor _default_ para o valor desejado.

 ```ruby
 variable "gcp_username" {
   description = "Google Cloud Platform SSH username"
   default = "my_username"
 }
 ```

 Entre no subdiretório do terraform, pois após a execução do comando serão criados arquivos "tfstate" e o subdiretório ".terraform", então aplique as alterações.

 ```bash
 $ cd terraform
 $ terraform apply
 ```

 Ao executar o comando ```terraform apply``` serão requisitados 2 **_inputs_**:
 1. O IP ou range necessário para a liberação da porta SSH
 2. A região da cloud em que será provisionada a instância

 Após informar os **_inputs_** confirme com _yes_ e a instância será criada.
 ```bash
 $ terraform apply

 var.client_ip
   IP address of the client machine

   Enter a value: <IP ou Range de IP desejado>

 var.gcp_region
   Google Cloud Platform selected region

   Enter a value: <Região desejada>

 (...Output omitido...)

 Do you want to perform these actions?
   Terraform will perform the actions described above.
   Only 'yes' will be accepted to approve.

   Enter a value: yes
 ```

 A execução do comando trará como **_output_** o IP público da instância:
 ```bash
 public_ip=<IP externo da instância>
 ```

## Sobre metadados do projeto
No arquivo _terraform/main.tf_ o campo _metadata_ está comentado, pois se estiver descomentado, toda vez que o comando ```terraform apply``` for executado uma nova chave ssh será incluída nos metadados, mesmo se o usuário já existir.
```ruby
metadata = {
  ssh-keys = "${var.gcp_username}:${file(var.gcp_public_key_path)}"
}
```

# Deploy da aplicação com Kubernetes
Neste repositório, o Kubernetes irá ser executado dentro de máquinas virtuais no **Virtual Box** provisionadas pelo **Vagrant**, portanto é necessário a intalação destes programas.
Há a possibilidade de utilizar outros virtualizadores, mas isso pode levar na alteração do Vagrantfile.

- [Instalação do Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Instalação do Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)

Após a instalação dessas ferramentas, entre no subdiretório kubernetes, crie um diretório chamado "ssh_keys" e crie as chaves de ssh que serão utilizadas pelas máquinas provisionadas pelo Vagrant.
```bash
$ cd kubernetes
$ mkdir ssh_keys
```

Execute o comando para criar as máquinas:
```bash
$ vagrant up
```

O **Docker** e o **Kubernetes** serão instalados automaticamente nas instâncias junto com a construção da imagem da aplicação e _deploy_ com o Kubernetes com também serão realizados durante o provisionamento.

Após a criação das máquinas virtuais, basta acessá-las com o ssh do **Vagrant**. As máquinas foram nomeadas como:
- master: máquina master do _cluster_
- minion1: máquina _slave_ do _cluster_

Para acessá-las:
```bash
$ vagrant ssh master
$ vagrant ssh minion1
```

Na máquina _master_ confira se os _nodes_ e os _pods_ estão funcionando corretamente:
```bash
$ kubectl get nodes
$ kubectl get pods --namespace myapp
```
