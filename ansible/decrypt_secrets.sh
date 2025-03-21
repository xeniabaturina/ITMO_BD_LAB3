#!/bin/bash

# This script decrypts the secrets.yml file using Ansible Vault

# Check if Ansible is installed
if ! command -v ansible-vault &> /dev/null; then
    echo "Error: Ansible is not installed. Please install it first."
    exit 1
fi

# Path to the secrets file
SECRETS_FILE="$(dirname "$0")/secrets.yml"

# Check if the file exists
if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: Secrets file not found at $SECRETS_FILE"
    exit 1
fi

# Check if VAULT_PASSWORD environment variable is set
if [ -z "$VAULT_PASSWORD" ]; then
    echo "Error: VAULT_PASSWORD environment variable is not set."
    echo "Please set it with: export VAULT_PASSWORD=your-secure-password"
    exit 1
fi

# Create a temporary file for the vault password
TEMP_PASSWORD_FILE=$(mktemp)
echo "$VAULT_PASSWORD" > "$TEMP_PASSWORD_FILE"

# Decrypt the secrets file
echo "Decrypting secrets file..."
ansible-vault decrypt "$SECRETS_FILE" --vault-password-file "$TEMP_PASSWORD_FILE"

# Check if decryption was successful
if [ $? -eq 0 ]; then
    echo "Secrets file decrypted successfully!"
else
    echo "Failed to decrypt secrets file."
    rm "$TEMP_PASSWORD_FILE"
    exit 1
fi

# Remove the temporary file
rm "$TEMP_PASSWORD_FILE"

echo "Done!" 