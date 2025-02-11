#!/bin/bash

# Repository URLs
BACKEND_REPO="https://github.com/Anemonastrum/pusatoleholeh-backend.git"
FRONTEND_REPO="https://github.com/heufken/pusatoleholeh-frontend.git"
ADMIN_REPO="https://github.com/Anemonastrum/pusatoleholeh-admindashboard.git"

# Function to display system information
display_system_info() {
  echo "============================================="
  echo "System Information"
  echo "============================================="

  # Display Linux distribution and version
  if [ -f /etc/os-release ]; then
    echo "Linux Distribution: $(source /etc/os-release && echo $PRETTY_NAME)"
  else
    echo "Linux Distribution: Unknown"
  fi

  # Display kernel version
  echo "Kernel Version: $(uname -r)"

  # Display CPU information
  echo "CPU: $(lscpu | grep "Model name" | cut -d ':' -f 2 | xargs)"

  # Display total memory
  echo "Memory: $(free -h | grep Mem | awk '{print $2}')"

  # Display available disk space
  echo "Disk Space: $(df -h / | grep / | awk '{print $4}') available"

  echo "============================================="
}

# Function to detect the package manager
detect_package_manager() {
  if command -v apt &> /dev/null; then
    echo "apt"
  elif command -v yum &> /dev/null; then
    echo "yum"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  elif command -v pacman &> /dev/null; then
    echo "pacman"
  elif command -v zypper &> /dev/null; then
    echo "zypper"
  else
    echo "unsupported"
  fi
}

# Function to install Docker and Docker Compose
install_docker() {
  local package_manager=$1
  echo "Installing Docker and Docker Compose using $package_manager..."

  case $package_manager in
    apt)
      sudo apt update
      sudo apt install -y docker.io docker-compose
      ;;
    yum)
      sudo yum install -y docker docker-compose
      ;;
    dnf)
      sudo dnf install -y docker docker-compose
      ;;
    pacman)
      sudo pacman -S docker docker-compose
      ;;
    zypper)
      sudo zypper install -y docker docker-compose
      ;;
    *)
      echo "Unsupported package manager. Please install Docker and Docker Compose manually."
      exit 1
      ;;
  esac

  # Start and enable Docker service
  sudo systemctl start docker
  sudo systemctl enable docker
}

# Function to clone repositories
clone_repositories() {
  echo "Cloning repositories..."
  git clone "$BACKEND_REPO"
  git clone "$FRONTEND_REPO"
  git clone "$ADMIN_REPO"
}

# Function to copy Dockerfile and Nginx configuration
copy_docker_files() {
  echo "Copying Dockerfile and Nginx configuration..."

  # Copy frontend files
  if [ -d "Dockerfile/frontend" ]; then
    cp Dockerfile/frontend/Dockerfile frontend/
    cp Dockerfile/frontend/nginx.conf frontend/
    echo "Copied frontend Dockerfile and Nginx configuration."
  else
    echo "Frontend Dockerfile directory not found."
  fi

  # Copy backend files
  if [ -d "Dockerfile/backend" ]; then
    cp Dockerfile/backend/Dockerfile backend/
    echo "Copied backend Dockerfile."
  else
    echo "Backend Dockerfile directory not found."
  fi

  # Copy admin files
  if [ -d "Dockerfile/admin" ]; then
    cp Dockerfile/admin/Dockerfile pusatoleholeh-admindashboard/
    cp Dockerfile/admin/nginx.conf pusatoleholeh-admindashboard/
    echo "Copied admin Dockerfile and Nginx configuration."
  else
    echo "Admin Dockerfile directory not found."
  fi
}

# Function to confirm installation
confirm_installation() {
  while true; do
    read -p "Do you want to install Docker and Docker Compose? (y/n): " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes (y) or no (n).";;
    esac
  done
}

# Function to confirm running docker-compose up
confirm_docker_compose_up() {
  while true; do
    read -p "Do you want to run 'docker-compose up --build' to start the application? (y/n): " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes (y) or no (n).";;
    esac
  done
}

# Main script
echo "Starting setup..."

# Display system information
display_system_info

# Detect the package manager
package_manager=$(detect_package_manager)
if [ "$package_manager" == "unsupported" ]; then
  echo "Unsupported package manager. Exiting."
  exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed."
  if confirm_installation; then
    install_docker "$package_manager"
  else
    echo "Docker installation skipped."
    exit 1
  fi
else
  echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
  echo "Docker Compose is not installed."
  if confirm_installation; then
    install_docker "$package_manager"
  else
    echo "Docker Compose installation skipped."
    exit 1
  fi
else
  echo "Docker Compose is already installed."
fi

# Clone repositories
if [ ! -d "pusatoleholeh-backend" ] || [ ! -d "pusatoleholeh-frontend" ] || [ ! -d "pusatoleholeh-admindashboard" ]; then
  clone_repositories
else
  echo "Repositories already cloned."
fi

# Copy Dockerfile and Nginx configuration
copy_docker_files

echo "Setup complete!"

# Confirm before running docker-compose up
if confirm_docker_compose_up; then
  echo "Running 'docker-compose up --build'..."
  docker-compose up --build
else
  echo "You can run 'docker-compose up --build' manually to start the application."
fi