#!/bin/bash
logo()
{
	tput clear
    tput cup 0 35
    echo """

		███████╗██╗  ██╗ ██████╗  ██╗ ██████╗ ███╗   ██╗
		██╔════╝██║  ██║██╔═████╗███║██╔═████╗████╗  ██║
		███████╗███████║██║██╔██║╚██║██║██╔██║██╔██╗ ██║
		╚════██║╚════██║████╔╝██║ ██║████╔╝██║██║╚██╗██║
		███████║     ██║╚██████╔╝ ██║╚██████╔╝██║ ╚████║
		╚══════╝     ╚═╝ ╚═════╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
		                                        
    """
    tput sgr0 
}

#filemanagement
create_folder () {
  current_folder=`pwd`
  echo "Enter the new folder name: "  
  read name_folder 
  echo "Enter the path location to create new folder: "  
  read name_path
  check="$name_path/$name_folder"
  echo "$check"
  if [ -d $name_path ]
  then
    if [ ! -d $check ]
    then
      cd $name_path && mkdir $name_folder 
      cd $current_folder
      echo "Folder created successfully"
    else
      echo "Folder exists"
    fi
  else
      echo "Path invalid" 
  fi
}

create_file () {
  current_folder=`pwd`
  echo "Enter the new file name: "  
  read name_file
  echo "Enter the path folder to create new file: "  
  read name_path
  check="$name_path/$name_file"
  echo "$check"
  if [ -d $name_path ]
  then
    if [ ! -f $check ] 
    then
      cd $name_path && sudo touch $name_file
      cd $current_folder
      echo "File created successfully"
    else
      echo "File exists"
    fi
  else
      echo "Path invalid" 
  fi
}

move () {
  echo "Enter file or folder path source need move: "
  read src
  echo "Enter folder destination: "
  read dest
  if [ -d $dest ]
  then
    if [ -f $src ]
    then
      mv $src $dest
      echo "Move successfull"
    elif [ -d $src ]
    then
      mv $src $dest
      echo "Move successfull"      
    else
      echo "Name source invalid"
    fi
  else
      echo "Name dest invalid"
  fi
}

copy () {
  echo "Enter file or folder path source need copy: "
  read src
  echo "Enter folder destination: "
  read dest
  if [ -d $dest ]
  then
    if [ -f $src ]
    then
      cp -R $src $dest
      echo "Copy successfull"
    elif [ -d $src ]
    then
      cp -R $src $dest
      echo "Copy successfull"      
    else
      echo "Name source invalid"
    fi
  else
      echo "Name dest invalid"
  fi
}

find_file_or_folder () {
  echo "Enter name file or folder to find: "
  read name
  sudo updatedb
  a=`locate $name`
  if [ ! -z "$a" ]
  then
    locate $name
  fi
}

permission () {
  echo "0 = -- No permission"
  echo "1 = -x Excute"
  echo "2 = -w- Write"
  echo "3 = -wx Write and excuted"
  echo "4 = r- Read Only"
  echo "5 = r-x Read and Excute"
  echo "6 = rw- Read and Write"
  echo "7 = rwx Read, Write and Excute"
  echo "Type number order for owner only or group or all. Example: type 327 will give write and execute (3) permission for the user, w (2) for the group, and read, write, and (7) execute for all users."
  echo "*******************************"
  echo "Enter file or folder path to delete: "
  read name
  echo "Enter permission"
  read permission
  if [ -f $name ]
  then
    chmod $permission $name
    per=''
    echo "Set permission for file $name successfull"
  elif [ -d $name ]
  then
    chmod $permission $name
    echo "Set permission for folder $name successfull"      
  else
    echo "Name source invalid"
  fi
}

delete () {
  echo "Enter file or folder path to delete: "
  read name
  if [ -f $name ]
  then
    rm -f $name
    echo "Delete file $name successfull"
  elif [ -d $name ]
  then
    rm -d $name
    echo "Delete folder $name successfull"      
  else
    echo "Name source invalid"
  fi
}

filemanagement()
{
	logo
	
	tput bold 
    tput cup 11 32
	echo "FILE MANAGEMENT"
	echo
	tput sgr0
    tput cup 13 28
    echo "1. Create folder"
    tput cup 14 28
    echo "2. Create file"
    tput cup 15 28
    echo "3. Move"
    tput cup 16 28
    echo "4. Copy"
    tput cup 17 28
    echo "5. Find file or folder"
    tput cup 18 28
    echo "6. Permission"
    tput cup 19 28
    echo "7. Delete"
    echo
    
	while :
	do
	  tput bold
	  tput cup 21 28
      read -p "Enter your choice [1-7] : " choice
	  read choice
	  if [ $choice == 1 ]
	  then
		create_folder
	  elif [ $choice == 2 ]
	  then
		create_file

	  elif [ $choice == 3 ]
	  then
		move    
	  elif [ $choice == 4 ]
	  then
		copy
	  elif [ $choice == 5 ]
	  then
		find_file_or_folder
	  elif [ $choice == 6 ]
	  then
		permission
	  elif [ $choice == 7 ]
	  then
		delete
	  fi
	done
}

