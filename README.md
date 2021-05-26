# Sample project for ML pipeline testing

these instructions expect that you
  * have a valid CSC account
  * you are added to a project and granted access to servers

### Setup instructions

#### Create and run a virtual machine instance & connect remotely

(this part is done as instructed in the [csc documentation](https://docs.csc.fi/cloud/pouta/launch-vm-from-web-gui/) and in the [CSC webinar on VM setup](https://www.youtube.com/watch?v=CIO8KRbgDoI))

1. login to pouta [web portal](https://pouta.csc.fi/)

2. set up prerequisites

* set up ssh
    * go to Compute/Key pairs and add your computer's public ssh key by clicking 'Import Public key'
     or (if you have no ssh key pair on your device) create key pair with 'Create Key Pair' and save the downloaded .pem file

* set up firewall & security groups (!security settings have been moved in the ui after the tutorials above were made, current locations below:)
    * go to Compute/Network/Security Groups. Click 'Create Security Group' and add name and description
    * click 'Manage Rules' for the newly created security group
    * leave other fields to defaults, and insert '22' as port number (SSH port) and your IP address to the CIDR field. Use [your ip]/32 to only add one IP address. Run `curl -4 ident.me` to get your IP (or use another find-your-IP service)
            
3. create & run a virtual machine instance
               
* lauch a VM instance
    * Go to Instances and click 'Lauch Instance'. Choose image (operating system) and flavour (amount of resources). If you increase the 'Number of Instances', chosen amount of copies of the virtual machine will be instantiated. On the access&security tab choose your key pair and the security group you created. Check on the Network tab that your projects' network is chosen (should be by default)

* associate a floating ip (by default the virtual machines only have private IPs)
    * on Instances tab in your vm instances' actions choose 'Associate Floating IP'. Choose IP or if none are present, click on the + to allocate a new one. Then click 'Associate'

* connect to the vm remotely

    * check the following:
        * if your ssh-agent is running and if not, launch it
        * your ssh private key is added to your ssh keychain: run `ssh-add [path to key]` to add the key
        
    * run `ssh -l cloud-user [VM's floating IP]` to connect to CentOS, or `ssh -l ubuntu [VM's floating IP]` to connect to ubuntu

#### Install MLflow requirements

(these instructions work with ubuntu 20)

* clone this project: run `git clone https://github.com/korolainenriikka/mlflow_test.git`

* run `mv mlflow_test/vmsetup.sh . && chmod u+x vmsetup.sh && ./vmsetup.sh`

* exit and reconnect to apply granted privileges: `exit && ssh -l ubuntu [VM's floating IP]`

#### Run the project

* run this model with `source venv/bin/activate && mlflow run https://github.com/korolainenriikka/mlflow_test.git`. If 'Digit prediction accuracy: ...' is printed, setup has succeeded

### Improvements

  * volumes for storing the results
  
  * further automation

