#!/bin/bash

# Check if service name is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a service name"
    echo "Usage: $0 <service-name>"
    exit 1
fi

SERVICE_NAME="$1"

# Create the systemd service file
cat << EOF > /etc/systemd/system/${SERVICE_NAME}.service
[Unit]
Description=Servidor ${SERVICE_NAME} com Docker Compose
After=docker.service
Requires=docker.service

[Service]
Type=simple
WorkingDirectory=/home/appuser/${SERVICE_NAME}
ExecStart=/usr/bin/docker compose -f /home/appuser/${SERVICE_NAME}/docker-compose.yml up
ExecStop=/usr/bin/docker compose -f /home/appuser/${SERVICE_NAME}/docker-compose.yml down
Restart=always
RestartSec=10
User=appuser
Group=appuser
Environment=COMPOSE_INTERACTIVE_NO_CLI=1

[Install]
WantedBy=multi-user.target
EOF

# Set proper permissions
chmod 644 /etc/systemd/system/${SERVICE_NAME}.service

# Reload systemd daemon
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable ${SERVICE_NAME}.service

# Start the service
systemctl start ${SERVICE_NAME}.service

# Display service status
systemctl status ${SERVICE_NAME}.service