create_user()
{
	while :
	do
		read -p "Enter user name:" user
		if [id $user &> /etc/null ]
		then
			echo "User already exist...(try again with another name)"
		else
			useradd $user
            if [id $user &> /etc/null]
            then
			    echo "$user created successfully"
            else
                echo "Can't create user"
            fi
			return 0
		fi
	done
}


set_pass()
{
	read -p "enter user_name:" user
	read -p "enter passwords:" password	
	echo  -e "$password\n$password" | passwd $user 
}


view()
{
	users=$(cut -d: -f1 /etc/passwd)
	for user in $users
	do
		echo "User: $user , $(id $user | cut -d " " -f 1)"
	done
}


lock()
{
	while :
	do
		read -p "Enter your user_name to lock password:" user
		if [ -z $user ]
		then
			echo "Username can't be empty, please enter user_name..."
		else
			if id $user &> /etc/null
			then
				passwd -l $user
			        echo "successfully done...."	
				return 0
			else
				echo "provide valid user_name, user $user does not exist"
			fi
		fi
	done
}


backup()
{
	read -p "Enter user_name: " user
	echo "searching for home directory of $user"
	homedir=$(grep ${user}: /etc/passwd | cut -d ":" -f 6)
	echo "Home directory for $user is $homedir "
	echo "creating backup file (.tar).."
	ts=$(date +%F)
	tar -cf ${user}-${ts}.tar $homedir
	echo "$user backup success... "
	return 0
}

usermanagement()
{
	logo
	
    tput bold
    tput cup 11 32
    echo "USER MANAGEMENT"
    echo
    tput sgr0   
    tput cup 13 28
    echo "1. Create new user"  
    tput cup 14 28
    echo "2. Set password "
    tput cup 15 28
    echo "3. Lock Password" 
    tput cup 16 28
    echo "4. Create user backup"  
    tput cup 17 28
    echo "5. View user-id"
    echo
    # Set bold mode
    tput bold
    tput cup 19 28
    read -p "Enter your choice [1-5] : " choice
	case $choice in 
		1) create_user ;;
	    2) set_pass
		   echo "Password successfully updated.....";;
		3) lock ;;
		4) backup ;;
		5) view ;;
		*) echo "invalid input...";;
	esac	
	sleep 10
	clear
}

processmanagement()
{
	#logo
	logo
	
    tput bold 
    tput cup 11 32
	echo "PROCESS MANAGEMENT"
	echo
	tput sgr0
    tput cup 13 18
    echo "1. Show all the running processes of this user"
    tput cup 14 18
    echo "2. Show the PID of a process"
    tput cup 15 18
    echo "3. Terminates running processes with PID"
    tput cup 16 18
    echo "4. Shows the free and used memory (RAM"
    echo 
    # Menu
    tput bold
    tput cup 19 18
    read -p "Enter your options [1-4] : " options
    case $options in
        1) top
        ;;
        2)
        tput cup 20 18
        read -p "Enter name of the process:" name_pro
        pidof $name_pro
        ;;
        3)
        tput cup 20 18
        read -p "Enter PID:" PID_option
        kill $PID_option
        ;;
        4) free -m
    sleep 10
    esac
}

calculator()
{
    _zenity="/usr/bin/zenity"
    _out="/tmp/calculator.$$"
    expression=$(${_zenity} --title  "Enter a complex expression:" \
	             --entry --text "Enter complex expression" )
    res=`echo $expression | bc` 
    echo "Complex expression: $expression"> ${_out}
    echo "Result: $res" >> ${_out}
      # Display back outputs
    ${_zenity} --width=600 --height=400  \
	     --title "Calculator" \
	     --text-info --filename="${_out}"
}

who_is()
{
		_zenity="/usr/bin/zenity"
        _out="/tmp/whois.output.$$"
        domain=$(${_zenity} --title  "Enter domain" \
                        --entry --text "Enter the domain you would like to see whois info" )
        
        if [ $? -eq 0 ]
        then
        # Display a progress dialog while searching whois database
        whois $domain  | tee >(${_zenity} --width=200 --height=100 \
                            --title="whois" --progress \
                                --pulsate --text="Searching domain info..." \
                                            --auto-kill --auto-close \
                                            --percentage=10) >${_out}
        
        # Display back output
        ${_zenity} --width=800 --height=600  \
                --title "Whois info for $domain" \
                --text-info --filename="${_out}"
        else
        ${_zenity} --error \
                --text="No input provided"
        fi
}

