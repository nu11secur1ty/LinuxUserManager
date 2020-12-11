#!/usr/bin/bash
# usermanaget 0.01 by nu11secur1ty
# Menu

PS3='Please enter your choice: '
options=("Creating of users and groups" "Move user to group" "Delete user and group" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Creating of users and groups")
           
	 	echo -e "\e[31mCreate your new user without home directory, give the name...\e[0m"
        	read new_user
                useradd -M $new_user
       	 		echo""
		echo -e "\e[31mCreate your new group for your new user, give the name...\e[0m"
        	read new_group
                groupadd $new_group
        		echo""
		echo -e "\e[31mMove your new user to your new group by giving as the name of your new group...\e[0m"
        	read move
                usermod -a -G $move $new_user
		echo -e "\e[31mDone, now you can see your new user, where is he...\e[0m"
                cat /etc/group | grep $new_user
             
            ;;
        "Move user to group")
            
            ;;
        "Delete user and group")
            
            ;;
        "Quit")
            exit 0
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
