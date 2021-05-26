sudo apt-get update && sudo apt install -y python3-pip python3-venv &&
python3 -m venv venv && source venv/bin/activate &&
pip install mlflow &&

sudo apt-get update &&
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release &&

 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

sudo apt-get update &&
sudo apt-get install -y docker-ce docker-ce-cli containerd.io &&

sudo apt-get install -y docker-ce=5:20.10.6~3-0~ubuntu-focal docker-ce-cli=5:20.10.6~3-0~ubuntu-focal containerd.io &&
sudo usermod -aG docker $USER 
