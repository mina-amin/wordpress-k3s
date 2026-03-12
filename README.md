# wordpress-k3s
# By Mina Amin


## Instructions to run the pipeline ##

On your server:
1. Generate an SSH key pair
bashssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions
This creates two files:

~/.ssh/github_actions → private key (goes to GitHub)
~/.ssh/github_actions.pub → public key (goes to server)

2. Create the .ssh directory and add your public key
bashmkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "<paste contents of github_actions.pub here>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

3. Make sure SSH is open and sudo works without a password (required for kubectl)
bash# Allow passwordless sudo for kubectl
echo "$USER ALL=(ALL) NOPASSWD: /usr/local/bin/kubectl" >> /etc/sudoers

4. Open port 22 in your firewall
bash# UFW (Ubuntu)
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 6443
ufw enable

Back on your local machine:
5. Test the SSH connection works
bashssh -i ~/.ssh/github_actions root@<YOUR_SERVER_IP> "echo connected"

On GitHub — add the secrets:
6. Go to your repo → Settings → Secrets and variables → Actions → New repository secret
SecretHow to get the valueSSH_PRIVATE_KEYcat ~/.ssh/github_actionsHOST_IPyour server's public IPSSH_USERroot or whatever user you SSHed asINGRESS_HOSTyour domain or server IP

That's it. Push to main and the pipeline takes over from there.

