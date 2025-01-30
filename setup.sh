#!/bin/bash

# Define project directory (current directory)
PROJECT_DIR=$(pwd)

# Step 1: Create a virtual environment
if [ ! -d "dbt_venv" ]; then
  echo "Creating virtual environment..."
  python3 -m venv dbt_venv
else
  echo "Virtual environment already exists."
fi

# Step 2: Install dbt core and the necessary packages
echo "Installing DBT core and dbt-postgres..."
source dbt_venv/bin/activate  # Activate here to keep it in the same shell session
pip install --upgrade pip
pip install dbt-core dbt-postgres

# Step 3: Check if installation was successful
echo "Verifying DBT installation..."
dbt --version

echo "Setup complete! Virtual environment 'dbt_venv' is ready."
