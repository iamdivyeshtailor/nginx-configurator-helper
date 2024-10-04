# Nginx Setup Automation Script

This Bash script automates the creation of Nginx configuration files for frontend and backend applications, setting up a reverse proxy with ease. It generates the Nginx configuration, sets up symbolic links, and tests the configuration for validity.

## Features

- **Server IP Detection**: Displays the server's IP address and instructs you to point your domain to it.
- **Interactive Setup**: Prompts for domain name and application port, then generates an Nginx config file based on user input.
- **Symbolic Link Creation**: Automatically creates a symbolic link from the config file in `/etc/nginx/sites-available/` to `/etc/nginx/sites-enabled/`.
- **Nginx Configuration Testing**: Runs `nginx -t` to validate the configuration and reloads Nginx if the test is successful.

## Requirements

- Nginx must be installed on the server.

## Usage

1. Clone this repository:
    ```bash
    git clone https://github.com/<your-username>/<repo-name>.git
    ```

2. Navigate to the repository directory:
    ```bash
    cd <repo-name>
    ```

3. Make the script executable:
    ```bash
    chmod +x nginx-setup.sh
    ```

4. Run the script as root:
    ```bash
    sudo ./nginx-setup.sh
    ```

5. Follow the on-screen prompts to configure and test your Nginx setup.

## Example

```bash
Your server's IP is: 192.168.1.10
Please point your domain to this IP.
Enter your domain name: example.com
Enter the port number or proxy on which your application is running (e.g., 3000): 3000
Nginx configuration created for domain: example.com
Created a symbolic link for Nginx configuration.
Testing Nginx configuration...
nginx: configuration file /etc/nginx/nginx.conf test is successful
Nginx has been reloaded with the new configuration.
