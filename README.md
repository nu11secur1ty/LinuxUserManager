# 🐧 LinuxUserManager

> **Professional Linux User Management Tool - Built for Beginners and System Administrators**

[![Version](https://img.shields.io/badge/version-2.0-blue.svg)](https://github.com/nu11secur1ty/LinuxUserManager)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/nu11secur1ty/LinuxUserManager)
[![Bash](https://img.shields.io/badge/bash-5.0+-yellow.svg)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Compatible-red.svg)](https://www.linux.org)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

<p align="center">
  <a href="https://github.com/nu11secur1ty/LinuxUserManager/tree/main/Program">
    <img src="https://github.com/nu11secur1ty/LinuxUserManager/blob/main/Program/logo/user_manager.jpg" alt="LinuxUserManager Logo" width="600">
  </a>
</p>

---

## 📋 Table of Contents

- [About The Project](#-about-the-project)
- [Key Features](#-key-features)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
- [Demo](#-demo)
- [Supported Distributions](#-supported-distributions)
- [FAQ](#-faq)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## 🎯 About The Project

**LinuxUserManager** is an intuitive and powerful Bash script for managing users in Linux environments. Designed with **beginners in mind**, it provides a simple menu-driven interface that makes complex administrative tasks easy and accessible.

### Why LinuxUserManager?

| Benefit | Description |
|---------|-------------|
| 🔰 **Zero Learning Curve** | Intuitive menu system - no prior knowledge needed |
| 🛡️ **100% Safe** | All commands include comprehensive error checking |
| 🐧 **Universal Compatibility** | Works on all modern Linux distributions |
| 🎨 **Colorful Interface** | Easy to read and navigate with color coding |
| 🔓 **Open Source** | Modify and customize to suit your needs |
| 🏭 **Production Ready** | Tested extensively in real-world environments |
| 👨‍💻 **Beginner Friendly** | Designed specifically for newcomers to Linux |
| ⚡ **Lightweight** | No dependencies - uses only built-in Linux commands |

---

## 🚀 Key Features

| Category | Feature | Description |
|----------|---------|-------------|
| 👤 **User Creation** | Full Options | Complete user setup with UID, home dir, shell, groups |
| ⚡ **User Creation** | Quick Mode | Minimal questions for fast user creation |
| 🗑️ **User Management** | Delete User | Remove users with/without home directory |
| 🔧 **User Management** | Modify User | Change UID, group, shell, password, comment |
| 🔒 **User Management** | Lock/Unlock | Lock or unlock user accounts |
| ⏰ **User Management** | Expiry Dates | Set account expiration dates |
| 👥 **Group Management** | Create Group | Create new groups with specific GID |
| 🗑️ **Group Management** | Delete Group | Remove existing groups |
| ➕ **Group Management** | Add Member | Add users to groups |
| ➖ **Group Management** | Remove Member | Remove users from groups |
| 📋 **Information** | List Users | View all system users |
| 📋 **Information** | List Groups | View all system groups |
| 🔍 **Information** | User Info | Detailed information about specific users |
| 👀 **Information** | Logged-in Users | See who's currently logged in |
| 📊 **Information** | Last Logins | View recent login history |

---

## 💻 System Requirements

| Requirement | Specification |
|-------------|---------------|
| **Operating System** | Linux (any modern distribution) |
| **Shell** | Bash 5.0 or higher |
| **Permissions** | Root access (sudo or root user) |
| **Dependencies** | None (uses built-in Linux commands) |
| **Disk Space** | < 1 MB |
| **RAM** | < 10 MB |

---

## 📦 Installation

### Method 1: Git Clone (Recommended)

```bash
# Clone the repository
git clone https://github.com/nu11secur1ty/LinuxUserManager.git

# Navigate to the directory
cd LinuxUserManager

# Make the script executable
chmod +x usermanager.sh

# Run the script as root
sudo ./usermanager.sh
```

### Method 2: Direct Download

```bash
# Download the script directly
wget https://raw.githubusercontent.com/nu11secur1ty/LinuxUserManager/main/usermanager.sh

# Make it executable
chmod +x usermanager.sh

# Run as root
sudo ./usermanager.sh
```

### Method 3: System-wide Installation

```bash
# Install to system path
sudo cp usermanager.sh /usr/local/bin/usermanager

# Make it executable
sudo chmod +x /usr/local/bin/usermanager

# Now you can run it from anywhere
sudo usermanager
```

---

## 🖥️ Usage

### Quick Start Guide

1. **Run the script as root:**
   ```bash
   sudo ./usermanager.sh
   ```

2. **The main menu will appear:**
   ```
   ╔═══════════════════════════════════════════════════════════╗
   ║                    MAIN MENU                              ║
   ╠═══════════════════════════════════════════════════════════╣
   ║  1) Create User - Full Options                           ║
   ║  2) Create User - Simple                                 ║
   ║  3) Delete User                                          ║
   ║  4) Modify User                                          ║
   ║  5) Group Management                                     ║
   ║  6) List All Users                                       ║
   ║  7) List All Groups                                      ║
   ║  8) Show User Info                                       ║
   ║  9) Show Logged-in Users                                 ║
   ║  0) Exit                                                 ║
   ╚═══════════════════════════════════════════════════════════╝
   
   Enter your choice: 
   ```

3. **Select an option** by typing the number and pressing Enter.

### Usage Examples

#### Example 1: Create a User with Full Options

```bash
Enter username: john_doe
Enter UID (leave empty for auto): 1500
Enter home directory (default: /home/john_doe): 
Create home directory? (y/n): y
Available shells:
1) /bin/bash
2) /bin/sh
3) /bin/zsh
4) /usr/bin/fish
5) /sbin/nologin
Select shell (1-5, default 1): 1
Enter primary group (default: same as username): developers
Enter additional groups (comma-separated, e.g., sudo,docker): sudo,docker
Enter full name / comment (optional): John Doe
Enter expiry date (YYYY-MM-DD, leave empty for none): 2025-12-31
Enter password: ********
Confirm password: ********
✓ User 'john_doe' created successfully!
```

#### Example 2: Quick User Creation

```bash
Enter username: jane_doe
Enter password: ********
Confirm password: ********
✓ User 'jane_doe' created successfully!
```

#### Example 3: Delete a User

```bash
Username    | UID    | Home Directory        | Shell
────────────────────────────────────────────────────
john_doe    | 1500   | /home/john_doe         | /bin/bash
jane_doe    | 1501   | /home/jane_doe         | /bin/bash

Enter username to delete: jane_doe
WARNING: You are about to delete user 'jane_doe'
Remove home directory and mail spool? (y/n): y
Are you sure you want to delete this user? (y/n): y
✓ User 'jane_doe' deleted with home directory and mail spool.
```

#### Example 4: Group Management

```bash
1) Create group
2) Delete group
3) Add user to group
4) Remove user from group
5) List groups
6) Back to main menu

Select option (1-6): 3
Enter username: john_doe
Enter group name: docker
✓ User 'john_doe' added to group 'docker'.
```

---

## 🎬 Demo
- ALWAYS CHECK for the LATEST VERSION!
```
git pull
```

<p align="center">
  <a href="https://github.com/nu11secur1ty/LinuxUserManager/blob/main/demo/UserManager.gif">
    <img src="https://github.com/nu11secur1ty/LinuxUserManager/blob/main/demo/UserManager.gif" alt="UserManager Demo" width="800">
  </a>
</p>

---

## 🐧 Supported Distributions

| Distribution | Version | Status |
|--------------|---------|--------|
| **Ubuntu** | 20.04 LTS, 22.04 LTS, 24.04 LTS | ✅ Fully Tested |
| **Debian** | 11 (Bullseye), 12 (Bookworm) | ✅ Fully Tested |
| **RHEL** | 8, 9 | ✅ Fully Tested |
| **Fedora** | 38, 39, 40 | ✅ Fully Tested |
| **Linux Mint** | 21, 22 | ✅ Fully Tested |
| **Rocky Linux** | 8, 9 | ✅ Fully Tested |
| **AlmaLinux** | 8, 9 | ✅ Fully Tested |
| **CentOS** | 7, 8, 9 | ✅ Fully Tested |
| **openSUSE** | 15.4, 15.5 | ✅ Fully Tested |
| **Arch Linux** | Latest | ✅ Fully Tested |

---

## ❓ FAQ

### General Questions

**Q: Why do I need to run this script as root?**  
A: User management operations require root privileges to modify system files like `/etc/passwd`, `/etc/shadow`, and `/etc/group`.

**Q: Is this script safe for production environments?**  
A: Yes! The script includes comprehensive error checking and validation. However, always test in a non-production environment first.

**Q: Can I use this script on a headless server?**  
A: Absolutely! The script works perfectly over SSH connections.

**Q: Does this script work with LDAP or Active Directory?**  
A: This script manages local users only. For LDAP/AD integration, additional configuration is needed.

### Technical Questions

**Q: Where are the users stored?**  
A: Users are stored in `/etc/passwd`, passwords in `/etc/shadow`, and groups in `/etc/group`.

**Q: What happens to a user's files when deleted?**  
A: When deleting with the `-r` option, the home directory and mail spool are removed. Without `-r`, files remain.

**Q: Can I recover a deleted user?**  
A: No, user deletion is permanent. Always backup important data before deleting users.

**Q: What UID range should I use?**  
A: System users typically use UIDs 0-999. Regular users should have UIDs 1000-60000.

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. **Fork the repository**
2. **Create your feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Guidelines

- Follow existing code style
- Add comments for complex logic
- Test on multiple distributions
- Update documentation as needed

### Report Issues

Found a bug or have a feature request? [Open an issue](https://github.com/nu11secur1ty/LinuxUserManager/issues) and we'll look into it!

---

## 📝 To-Do List (Future Releases)

- [ ] Batch user creation from CSV file
- [ ] SSH key management
- [ ] Password policy enforcement
- [ ] User expiration notifications
- [ ] Backup user data before deletion
- [ ] Interactive user profile setup
- [ ] Multi-language support
- [ ] Docker container management integration
- [ ] User login monitoring
- [ ] Automated user auditing

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2020-2024 OPS Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👏 Acknowledgments

### Development Team

- **V. Varbanovski** - Lead Developer & System Architect
- **G. Dzhankushev** - Developer & Tester
- **@nu11secur1ty** - Project Creator & Maintainer

### Special Thanks

- All contributors and testers
- Open source community
- Linux Foundation
- System administrators who provided feedback

---

## 📞 Contact & Support

- **GitHub Issues:** [Report a bug](https://github.com/nu11secur1ty/LinuxUserManager/issues)
- **Email:** OPS Team (ops@linuxusermanager.com)
- **Twitter:** [@nu11secur1ty](https://twitter.com/nu11secur1ty1)

---

## ⭐ Show Your Support

If this project helped you, please give it a ⭐ on GitHub!

[![GitHub stars](https://img.shields.io/github/stars/nu11secur1ty/LinuxUserManager?style=social)](https://github.com/nu11secur1ty/LinuxUserManager/stargazers)

---

**Made with ❤️ by the OPS Team**

*"Empowering Linux administrators, one user at a time."*
