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

Crie as chaves e coloque o diretório do ssh_keys, não há necessidade de criar uma senha.
```bash
$ ssh-keygen

Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): <path/id_rsa>
Enter passphrase (empty for no passphrase): <ENTER>
Enter same passphrase again: <ENTER>
```

Execute o comando para criar as máquinas:
```bash
$ vagrant up
```

O **Docker** e o **Kubernetes** serão instalados automaticamente nas instâncias junto com a construção da imagem e o _deploy_ da aplicação durante o provisionamento. O _script_ de _deploy_ da aplicação está em _"provision/deploy.sh"_ e pode ser encontrado dentro das máquinas virtuais em _"/home/vagrant/kubernetes/provision/depoly.sh"_. Para saber mais sobre este _script_, consulte seu _help_.
```bash
$ ./deploy.sh --help
```

Após a criação das máquinas virtuais, basta acessá-las com o ssh do **Vagrant**. As máquinas foram nomeadas como:

- master: máquina _master_ do _cluster_
- minion1: máquina _slave_ do _cluster_

Para acessá-las:
```bash
$ vagrant ssh master
$ vagrant ssh minion1
```

## Checando _deploy_ da aplicação
Coloque no /etc/hosts da máquina física o fqdn da aplicação.
```bash
$ echo "172.100.100.10 myapp.com.br myapp" >> /etc/hosts
```

Acesse a máquina _master_ e execute os comandos do ```kubectl``` para conferir se os _nodes_ e os _pods_ estão funcionando corretamente. Pode-se utilizar o _tab_ para auto-completar o comando ```kubectl```.
```bash
$ vagrant ssh master
$ kubectl get nodes
$ kubectl get pods --namespace myapp
```

Veja no _service_ o número da porta para acessar a aplicação no _browser_, será um número de 30000 até 32727.
```bash
$ kubectl get service --namespace myapp
NAME          TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
app-service   NodePort   10.103.169.157   <none>        80:31781/TCP   4h23m
```

Coloque o IP ou nome do site, registrado no /etc/hosts, no _browser_ junto com a porta.
![VM vs Container](images/screenshot_browser.png)