backupfile()
{
	while :
	do
	tput clear
	logo
	echo -e "\n\n\n\n"
	echo "Where folder do you want to backup?"
	read backup_files
	if [ -d "$backup_files" ]; then
	  break;
	else
	  echo -e "Incorect directory! Please type again!"
	  sleep 1
	fi
	done
	# Where to backup to.
	dest="/home/sunskul/backup"

	# Create archive filename.
	date=$(date +%m-%d-%y)
	hostname=$(hostname -s)
	archive_file="$hostname-$date.tgz"

	# Print start status message.
	echo -e "Backing up $backup_files to $dest/$archive_file\n$(date)\n"

	# Backup the files using tar.
	tar czf $dest/$archive_file $backup_files

	echo -e "\nYour backup done\n"

	# Options
	echo "Do you want to send it to email [y/N]?"
	while :
	do
	  read INPUT_STRING
	  case $INPUT_STRING in
		y|Y)
			count=0
			echo "Please type your email!"
			while :
			do
			  read EMAIL
			  if [[ "$EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]
			  then
				  echo "Email address $EMAIL is valid."
				  #SEND EMAIL
				  echo -e "Your backup archive is sent to you from $(hostname)\n\nArchive file: $archive_file\nDirectory: $dest\nTime:$(date +%H:%M:%S-%d%m%Y)\n\nThis is automated email from $(hostname) ^^. Thanks!" | mail -s "Backup and Store data from $(hostname)!" -a "$dest/$archive_file" "$EMAIL"
				  echo -e "Your backup archive is sent to $EMAIL!"
				  exit
			  else
				  echo "Email address $EMAIL is invalid."
				  echo "Please type email again!"
				  count=$(($count+1))
				  if [[ $count -ge 3 ]]
				  then
				echo "You was type wrong email more than 3 time!"
				exit
				  fi
			  fi
			done
			;;
		n|N)
			break
			;;
		*)
			echo "Sorry, nh4ttruong don't understand. Please choose again!"
			;;
	  esac
	done
	echo -e "\nBackup and Store checking hihi"
}

stuff()
{
	logo
	 
    tput bold
    tput cup 11 32
    echo "STUFF TOOL"
    echo
    tput sgr0 
    tput cup 13 28
    echo "1. Whois Tool"
    tput cup 14 28
    echo "2. Calculator"
    tput cup 15 28
    echo "3. Backup and Archive"
    echo 
    # Menu
    tput bold
    tput cup 17 28
    read -p "Enter your options [1-3] : " options
    case $options in	
        1)
        who_is
        ;;
        2)
        calculator
        ;;
        3)
        backupfile
        ;;
    esac
    sleep 10
}

#disk checking
diskchecking()
{
	#set color
	echo -e "Status Device Size"; tput sgr0

	#set forecolor
	echo -n $(tput setaf 3)

	#add info to file
	path="/home/sunskul/NT132/$(date +%H%M%S-%d%m%Y)-LogDisk.txt"
	echo -e "Log Check Disk - $(hostname) - $(date)\n" > "$path"

	#Find disk space using disk filesystem - df
	df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 " " $2}' | while read output;
	do
	  echo $output
	  used=$(echo $output | awk '{ print $1 }' | cut -d'%' -f1 )
	  partition=$(echo $output | awk '{ print $2 }' )
	  if [ $used -ge 90 ]
	  then
		status="$partition is running out of space with \"($used%)\" on user $(hostname)"
		echo "$status" >> "$path"
	  fi
	done

	#email send
	echo -e "\nThis is automated email from $(hostname)!" >> "$path"

	cat $path | mail -s "Linux: Emergency alert of your disk space!" "[***gmail***]"
	tput bold; tput setaf 7; echo -e "\nEmail is sent!"
	sleep 10
}

while true
do
# clear the screen
    logo
    
    tput bold
    tput cup 11 32
    # Set reverse video mode
    echo "M A I N - M E N U"
    echo
    tput sgr0   
    tput cup 13 28
    echo "1. File Management"  
    tput cup 14 28
    echo "2. User Management"  
    tput cup 15 28
    echo "3. Disk Checking"
    tput cup 16 28
    echo "4. Process Management" 
    tput cup 17 28
    echo "5. Stuff"  
echo
    # Set bold mode
    tput bold
    tput cup 19 27
    read -p "Enter your choice [1-5] : " choice
    
    #echo $choice
    if [ $choice -eq 1 ]
    then
        filemanagement
    elif [ $choice -eq 2 ]
    then
        usermanagement
    elif [ $choice -eq 3 ]
    then
    	#disk checking and alert
        diskchecking
    elif [ $choice -eq 4 ]
    then
        processmanagement
    elif [ $choice -eq 5 ]
    then
        stuff
    fi
done
