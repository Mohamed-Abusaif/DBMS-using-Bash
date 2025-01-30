######### Bash Project 
#! /usr/bin/bash
shopt -s extglob


############################ Functions ########################################
#=========================== Create DB===========================
function createDb(){
	read -p "Please Enter Your Database Name: " DBNAME 
	if [[ -e  $DBNAME ]]
	then 
	    echo "Database $DBNAME alreadt exist"	
	else 
	  mkdir "$DBNAME"
          echo "Database $DBNAME Created Succsesfully" 	
	fi
}

#=========================== list DB===========================
function listDb(){
        echo "This is all DB You Created"
	ls 
}

#=========================== choose DB===========================
function chooseDb(){
    echo "This is all the DB you have created:"
    ls

    ## i will put all the list result inside array folder named folders
    folders=($(ls))

    ## here ana will check if there is no DB or there is no DB  
    if [ ${#folders[@]} -eq 0 ]; then
        echo "No DB found ."
        return
    fi

    ## hna haDisplay menu
    echo "Choose a DB to Acess:"
    select folder_name in "${folders[@]}" "Cancel"; do
        if [[ $REPLY -le ${#folders[@]} && $REPLY -gt 0 ]]; then
            # cd the selected DB
            echo "You selected : $folder_name"
            cd "$folder_name"
            echo "we are in DB $folder_name  now."
            break
        elif [[ $REPLY -eq $((${#folders[@]} + 1)) ]]; then
            echo "Operation canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}

#=========================== Drop DB===========================
function dropDb(){
    echo "This is all the folders you have created:"
    ls

    ## i will put all the list result inside array folder named folders
    folders=($(ls))

    ## here ana will check if there is no DB to delete or there is no DB  
    if [ ${#folders[@]} -eq 0 ]; then
        echo "No folders found to delete."
        return
    fi

    ## hna haDisplay menu
    echo "Choose a folder to delete:"
    select folder_name in "${folders[@]}" "Cancel"; do
        if [[ $REPLY -le ${#folders[@]} && $REPLY -gt 0 ]]; then
            # Delete the selected folder
            echo "You selected to delete: $folder_name"
            rm -r "$folder_name"
            echo "Folder $folder_name deleted successfully."
            break
        elif [[ $REPLY -eq $((${#folders[@]} + 1)) ]]; then
            echo "Deletion canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}


#=========================== Sub Menu ===========================
function showSubMenu(){
select choice in CreateTable ListTable DropTable InsertIntoTable SelectFromTable DeleteFromTable  UpdateTable  exit
do
  case $choice in 
"CreateTable")
             	echo Create Table
	;;
"ListTable")
        echo List Table
	;;
"DropTable")
	echo Drop Table
	;;
"InsertIntoTable")
	echo Insert into Table
	;;
"SelectFromTable")
	echo Select into Table
	;;
"DeleteFromTable")
	echo Delete from Table
	;;
"UpdateTable")
	echo Update from Table
	;;
"exit")
        cd ..
        echo now You exit the sub menu 
	break
	;;
*)
	echo Invalid option. Please try again
esac
  
done 
        
}


###################################################################




################################################ Main Code ######################################################################################

################## check Existence####################

if [[ -e  ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases ]]  #/home/gohaar/Desktop/Bash_Proj/DBMS-using-Bash
then 
    cd   ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
    echo Database is Ready to connect
else 
    mkdir ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
    cd   ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
fi

###########################################################

select choice in CreateDB ListDB ConnectDB DropDB exit
do
  case $choice in 
"CreateDB")
             createDb
            # result=$?
            # echo $result
	;;
"ListDB")
        listDb
	;;
"ConnectDB")
         chooseDb
  	showSubMenu
	;;
"DropDB")
	dropDb
	;;
"exit")  
	break
	;;
*)
	echo Invalid option. Please try again
esac

  
done 

##############################################################












