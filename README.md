
# User Management Script

This project provides a bash script for managing user accounts and groups on a Linux system. It includes scripts for creating and deleting users and groups based on a configuration file.

## Files

- `create_users.sh`: Bash script to create users and groups.
- `ReadMe.md`: A note on how to run the script.

## Usage

### Prerequisites

- Ensure you have the necessary permissions to create users and groups.
- Ensure `openssl` is installed for password generation.

### Preparing the Input File

Create a text file named `users.txt` with the usernames and groups formatted as specified (e.g., `user;groups`).

Example:

```
light;sudo,dev,www-data
idimma;sudo
mayowa;dev,www-data
```

### Running the User Creation Script

Make the create_users.sh script executable:

```bash
chmod +x create_users.sh
```

### Run the script with the input file as an argument:

```bash
sudo ./create_users.sh users.txt
```

## Learn More

To explore more about the HNG Internship program, visit:

- [HNG Internship](https://hng.tech/internship)
- [HNG Hire](https://hng.tech/hire)

## Readme
This `README.md` provides a comprehensive overview of the script, detailed usage instructions, and additional resources for learning more about the HNG Internship. It is designed to be clear and informative for anyone who visits your repository.
