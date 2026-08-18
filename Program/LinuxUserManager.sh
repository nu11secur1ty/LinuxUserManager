#!/usr/bin/bash
#=====================================================================
# User Manager Pro v3.0 by OPS Team
# Author: System Admin Team
# Version: 3.0
# Compatible with: Ubuntu 22.04/24.04, Debian 12, RHEL 9, Fedora
#=====================================================================

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}This script must be run as root!${NC}"
    echo -e "${YELLOW}Please use: sudo $0${NC}"
    exit 1
fi

# Function to display header
show_header() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║      ██╗   ██╗███████╗███████╗██████╗                        ║"
    echo "║      ██║   ██║██╔════╝██╔════╝██╔══██╗                       ║"
    echo "║      ██║   ██║███████╗███████╗██████╔╝                       ║"
    echo "║      ██║   ██║╚════██║╚════██║██╔══██╗                       ║"
    echo "║      ╚██████╔╝███████║███████║██║  ██║                       ║"
    echo "║       ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝                       ║"
    echo "║                                                              ║"
    echo "║              USER MANAGER PRO v3.0                           ║"
    echo "║         System Administration Tool                           ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check if user exists
user_exists() {
    id "$1" &>/dev/null
    return $?
}

# Function to check if group exists
group_exists() {
    getent group "$1" &>/dev/null
    return $?
}

# Function to list all users
list_users() {
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║        SYSTEM USERS LIST             ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Username    | UID    | Home Directory        | Shell${NC}"
    echo -e "${YELLOW}────────────────────────────────────────────────────${NC}"
    awk -F: '{ printf "%-12s| %-6s | %-20s | %s\n", $1, $3, $6, $7 }' /etc/passwd | grep -v "/usr/sbin/nologin" | grep -v "/bin/false" | head -20
    echo ""
}

# Function to list all groups
list_groups() {
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║        SYSTEM GROUPS LIST            ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}Group Name    | GID    | Members${NC}"
    echo -e "${YELLOW}────────────────────────────────────────────${NC}"
    getent group | awk -F: '{ printf "%-12s | %-6s | %s\n", $1, $3, $4 }' | head -20
    echo ""
}

