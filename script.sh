######### Bash Project 
#! /usr/bin/bash
shopt -s extglob

source ~/Desktop/Bash_Proj/DBMS-using-Bash/myFunc.sh

############################ Functions ########################################
#=========================== Create DB===========================
: '
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
'
#=========================== Create DB__2===========================
function createDb() {
    while true; do
        read -p "Please Enter Your Database Name: " DBNAME

        # Validation 1
        if [[ -z "$DBNAME" ]]; then
            echo "Error: Database name cannot be empty. Please try again."
            continue
        fi

        # Validation 2
        if [[ ! "$DBNAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "Error: Database name can only contain letters, numbers, and underscores, must start with a letter"
            continue
        fi

        # Validation 3
        if [[ ${#DBNAME} -gt 15 ]]; then
            echo "Error: Database name cannot exceed 64 characters. Please try again."
            continue
        fi

        # Validation 4
        if [[ -e "$DBNAME" ]]; then
            echo "Error: Database '$DBNAME' already exists. Please choose a different name."
            continue
        fi

        # validations pass
        mkdir "$DBNAME"
        echo "Database '$DBNAME' created successfully."
        break
    done
}

#=========================== list DB===========================
function listDb(){
        echo "This is all DB You Created"
	ls 
}

#=========================================Choose DB ======================================================
function chooseDb() {
    echo "This is all the DB you have created:"
    ls

    ## i put all DB  into an array 
    #folders=($(ls))
      folders=($(ls -d */ 2>/dev/null))

    ## Check if there are no databases
    if [ ${#folders[@]} -eq 0 ]; then
        echo "No DB found."
        return
    fi

    ## Display menu
    echo "Choose a DB to Access:"
    select folder_name in "${folders[@]}" "Cancel"; do
        ## Validate 1
        if [[ $REPLY =~ ^[0-9]+$ ]]; then
            if [[ $REPLY -le ${#folders[@]} && $REPLY -gt 0 ]]; then
                ## Validate 2 Check if the selected directory exists and is accessible
                if [[ -d "$folder_name" ]]; then
                    echo "You selected: $folder_name"
                    cd "$folder_name"
                    echo "We are in DB $folder_name now."
                    showSubMenu  #============================= Call the submenu to display here
                    break
                else
                    echo "Error: The selected DB '$folder_name' does not exist or is inaccessible."
                fi
            elif [[ $REPLY -eq $((${#folders[@]} + 1)) ]]; then
                echo "Operation canceled."
                break
            else
                echo "Invalid option. Please try again."
            fi
        else
            echo "Error: Please enter a valid number."
        fi
    done
}


#========================== DropDB ============================================================
function dropDb() {
    echo "This is all the DB you have created:"
    ls

    ## i will put all the list result inside array folder named folders
    folders=($(ls))

    ## here ana will check if there is no DB to delete or there is no DB  
    if [ ${#folders[@]} -eq 0 ]; then
        echo "No DB found to delete."
        return
    fi

    ## hna haDisplay menu
    echo "Choose a DB to delete:"
    select folder_name in "${folders[@]}" "Cancel"; do
        case $REPLY in
            ## Valid 1 to number of DB the Normal Case
            [1-9]|[1-9][0-9])
                if [[ $REPLY -le ${#folders[@]} && $REPLY -gt 0 ]]; then
                    ## Check if the folder exists
                    if [[ -d "$folder_name" ]]; then
                        ## Confirm deletion
                        read -p "Are you sure you want to delete '$folder_name'? (y/n): " confirm
                        if [[ $confirm =~ ^[yY](es)?$ ]]; then
                            ## try to delete the folder
                            if rm -r "$folder_name"; then
                                echo "DB '$folder_name' deleted successfully."
                            else
                                echo "Error: Failed to delete '$folder_name'."
                            fi
                        else
                            echo "Deletion canceled."
                        fi
                        break
                    else
                        echo "Error: The DtaBase '$folder_name' does not exist."
                    fi
                else
                    echo "Invalid option. Please try again."
                fi
                ;;

            ## Cancel 
            $((${#folders[@]} + 1)))
                echo "Deletion canceled."
                break
                ;;

            ## Invalids non numbers  or arkam tanya
            *)
                echo "Error! Please enter a valid number"
                ;;
        esac
    done
}
#=========================== Sub Menu ===========================
function showSubMenu(){
select choice in CreateTable ListTable DropTable InsertIntoTable SelectFromTable DeleteFromTable  UpdateTable  exit
do
  case $choice in 
"CreateTable")
             	createTable
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
  #	showSubMenu
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












