######### Bash Project
#! /usr/bin/bash
shopt -s extglob

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'

# Define background colors
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_MAGENTA='\e[45m'
BG_CYAN='\e[46m'
BG_WHITE='\e[47m'

# Text attributes
BOLD='\e[1m'
UNDERLINE='\e[4m'
RESET='\e[0m' # Reset to default

source ./myFunc.sh

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
            echo -e "${RED} Error: Database name cannot be empty. Please try again. ${RESET} "
            continue
        fi

        # Validation 2
        if [[ ! "$DBNAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo -e "${RED} Error: Database name can only contain letters, numbers, and underscores, must start with a letter ${RESET}"
            continue
        fi

        # Validation 3
        if [[ ${#DBNAME} -gt 15 ]]; then
            echo -e " ${RED}Error: Database name cannot exceed 64 characters. Please try again. ${RESET} "
            continue
        fi

        # Validation 4
        if [[ -e "$DBNAME" ]]; then
            echo -e "${RED} Error: Database '$DBNAME' already exists. Please choose a different name. ${RESET}"
            continue
        fi

        # validations pass
        mkdir "$DBNAME"
        echo "Database '$DBNAME' created successfully."
        break
    done
}
#=========================== list DB===========================
function listDb() {
    echo -e "${GREEN} This is all DB You Created ${RESET} "
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
        echo -e "${RED}No DB found.${RESET} "
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
                    showSubMenu #============================= Call the submenu to display here
                    break
                else
                    echo "Error: The selected DB '$folder_name' does not exist or is inaccessible."
                fi
            elif [[ $REPLY -eq $((${#folders[@]} + 1)) ]]; then
                echo "Operation canceled."
                break
            else
                echo -e "${RED} Invalid option. Please try again ${RESET} "
            fi
        else
            echo -e "${RED} Error: Please enter a valid number. ${RESET} "
        fi
    done
}

#========================== DropDB ============================================================
function dropDb() {
    echo -e "${BLUE} This is all the DB you have created: ${RESET} "
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
        [1-9] | [1-9][0-9])
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
            echo -e "${RED} Invalid option. Please try again ${RESET}"
            ;;
        esac
    done
}
#=========================== Sub Menu ===========================
function showSubMenu() {
    select choice in CreateTable ListTable DropTable InsertIntoTable SelectFromTable DeleteFromTable UpdateTable exit; do
        case $choice in
        "CreateTable")
            createTable
            ;;
        "ListTable")
            listAllTableData
            ;;
        "DropTable")
            dropTable
            ;;
        "InsertIntoTable")
            insertIntoTable
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
            echo -e "${RED} Invalid option. Please try again ${RESET}"
            ;;
        esac

    done

}

###################################################################

################################################ Main Code ######################################################################################

################## check Existence####################
echo -e "${BOLD}${YELLOW}========================================== ${RESET}"
echo "Welcome to Our DBMS"
echo -e "${BOLD}${YELLOW}========================================== ${RESET}"

if [[ -e ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases ]]; then #/home/gohaar/Desktop/Bash_Proj/DBMS-using-Bash
    cd ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
    echo -e "${BG_GREEN} Database is Ready to connect ${RESET}"
else
    mkdir ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
    echo -e "${BG_GREEN} Database is Created and Ready to connect ${RESET}"
    cd ~/Desktop/Bash_Proj/DBMS-using-Bash/Databases
fi

###########################################################

select choice in CreateDB ListDB ConnectDB DropDB exit; do
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
        echo -e "${RED} Invalid option. Please try again "
        ;;
    esac

done

##############################################################