# Function to create user with all options
create_user_full() {
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║          CREATE USER - FULL OPTIONS                   ║${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${GREEN}Enter username: ${NC}"
    read username
    
    if user_exists "$username"; then
        echo -e "${RED}ERROR: User '$username' already exists!${NC}"
        return 1
    fi
    
    # User ID
    echo -e "${GREEN}Enter UID (leave empty for auto): ${NC}"
    read uid
    if [[ -n "$uid" ]]; then
        if [[ ! "$uid" =~ ^[0-9]+$ ]] || [[ "$uid" -lt 1000 ]]; then
            echo -e "${RED}ERROR: UID must be a number >= 1000!${NC}"
            return 1
        fi
        UID_OPT="-u $uid"
    else
        UID_OPT=""
    fi
    
    # Home directory
    echo -e "${GREEN}Enter home directory (default: /home/$username): ${NC}"
    read homedir
    if [[ -z "$homedir" ]]; then
        HOMEDIR="/home/$username"
    else
        HOMEDIR="$homedir"
    fi
    
    # Create home directory option
    echo -e "${GREEN}Create home directory? (y/n): ${NC}"
    read create_home
    if [[ "$create_home" == "y" || "$create_home" == "Y" ]]; then
        HOME_OPT="-d $HOMEDIR -m"
    else
        HOME_OPT="-d $HOMEDIR -M"
    fi
    
    # Shell
    echo -e "${CYAN}Available shells:${NC}"
    echo "1) /bin/bash"
    echo "2) /bin/sh"
    echo "3) /bin/zsh"
    echo "4) /usr/bin/fish"
    echo "5) /sbin/nologin (no login)"
    echo -e "${GREEN}Select shell (1-5, default 1): ${NC}"
    read shell_choice
    case $shell_choice in
        2) SHELL="/bin/sh" ;;
        3) SHELL="/bin/zsh" ;;
        4) SHELL="/usr/bin/fish" ;;
        5) SHELL="/sbin/nologin" ;;
        *) SHELL="/bin/bash" ;;
    esac
    
    # Primary group
    echo -e "${GREEN}Enter primary group (default: same as username): ${NC}"
    read primary_group
    if [[ -n "$primary_group" ]]; then
        if ! group_exists "$primary_group"; then
            echo -e "${YELLOW}Group '$primary_group' does not exist. Creating...${NC}"
            groupadd "$primary_group"
        fi
        GROUP_OPT="-g $primary_group"
    else
        GROUP_OPT=""
    fi
    
    # Additional groups
    echo -e "${GREEN}Enter additional groups (comma-separated, e.g., sudo,docker): ${NC}"
    read additional_groups
    if [[ -n "$additional_groups" ]]; then
        GROUPS_OPT="-G $additional_groups"
    else
        GROUPS_OPT=""
    fi
    
    # Comment / Full name
    echo -e "${GREEN}Enter full name / comment (optional): ${NC}"
    read comment
    if [[ -n "$comment" ]]; then
        COMMENT_OPT="-c \"$comment\""
    else
        COMMENT_OPT=""
    fi
    
    # Expiry date
    echo -e "${GREEN}Enter expiry date (YYYY-MM-DD, leave empty for none): ${NC}"
    read expiry
    if [[ -n "$expiry" ]]; then
        EXPIRY_OPT="-e $expiry"
    else
        EXPIRY_OPT=""
    fi
    
    # Password
    echo -e "${GREEN}Enter password: ${NC}"
    read -s password
    echo ""
    echo -e "${GREEN}Confirm password: ${NC}"
    read -s password_confirm
    echo ""
    
    if [[ "$password" != "$password_confirm" ]]; then
        echo -e "${RED}ERROR: Passwords do not match!${NC}"
        return 1
    fi
    
    # Build and execute command
    CMD="useradd $UID_OPT $HOME_OPT -s $SHELL $GROUP_OPT $GROUPS_OPT $COMMENT_OPT $EXPIRY_OPT $username"
    echo -e "${YELLOW}Executing: $CMD${NC}"
    eval $CMD
    
    if [[ $? -eq 0 ]]; then
        # Set password
        echo "$username:$password" | chpasswd
        echo -e "${GREEN}✓ User '$username' created successfully!${NC}"
        echo -e "${CYAN}User details:${NC}"
        echo -e "  Username: $username"
        echo -e "  UID: $(id -u $username)"
        echo -e "  Home: $HOMEDIR"
        echo -e "  Shell: $SHELL"
        echo -e "  Groups: $(id -Gn $username)"
    else
        echo -e "${RED}✗ Failed to create user!${NC}"
        return 1
    fi
}

# Function to create user (simple)
create_user_simple() {
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}${BOLD}║          CREATE USER - SIMPLE                        ║${NC}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${GREEN}Enter username: ${NC}"
    read username
    
    if user_exists "$username"; then
        echo -e "${RED}ERROR: User '$username' already exists!${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Enter password: ${NC}"
    read -s password
    echo ""
    echo -e "${GREEN}Confirm password: ${NC}"
    read -s password_confirm
    echo ""
    
    if [[ "$password" != "$password_confirm" ]]; then
        echo -e "${RED}ERROR: Passwords do not match!${NC}"
        return 1
    fi
    
    # Create user with home directory
    useradd -m -s /bin/bash "$username"
    
    if [[ $? -eq 0 ]]; then
        echo "$username:$password" | chpasswd
        echo -e "${GREEN}✓ User '$username' created successfully!${NC}"
        echo -e "${CYAN}User details:${NC}"
        echo -e "  Username: $username"
        echo -e "  Home: /home/$username"
        echo -e "  Shell: /bin/bash"
    else
        echo -e "${RED}✗ Failed to create user!${NC}"
        return 1
    fi
}

# Function to delete user
delete_user() {
    echo -e "${RED}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}${BOLD}║          DELETE USER                                ║${NC}"
    echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    
    list_users
    echo ""
    echo -e "${GREEN}Enter username to delete: ${NC}"
    read username
    
    if ! user_exists "$username"; then
        echo -e "${RED}ERROR: User '$username' does not exist!${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}WARNING: You are about to delete user '$username'${NC}"
    echo -e "${RED}Remove home directory and mail spool? (y/n): ${NC}"
    read remove_home
    
    echo -e "${RED}Are you sure you want to delete this user? (y/n): ${NC}"
    read confirm
    
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}Operation cancelled.${NC}"
        return 0
    fi
    
    if [[ "$remove_home" == "y" || "$remove_home" == "Y" ]]; then
        userdel -r "$username"
        echo -e "${GREEN}✓ User '$username' deleted with home directory and mail spool.${NC}"
    else
        userdel "$username"
        echo -e "${GREEN}✓ User '$username' deleted (home directory preserved).${NC}"
    fi
}

