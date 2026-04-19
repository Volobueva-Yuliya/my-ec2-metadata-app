#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/ec2-metadata-app"
VENV_DIR="${APP_DIR}/venv"

sudo mkdir -p "${APP_DIR}"
sudo cp -r app "${APP_DIR}/"
sudo cp requirements.txt "${APP_DIR}/"

python3 -m venv "${VENV_DIR}"
"${VENV_DIR}/bin/pip" install --upgrade pip
"${VENV_DIR}/bin/pip" install -r "${APP_DIR}/requirements.txt"

sudo tee /etc/systemd/system/ec2-metadata-app.service > /dev/null <<'EOF'
[Unit]
Description=EC2 Metadata App
After=network.target

[Service]
User=root
WorkingDirectory=/opt/ec2-metadata-app
ExecStart=/opt/ec2-metadata-app/venv/bin/gunicorn --bind 0.0.0.0:80 app.main:app
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ec2-metadata-app
sudo systemctl restart ec2-metadata-app
sudo systemctl status ec2-metadata-app --no-pager