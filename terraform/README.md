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
