#!/bin/bash

# Create project directories if they don't exist
mkdir -p node-projects python-projects php-projects

# Get the current directory name for container prefix
DIRNAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9]/-/g')

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
  echo ""
  echo "Services: node-dev, python-dev, php-dev"
  echo ""
  echo "Examples:"
  echo "  ./dev-env.sh start            # Start all development containers"
  echo "  ./dev-env.sh start node-dev   # Start only Node.js container"
  echo "  ./dev-env.sh shell python-dev # Open shell in Python container"
}

# Function to start containers
start_containers() {
  if [ -z "$1" ]; then
    echo "Starting all development containers..."
    docker compose -f docker-compose.dev.yml up -d
  else
    echo "Starting $1 container..."
    docker compose -f docker-compose.dev.yml up -d "$1"
  fi
}

# Function to stop containers
stop_containers() {
  if [ -z "$1" ]; then
    echo "Stopping all development containers..."
    docker compose -f docker-compose.dev.yml down
  else
    echo "Stopping $1 container..."
    docker compose -f docker-compose.dev.yml stop "$1"
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
  help|--help|-h)
    show_help
    ;;
  *)
    show_help
    ;;
esac 