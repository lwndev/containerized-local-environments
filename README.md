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

### Using Container Commands Directly

You can use the container commands (node, npm, python, pip, php) directly from your terminal without having to enter the container shell:

```bash
# Add the bin directory to your PATH
export PATH="$(pwd)/bin:$PATH"  # For Bash/Zsh
# OR
set -x PATH $(pwd)/bin $PATH    # For Fish shell

# After starting the Node.js container
node --version
npm install express

# After starting the Python container
python --version
pip install requests

# After starting the PHP container
php --version
```

To make this permanent, add the appropriate command to your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`).

The script will automatically detect your shell type and provide the correct instructions:

```bash
./dev-env.sh path
```

### Accessing Container Shells

```