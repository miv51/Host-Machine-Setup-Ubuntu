#!/bin/bash

# This script downloads, installs, and configures the SSH server on Ubuntu.
# IMPORTANT:  Run this script with sudo privileges.
#             It's designed to be run on the server (Ubuntu machine).

# --- Variables ---
NEW_SSH_PORT="2233"  # Change this if you want a different port
USERNAME="michael" # Replace with your actual Ubuntu username on the server

# --- Step 1: Install OpenSSH Server ---
echo "--- Step 1: Installing OpenSSH Server ---"
sudo apt update
sudo apt install openssh-server

# --- Step 2: Start and Enable SSH Service ---
echo "--- Step 2: Starting and Enabling SSH Service ---"
sudo systemctl status ssh
sudo systemctl enable ssh

# --- Step 3: Check Ubuntu Machine's IP Address ---
echo "--- Step 3: Checking IP Address ---"
ip a

# --- Step 4: Configure Firewall ---
echo "--- Step 4: Configuring Firewall ---"
sudo ufw allow ssh
sudo ufw enable
sudo ufw status

# --- Step 5: Change Default SSH Port ---
echo "--- Step 5: Changing SSH Port to $NEW_SSH_PORT ---"
sudo sed -i "s/^#?Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config

# --- Step 6: Update Firewall Rule ---
echo "--- Step 6: Updating Firewall Rule ---"
sudo ufw delete allow ssh
sudo ufw allow "$NEW_SSH_PORT/tcp"
sudo ufw enable
sudo ufw status

# --- Step 7: Disable Root Login and Password Authentication ---
echo "--- Step 7: Disabling Root Login and Password Authentication ---"
sudo sed -i 's/^#?PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# --- Step 8 & 9: Prepare .ssh Directory and authorized_keys ---
echo "--- Step 8 & 9: Preparing .ssh Directory and authorized_keys ---"
sudo mkdir -p /home/"$USERNAME"/.ssh
sudo chmod 700 /home/"$USERNAME"/.ssh
sudo touch /home/"$USERNAME"/.ssh/authorized_keys  # Paste your public key here, save and exit
sudo chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh/authorized_keys # Change ownership
sudo chmod 600 /home/"$USERNAME"/.ssh/authorized_keys

echo ">>> IMPORTANT: Don't forget to paste each public key on its own line in ~/.ssh/authorized_keys. <<<"

# --- Step 10: Restart SSH Service ---
echo "--- Step 10: Restarting SSH Service ---"
sudo systemctl restart sshd

echo "--- SSH Server Setup Complete! ---"
echo ">>  To connect, use: ssh -p $NEW_SSH_PORT $USERNAME@your_ubuntu_ip_address  <<"