# Function to manage groups
manage_groups() {
    echo -e "${MAGENTA}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}${BOLD}║          GROUP MANAGEMENT                           ║${NC}"
    echo -e "${MAGENTA}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    
    echo "1) Create group"
    echo "2) Delete group"
    echo "3) Add user to group"
    echo "4) Remove user from group"
    echo "5) List groups"
    echo "6) Back to main menu"
    
    echo -e "${GREEN}Select option (1-6): ${NC}"
    read group_opt
    
    case $group_opt in
        1)
            echo -e "${GREEN}Enter group name: ${NC}"
            read groupname
            if group_exists "$groupname"; then
                echo -e "${RED}ERROR: Group '$groupname' already exists!${NC}"
                return 1
            fi
            echo -e "${GREEN}Enter GID (leave empty for auto): ${NC}"
            read gid
            if [[ -n "$gid" ]]; then
                groupadd -g "$gid" "$groupname"
            else
                groupadd "$groupname"
            fi
            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}✓ Group '$groupname' created successfully!${NC}"
            else
                echo -e "${RED}✗ Failed to create group!${NC}"
            fi
            ;;
        2)
            echo -e "${GREEN}Enter group name to delete: ${NC}"
            read groupname
            if ! group_exists "$groupname"; then
                echo -e "${RED}ERROR: Group '$groupname' does not exist!${NC}"
                return 1
            fi
            groupdel "$groupname"
            echo -e "${GREEN}✓ Group '$groupname' deleted.${NC}"
            ;;
        3)
            echo -e "${GREEN}Enter username: ${NC}"
            read username
            if ! user_exists "$username"; then
                echo -e "${RED}ERROR: User '$username' does not exist!${NC}"
                return 1
            fi
            echo -e "${GREEN}Enter group name: ${NC}"
            read groupname
            if ! group_exists "$groupname"; then
                echo -e "${RED}ERROR: Group '$groupname' does not exist!${NC}"
                return 1
            fi
            usermod -a -G "$groupname" "$username"
            echo -e "${GREEN}✓ User '$username' added to group '$groupname'.${NC}"
            ;;
        4)
            echo -e "${GREEN}Enter username: ${NC}"
            read username
            if ! user_exists "$username"; then
                echo -e "${RED}ERROR: User '$username' does not exist!${NC}"
                return 1
            fi
            echo -e "${GREEN}Enter group name: ${NC}"
            read groupname
            if ! group_exists "$groupname"; then
                echo -e "${RED}ERROR: Group '$groupname' does not exist!${NC}"
                return 1
            fi
            gpasswd -d "$username" "$groupname"
            echo -e "${GREEN}✓ User '$username' removed from group '$groupname'.${NC}"
            ;;
        5)
            list_groups
            ;;
        6)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            ;;
    esac
}

