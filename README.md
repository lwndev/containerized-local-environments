# Containerized Development Environment

This setup allows you to develop with Node.js, Python, and PHP without installing these languages directly on your host machine. Instead, Docker containers are used to provide isolated development environments.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running (version 20.10.0 or higher)
- Any code editor or IDE of your choice

## Directory Structure

```
.
├── docker-compose.dev.yml  # Container configuration
├── dev-env.sh              # Helper script
├── node-projects/          # Your Node.js projects go here
├── python-projects/        # Your Python projects go here
└── php-projects/           # Your PHP projects go here
```

## Getting Started

1. Clone or download this repository
2. Make sure Docker Desktop is running
3. Start the development containers:

```bash
./dev-env.sh start
```

## Troubleshooting

If you encounter any issues:

- Make sure Docker Desktop is running
- The script uses the `docker compose` command (with a space), which is available in newer Docker versions
- If you have an older Docker version, you might need to install Docker Compose separately

## Working with Containers

### Starting and Stopping Containers

```bash
# Start all development containers
./dev-env.sh start

# Start only a specific container (e.g., Node.js)
./dev-env.sh start node-dev

# Stop all containers
./dev-env.sh stop

# Stop a specific container
./dev-env.sh stop python-dev

# Check container status
./dev-env.sh status
```

### Accessing Container Shells

```bash
# Open a shell in the Node.js container
./dev-env.sh shell node-dev

# Open a shell in the Python container
./dev-env.sh shell python-dev

# Open a shell in the PHP container
./dev-env.sh shell php-dev
```

### Viewing Container Logs

```bash
# View logs for all containers
./dev-env.sh logs

# View logs for a specific container
./dev-env.sh logs php-dev
```

## Development Workflow

1. Start the containers using `./dev-env.sh start`
2. Open your project folder in your preferred code editor or IDE
3. Edit files locally - changes are automatically synced to the container
4. Run commands in the container using `./dev-env.sh shell <service>`
5. Access web applications:
   - Node.js: http://localhost:3000
   - Python: http://localhost:8000
   - PHP: http://localhost:8080

## Example: Creating a Node.js Project

```bash
# Start the Node.js container
./dev-env.sh start node-dev

# Open a shell in the container
./dev-env.sh shell node-dev

# Inside the container shell:
mkdir my-node-app
cd my-node-app
npm init -y
npm install express
echo 'console.log("Hello from containerized Node.js!");' > index.js
node index.js
```

## Example: Creating a Python Project

```bash
# Start the Python container
./dev-env.sh start python-dev

# Open a shell in the container
./dev-env.sh shell python-dev

# Inside the container shell:
mkdir my-python-app
cd my-python-app
pip install flask
echo 'print("Hello from containerized Python!")' > app.py
python app.py
```

## Example: Creating a PHP Project

```bash
# Start the PHP container
./dev-env.sh start php-dev

# Create a PHP file in the php-projects directory
echo '<?php echo "Hello from containerized PHP!"; ?>' > php-projects/index.php

# Access it at http://localhost:8080/index.php
```

## Customizing Containers

To customize the containers (add extensions, install additional tools, etc.), edit the `docker-compose.dev.yml` file. 