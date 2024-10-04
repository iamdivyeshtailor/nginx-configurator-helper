#!/bin/bash

# Function to check if Nginx is installed
check_nginx_installed() {
    if ! command -v nginx &> /dev/null; then
        echo "Nginx is not installed on this system."
        read -p "Do you want to install Nginx? (y/n): " install_nginx
        if [ "$install_nginx" == "y" ]; then
            install_nginx
        else
            echo "Nginx installation skipped. Exiting..."
            exit 1
        fi
    else
        echo "Nginx is already installed."
    fi
}

# Function to install Nginx
install_nginx() {
    echo "Installing Nginx..."
    sudo apt update
    sudo apt install nginx -y
    if [ $? -eq 0 ]; then
        echo "Nginx installed successfully."
        sudo systemctl start nginx
        sudo systemctl enable nginx
    else
        echo "Nginx installation failed. Please install Nginx manually and try again."
        exit 1
    fi
}

# Step 1: Check if Nginx is installed
check_nginx_installed

# Step 2: Get the server IP and display it
server_ip=$(hostname -I | awk '{print $1}')
echo "Your server's IP is: $server_ip"
echo "Please point your domain to this IP."

# Step 3: Ask for the domain name
read -p "Enter your domain name: " domain_name

# Step 4: Ask for the port number or proxy
read -p "Enter the port number or proxy on which your application is running (e.g., 3000): " app_port

# Step 5: Create the Nginx configuration file
create_nginx_config() {
    local domain_name=$1
    local port=$2

    # Nginx configuration content
    cat <<EOL > /etc/nginx/sites-available/$domain_name.conf
server {
    listen 80;
    server_name $domain_name;

    location / {
        proxy_pass http://127.0.0.1:$port;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

    echo "Nginx configuration created for domain: $domain_name"
}

# Step 6: Create the symbolic link for Nginx config
create_nginx_config "$domain_name" "$app_port"
ln -s /etc/nginx/sites-available/$domain_name.conf /etc/nginx/sites-enabled/

echo "Created a symbolic link for Nginx configuration."

# Step 7: Save the new generated config file and test Nginx
echo "Nginx configuration for $domain_name saved at /etc/nginx/sites-available/$domain_name.conf"

# Step 8: Test Nginx configuration and reload if successful
echo "Testing Nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid."
    sudo systemctl reload nginx
    echo "Nginx has been reloaded with the new configuration."
else
    echo "There is an error in the Nginx configuration. Please fix the issues and try again."
fi
