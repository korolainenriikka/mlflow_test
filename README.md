# Sample project for ML pipeline testing

! the following instructions work on the tagged commit version of the code. The newest version works on a different setup.

this workflow:
  * creates a virtual machine and volume, sets them up and connects them to one another
  * copies data and mlflow project from git to the virtual env and runs the model

the workflow setups' steps can be used for running any small-to-medium-scale mlproject in a CSC environment. Only commands that need to be changed are the git URI:s, in the scp command the '\*.gz' part that specifies the files to copy, and the mlflow run command's project name and params. 

these instructions expect that you
  * have a valid CSC account
  * you are added to a project and granted access to servers

## Initial setup instructions

### Create and run a virtual machine instance & connect remotely

(this part is done as instructed in the [csc documentation](https://docs.csc.fi/cloud/pouta/launch-vm-from-web-gui/) and in the [CSC webinar on VM setup](https://www.youtube.com/watch?v=CIO8KRbgDoI))

1. login to pouta [web portal](https://pouta.csc.fi/) (or another openstack web portal)

2. set up prerequisites

* set up ssh
    * go to Compute/Key pairs and add your computer's public ssh key by clicking 'Import Public key'
     or (if you have no ssh key pair on your device) create key pair with 'Create Key Pair' and save the downloaded .pem file

* set up firewall & security groups (!security settings have been moved in the ui after the tutorials above were made, current locations below:)
    * go to Network/Security Groups. Click 'Create Security Group' and add name and description
    * click 'Manage Rules' for the newly created security group. Then click 'Add rule'
    * leave other fields to defaults, and insert '22' as port number (SSH port) and your IP address to the CIDR field. Use [your ip]/32 to only add one IP address. Run `curl -4 ident.me` to get your IP (or use another find-my-IP service)
            
3. create & run a virtual machine instance
               
* launch a VM instance
    * Go to Compute/Instances and click 'Lauch Instance'. Choose 'Boot from image' and the image (Ubuntu-20.04) and flavour (tiny/small suffices for this purpose). On the access&security tab choose your key pair and the security group you created. Then click 'Launch'

* associate a floating IP (by default the virtual machines only have private IPs)
    * on Instances tab in your vm instances' actions choose 'Associate Floating IP'. Choose IP or if none are present, click on the + to allocate a new one. Then click 'Associate'

* connect to the vm remotely

    * check the following:
        * if your ssh-agent is running and if not, launch it with `eval $(ssh-agent)` (ubuntu 18)
        * your ssh private key is added to your ssh keychain: run `ssh-add [path to key]` to add the key
        
    * run `ssh -l ubuntu [VM's floating IP]` to connect (Ubuntu VM)

### Install MLflow requirements

(these instructions work with ubuntu 20)

* clone this project: run `git clone https://github.com/korolainenriikka/mlflow_test.git`

* run `mv mlflow_test/vmsetup.sh . && chmod u+x vmsetup.sh && ./vmsetup.sh`

* run `logout` to close ssh connection, shut off and re-launch the virtual machine in the cPouta web portal (this is required for the privilege modifications to take effect)

### Create a volume & mount to virtual machine

* Create a volume: on the web portal go to Volumes/Volumes and click Create Volume. Name the volume, add description and choose size. Choose "no source" as volume source.

* Connect volume to the VM: go to Compute/Instances and in the Actions dropdown choose 'Attach Volume'. Choose the volume and click 'Attach'.

* On the VM terminal: run `mv mlflow_test/volumesetup.sh . && chmod u+x volumesetup.sh && ./volumesetup.sh`

## Running the MLflow project

### Copy data to the volume

* On your local machine: run `git clone https://github.com/korolainenriikka/mnist-data.git` to clone the data

* To copy the data to the volume run `cd mnist-data && scp -i [path-to-private-key-file] *.gz ubuntu@[vm floating IP]:/media/volume/test_data`

### Run the project

* on the VM: build Docker image: `cd mlflow_test && docker build -t mnist-dockerized -f Dockerfile .`

* run this model from the home directory with `source venv/bin/activate && mlflow run mlflow_test -P path-to-data=/data/`. If 'Digit prediction accuracy: ...' is printed, setup has succeeded. Metrics are saved to the `mlruns` directory.

## Improvements

  * results saved outside of VM

