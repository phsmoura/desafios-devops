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

O **Docker** e o **Kubernetes** serão instalados automaticamente nas instâncias junto com a construção da imagem da aplicação durante o provisionamento.

Após a criação das máquinas virtuais, basta acessá-las com o ssh do **Vagrant**. As máquinas foram nomeadas como:

- master: máquina _master_ do _cluster_
- minion1: máquina _slave_ do _cluster_

Para acessá-las:
```bash
$ vagrant ssh master
$ vagrant ssh minion1
```

## Realizando _deploy_ da aplicação
Acesse a máquina _master_ e execute o _script_ para realizar o deploy.
```bash
$ vagrant ssh master
$ ./kubernetes/provision/deploy.sh --all
```

Confira se os _nodes_ e os _pods_ estão funcionando corretamente.
```bash
$ kubectl get nodes
$ kubectl get pods --namespace myapp
```
