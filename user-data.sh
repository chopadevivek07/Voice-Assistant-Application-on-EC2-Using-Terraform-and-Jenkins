#!/bin/bash
apt update -y
apt install python3 python3-pip git -y
cd /home/ubuntu
git clone https://github.com/chopadevivek07/-Voice-Assistant-Application-on-EC2-Using-Terraform-and-Jenkins.git
cd Jarvis-Desktop-Voice-Assistant
pip3 install -r requirements.txt

echo "[Unit]
Description=Jarvis Voice Assistant
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/ubuntu/Jarvis-Desktop-Voice-Assistant/main.py
Restart=always
User=ubuntu

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/jarvis.service

systemctl daemon-reload
systemctl enable jarvis
systemctl start jarvis
