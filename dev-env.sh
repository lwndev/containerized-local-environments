#!/bin/bash

# Create project directories if they don't exist
mkdir -p node-projects python-projects php-projects

# Get the current directory name for container prefix
DIRNAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9]/-/g')

# Get the absolute path of the bin directory
BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin"

# Detect user's shell
detect_shell() {
  # Get the user's current shell
  CURRENT_SHELL=$(basename "$SHELL")
  
  # Default shell config file
  SHELL_CONFIG_FILE=""
  
  case "$CURRENT_SHELL" in
    bash)
      if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG_FILE="$HOME/.bashrc"
      elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG_FILE="$HOME/.bash_profile"
      fi
      ;;
    zsh)
      SHELL_CONFIG_FILE="$HOME/.zshrc"
      ;;
    fish)
      SHELL_CONFIG_FILE="$HOME/.config/fish/config.fish"
      ;;
    *)
      # Unknown shell, will provide generic instructions
      ;;
  esac
  
  echo "$CURRENT_SHELL:$SHELL_CONFIG_FILE"
}

# Function to display help
show_help() {
  echo "Development Environment Manager"
  echo "-------------------------------"
  echo "Usage: ./dev-env.sh [command]"
  echo ""
  echo "Commands:"
  echo "  start [service]    Start all or specific development container"
  echo "  stop [service]     Stop all or specific development container"
  echo "  status             Show status of development containers"
  echo "  shell [service]    Open a shell in the specified container"
  echo "  logs [service]     Show logs for all or specific container"
  echo "  path               Show instructions to add bin directory to PATH"
  echo ""
  echo "Services: node-dev, python-dev, php-dev"
  echo ""
  echo "Examples:"
  echo "  ./dev-env.sh start            # Start all development containers"
  echo "  ./dev-env.sh start node-dev   # Start only Node.js container"
  echo "  ./dev-env.sh shell python-dev # Open shell in Python container"
}

# Function to add bin directory to PATH
show_path_instructions() {
  # Detect shell
  SHELL_INFO=$(detect_shell)
  CURRENT_SHELL=${SHELL_INFO%%:*}
  SHELL_CONFIG_FILE=${SHELL_INFO#*:}
  
  echo "Detected shell: $CURRENT_SHELL"
  echo ""
  echo "To add the development commands to your PATH for the current session, run:"
  echo ""
  echo "  export PATH=\"$BIN_DIR:\$PATH\""
  echo ""
  
  if [ -n "$SHELL_CONFIG_FILE" ]; then
    echo "To make this permanent, add the following line to your $SHELL_CONFIG_FILE:"
    
    case "$CURRENT_SHELL" in
      fish)
        echo "  set -x PATH $BIN_DIR \$PATH"
        ;;
      *)
        echo "  export PATH=\"$BIN_DIR:\$PATH\""
        ;;
    esac
    
    echo ""
    echo "You can do this by running:"
    
    case "$CURRENT_SHELL" in
      fish)
        echo "  echo 'set -x PATH $BIN_DIR \$PATH' >> $SHELL_CONFIG_FILE"
        ;;
      *)
        echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> $SHELL_CONFIG_FILE"
        ;;
    esac
  else
    echo "To make this permanent, add the export command to your shell's configuration file."
  fi
  
  echo ""
  echo "After starting a container (e.g., node-dev), you can use its commands directly:"
  echo "  node --version"
  echo "  npm --version"
  echo "  python --version"
  echo "  pip --version"
  echo "  php --version"
}

# Function to provide PATH instructions based on shell
get_path_command() {
  # Detect shell
  SHELL_INFO=$(detect_shell)
  CURRENT_SHELL=${SHELL_INFO%%:*}
  
  case "$CURRENT_SHELL" in
    fish)
      echo "set -x PATH $BIN_DIR \$PATH"
      ;;
    *)
      echo "export PATH=\"$BIN_DIR:\$PATH\""
      ;;
  esac
}

# Function to start containers
start_containers() {
  # Get the appropriate PATH command for the user's shell
  PATH_CMD=$(get_path_command)
  
  if [ -z "$1" ]; then
    echo "Starting all development containers..."
    docker compose -f docker-compose.dev.yml up -d
    echo ""
    echo "All containers started. To use the commands, add the bin directory to your PATH:"
    echo "  $PATH_CMD"
  else
    echo "Starting $1 container..."
    docker compose -f docker-compose.dev.yml up -d "$1"
    
    case "$1" in
      node-dev)
        echo ""
        echo "Node.js container started. To use node and npm commands, add the bin directory to your PATH:"
        echo "  $PATH_CMD"
        ;;
      python-dev)
        echo ""
        echo "Python container started. To use python and pip commands, add the bin directory to your PATH:"
        echo "  $PATH_CMD"
        ;;
      php-dev)
        echo ""
        echo "PHP container started. To use php command, add the bin directory to your PATH:"
        echo "  $PATH_CMD"
        ;;
    esac
  fi
}

# Function to stop containers
stop_containers() {
  if [ -z "$1" ]; then
    echo "Stopping all development containers..."
    docker compose -f docker-compose.dev.yml down
    echo ""
    echo "All containers stopped. Commands in bin directory will no longer work until containers are restarted."
  else
    echo "Stopping $1 container..."
    docker compose -f docker-compose.dev.yml stop "$1"
    
    case "$1" in
      node-dev)
        echo ""
        echo "Node.js container stopped. The node and npm commands will no longer work until the container is restarted."
        ;;
      python-dev)
        echo ""
        echo "Python container stopped. The python and pip commands will no longer work until the container is restarted."
        ;;
      php-dev)
        echo ""
        echo "PHP container stopped. The php command will no longer work until the container is restarted."
        ;;
    esac
  fi
}

# Function to show container status
show_status() {
  echo "Development Container Status:"
  docker compose -f docker-compose.dev.yml ps
}

# Function to show logs
show_logs() {
  if [ -z "$1" ]; then
    echo "Showing logs for all containers..."
    docker compose -f docker-compose.dev.yml logs
  else
    echo "Showing logs for $1 container..."
    docker compose -f docker-compose.dev.yml logs "$1"
  fi
}

# Function to open shell in container
open_shell() {
  if [ -z "$1" ]; then
    echo "Error: Please specify a service (node-dev, python-dev, php-dev)"
    exit 1
  fi
  
  case "$1" in
    node-dev)
      echo "Opening shell in Node.js container..."
      docker exec -it "${DIRNAME}-node-dev-1" sh
      ;;
    python-dev)
      echo "Opening shell in Python container..."
      docker exec -it "${DIRNAME}-python-dev-1" bash
      ;;
    php-dev)
      echo "Opening shell in PHP container..."
      docker exec -it "${DIRNAME}-php-dev-1" bash
      ;;
    *)
      echo "Error: Unknown service '$1'"
      exit 1
      ;;
  esac
}

# Main command processing
case "$1" in
  start)
    start_containers "$2"
    ;;
  stop)
    stop_containers "$2"
    ;;
  status)
    show_status
    ;;
  shell)
    open_shell "$2"
    ;;
  logs)
    show_logs "$2"
    ;;
  path)
    show_path_instructions
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    show_help
    ;;
esac 