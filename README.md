# README

This is a docker container used to run inasafe test. Typically useful in non
linux environment, such as Windows or OSX. Not fully working yet, still WIP.
This container can also be coupled with pycharm to run the test in IDE. Very 
useful for debugging process.

# Container Setup

Clone this repo in the same level with inasafe and inasafe_data source 
directory. This location will make sure docker-compose to mount inasafe source
to the container.

Go to deployment directory and run Makefile from there. First, run:

```
make build
```

to build the container images. There are two images currently available. In 
the future, we might want to have a different combination of QGIS version and 
Ubuntu version. 

## Travis build

This container is composed to closely resemble travis, that we used to test 
Inasafe. Altough, some test seems still fails for unknown reasons.

## Test build

This container uses Ubuntu 12.04 and QGIS LTR version (2.8.3). Still, some 
test fails and segfault.

## SSH into the container

We are setting up ssh service inside the container. We tried to use docker 
integration in Pycharm, but it's just not that simple. Some service needs to 
be spin up (Xvfb and sourcing Inasafe environment), that's why we can't use 
Docker integration.

To SSH into the container, we should use the IP the docker-machine uses. This 
is typically needed for Windows and OSX, because the docker host is another 
VM, and not the native host. The problem is, sometimes docker-machine gives 
different IP when it first started. What we suggest is creating an entry in 
```/etc/hosts``` file. Something like this:


```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost 
192.168.99.101  docker-inasafe-test
```

Remember this hostname: ```docker-inasafe-test```. We can use this hostname 
to connect using ssh.

First, create a docker-machine (if you haven't), connect and and find out 
it's IP:

```
docker-machine ip (machine-name)
```

Put the IP and hostname entry to ```/etc/hosts```. Then start the container 
you want.

```
make inasafetravis
```

Lookup the port for your container in docker-compose.yml. You can then connect
using ssh like this:

```
ssh -p 6667 root@docker-inasafe-test # password is 'docker' without quotes
```
 
## Setting up pycharm environment

We will be using docker's python interpreter. To set it:

1. 	Go to settings >> Project Interpreter. Click the gear icon and click 
	Add Remote.
   
2.	Choose "SSH Credentials", enter the appropriate credentials.

	```
	User: root
	Host: (your docker hostname in /etc/hosts)
	Port: (container SSH port, e.g. 6667)
	Auth type: Password
	Password: docker
	Python interpreter: /usr/bin/python
	```

3.	Click OK, and Pycharm will build skeleton files for the IDE.

We then specify file mappings:

1. 	Go to Tools >> Deployment >> Configuration

2.	Click + icon to add configuration

3.	Fill appropriate name (docker-inasafe-test) and SFTP for type field

4.	Use the same credentials with SSH to fill in SFTP details

5.	In the mappings tab, set you local path location that corresponds to 
	```/home/test/inasafe``` and ```/home/test/inasafe_data``` in the 
	container. Or set your local path one level up from inasafe repo and 
	map it to ```/home/test```

We can then use the interpreter to run tests using Unittests or Nosetests in 
Pycharm.

1.	Go to Run >> Edit Configurations

2.	Go to Defaults >> Python Tests >> Nosetests

3.	Enter the following values for params: ```-A 'not slow' --with-id```

4.	Enter the following default values for Environment variables:

	```
	PYTHONPATH = /usr/share/qgis/python:/usr/share/qgis/python/plugins:
	DISPLAY = :99
	```

5.	Set the default working dir to ```(InaSAFE Repo)/safe``` folder

6.	Go to Settings >> Tools >> Python Integrated Tools. Set Default test 
	runner to Nosetests.
   
Now we can use the default test template to run the test.

1.	To run a test class/package, you can right click at the class, and then 
	click "Run Unittests in (class name/package name)".

2.	To run a test method, you can put your cursor at the test method and then
	you can right click, and then click "Run Unittests in (methodname)".
   
   
Pycharm test tools has a very useful tools, like batch running all the tests 
in package, and only rerun failed tests. You can also run the tests in debug 
mode.
