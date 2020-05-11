# Desafios IDwall

Neste repositório, há 2 subdiretórios: **kubernetes** e **terraform**. Em cada subdiretório foi executada uma tarefa com objetivos diferentes, há um README.md em cada um explicando como as tarefas foram executadas e quais são as alterações necessárias para reprodução do ambiente. Respectivamente, para o subdiretório **terraform** e **kubernetes** os objetivos são:

1. [Provisionar instância na cloud](https://github.com/phsmoura/desafios-devops/tree/master/terraform):

  - [x] Crie uma instância n1-standard-1 (GCP) ou t2.micro (AWS) Linux utilizando Terraform.
  - [x] A instância deve ter aberta somente às portas 80 e 443 para todos os endereços
  - [x] A porta SSH (22) deve estar acessível somente para um range IP definido.
  - [x] Inputs: A execução do projeto deve aceitar dois parâmetros:
    - [x] O IP ou range necessário para a liberação da porta SSH
    - [x] A região da cloud em que será provisionada a instância
  - [x] Outputs: A execução deve imprimir o IP público da instância

  Extras:
  - [x] Pré-instalar o docker na instância que suba automáticamente a imagem do Apache, tornando a página padrão da ferramenta visualizável ao acessar o IP público da instância
  - [ ] Utilização de módulos do Terraform


2. [Realizar deploy utilizando Kubernetes em um ambiente local](https://github.com/phsmoura/desafios-devops/tree/master/kubernetes/):

  - [x]  Construir a imagem docker da aplicação
  - [x]  Criar os manifestos de recursos kubernetes para rodar a aplicação (_deployments, services, ingresses, configmap_ e qualquer outro que você considere necessário)
  - [x]  Criar um _script_ para a execução do _deploy_ em uma única execução.
  - [x]  A aplicação deve ter seu _deploy_ realizado com uma única linha de comando em um cluster kubernetes **local**
  - [x]  Todos os _pods_ devem estar rodando
  - [ ]  A aplicação deve responder à uma URL específica configurada no _ingress_

  Extras:
  - [ ]  Utilizar Helm [HELM](https://helm.sh)
  - [x]  Divisão de recursos por _namespaces_
  - [ ]  Utilização de _health check_ na aplicação
  - [x]  Fazer com que a aplicação exiba seu nome ao invés de **"Olá, candidato!"**