# Function to modify user
modify_user() {
    echo -e "${YELLOW}${BOLD}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}${BOLD}║          MODIFY USER                               ║${NC}"
    echo -e "${YELLOW}${BOLD}╚═══════════════════════════════════════════════════════╝${NC}"
    
    list_users
    echo ""
    echo -e "${GREEN}Enter username to modify: ${NC}"
    read username
    
    if ! user_exists "$username"; then
        echo -e "${RED}ERROR: User '$username' does not exist!${NC}"
        return 1
    fi
    
    echo -e "${CYAN}Current user info:${NC}"
    id "$username"
    echo ""
    
    echo "1) Change UID"
    echo "2) Change primary group (GID)"
    echo "3) Change home directory"
    echo "4) Change shell"
    echo "5) Change full name/comment"
    echo "6) Lock account"
    echo "7) Unlock account"
    echo "8) Change password"
    echo "9) Set account expiry"
    echo "10) Back to main menu"
    
    echo -e "${GREEN}Select option (1-10): ${NC}"
    read mod_opt
    
    case $mod_opt in
        1)
            echo -e "${GREEN}Enter new UID: ${NC}"
            read new_uid
            if [[ ! "$new_uid" =~ ^[0-9]+$ ]] || [[ "$new_uid" -lt 1000 ]]; then
                echo -e "${RED}ERROR: UID must be a number >= 1000!${NC}"
                return 1
            fi
            usermod -u "$new_uid" "$username"
            echo -e "${GREEN}✓ UID changed to $new_uid${NC}"
            ;;
        2)
            echo -e "${GREEN}Enter new primary group name: ${NC}"
            read new_group
            if ! group_exists "$new_group"; then
                echo -e "${RED}ERROR: Group '$new_group' does not exist!${NC}"
                return 1
            fi
            usermod -g "$new_group" "$username"
            echo -e "${GREEN}✓ Primary group changed to '$new_group'${NC}"
            ;;
        3)
            echo -e "${GREEN}Enter new home directory: ${NC}"
            read new_home
            usermod -d "$new_home" "$username"
            echo -e "${GREEN}✓ Home directory changed to $new_home${NC}"
            ;;
        4)
            echo -e "${CYAN}Available shells:${NC}"
            echo "1) /bin/bash"
            echo "2) /bin/sh"
            echo "3) /bin/zsh"
            echo "4) /usr/bin/fish"
            echo "5) /sbin/nologin"
            echo -e "${GREEN}Select shell (1-5): ${NC}"
            read shell_choice
            case $shell_choice in
                2) new_shell="/bin/sh" ;;
                3) new_shell="/bin/zsh" ;;
                4) new_shell="/usr/bin/fish" ;;
                5) new_shell="/sbin/nologin" ;;
                *) new_shell="/bin/bash" ;;
            esac
            usermod -s "$new_shell" "$username"
            echo -e "${GREEN}✓ Shell changed to $new_shell${NC}"
            ;;
        5)
            echo -e "${GREEN}Enter new full name/comment: ${NC}"
            read new_comment
            usermod -c "$new_comment" "$username"
            echo -e "${GREEN}✓ Comment changed to '$new_comment'${NC}"
            ;;
        6)
            usermod -L "$username"
            echo -e "${YELLOW}✓ Account '$username' locked.${NC}"
            ;;
        7)
            usermod -U "$username"
            echo -e "${GREEN}✓ Account '$username' unlocked.${NC}"
            ;;
        8)
            passwd "$username"
            ;;
        9)
            echo -e "${GREEN}Enter expiry date (YYYY-MM-DD): ${NC}"
            read exp_date
            usermod -e "$exp_date" "$username"
            echo -e "${GREEN}✓ Expiry date set to $exp_date${NC}"
            ;;
        10)
            return 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            ;;
    esac
}

# Main menu
while true; do
    show_header
    echo -e "${BOLD}${WHITE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${WHITE}║                    MAIN MENU                              ║${NC}"
    echo -e "${BOLD}${WHITE}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}${WHITE}║                                                           ║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}1)${NC} Create User - Full Options                            ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}2)${NC} Create User - Simple                                  ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}3)${NC} Delete User                                           ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}4)${NC} Modify User                                           ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}5)${NC} Group Management                                      ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}6)${NC} List All Users                                        ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}7)${NC} List All Groups                                       ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}8)${NC} Show User Info                                        ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${GREEN}9)${NC} Show Logged-in Users                                  ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║  ${RED}0)${NC} Exit                                                   ${WHITE}║${NC}"
    echo -e "${BOLD}${WHITE}║                                                           ║${NC}"
    echo -e "${BOLD}${WHITE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Enter your choice: ${NC}"
    read choice
    
    case $choice in
        1) create_user_full ;;
        2) create_user_simple ;;
        3) delete_user ;;
        4) modify_user ;;
        5) manage_groups ;;
        6) list_users ;;
        7) list_groups ;;
        8)
            echo -e "${GREEN}Enter username: ${NC}"
            read username
            if user_exists "$username"; then
                echo -e "${CYAN}User info for '$username':${NC}"
                id "$username"
                echo -e "${CYAN}Groups:${NC} $(id -Gn $username)"
                echo -e "${CYAN}Home:${NC} $(eval echo ~$username)"
                echo -e "${CYAN}Shell:${NC} $(getent passwd $username | cut -d: -f7)"
                echo -e "${CYAN}Account expiry:${NC} $(chage -l $username | grep "Account expires" | cut -d: -f2)"
            else
                echo -e "${RED}User '$username' does not exist!${NC}"
            fi
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read
            ;;
        9)
            echo -e "${CYAN}Currently logged-in users:${NC}"
            echo -e "${YELLOW}────────────────────────────────────────────${NC}"
            who
            echo ""
            echo -e "${CYAN}Last logins:${NC}"
            last -n 5
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read
            ;;
        0)
            echo -e "${GREEN}${BOLD}Thank you for using User Manager Pro!${NC}"
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please try again.${NC}"
            sleep 2
            ;;
    esac
done
