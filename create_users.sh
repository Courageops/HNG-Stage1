#!/bin/bash

# Script to create users, assign groups, set up home directories, generate passwords, and log actions

# Log file and secure password file
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Check if the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" | tee -a "$LOG_FILE"
  exit 1
fi

# Check if the input file is provided as an argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <filename>" | tee -a "$LOG_FILE"
  exit 1
fi

# Function to generate random passwords
generate_password() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12
}

# Read the input file and process each line
while IFS=';' read -r username groups; do
  # Trim whitespace
  username=$(echo "$username" | xargs)
  groups=$(echo "$groups" | xargs)

  # Create user group with the same name as the username
  if ! getent group "$username" >/dev/null; then
    groupadd "$username"
    echo "Group '$username' created" | tee -a "$LOG_FILE"
  else
    echo "Group '$username' already exists" | tee -a "$LOG_FILE"
  fi

  # Create user
  if ! id -u "$username" >/dev/null 2>&1; then
    useradd -m -g "$username" "$username"
    echo "User '$username' created" | tee -a "$LOG_FILE"
  else
    echo "User '$username' already exists" | tee -a "$LOG_FILE"
  fi

  # Add user to additional groups
  IFS=',' read -r -a group_array <<< "$groups"
  for group in "${group_array[@]}"; do
    group=$(echo "$group" | xargs)
    if ! getent group "$group" >/dev/null; then
      groupadd "$group"
      echo "Group '$group' created" | tee -a "$LOG_FILE"
    fi
    usermod -aG "$group" "$username"
    echo "User '$username' added to group '$group'" | tee -a "$LOG_FILE"
  done

  # Generate and set password for user
  password=$(generate_password)
  echo "$username:$password" | chpasswd
  echo "$username,$password" >> "$PASSWORD_FILE"
  chmod 600 "$PASSWORD_FILE"
  echo "Password set for user '$username'" | tee -a "$LOG_FILE"

  # Set permissions and ownership for home directory
  chmod 700 "/home/$username"
  chown "$username:$username" "/home/$username"
  echo "Home directory permissions set for user '$username'" | tee -a "$LOG_FILE"

done < "$1"
