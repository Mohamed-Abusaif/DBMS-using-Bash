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

source ./crud.sh
source ./createTable.sh
source ./dropTable.sh
source ./createDb
source ./listDb
source ./dropDb
source ./SelectTB
source ./check_Existence


################################### Functions ############################################


#=========================================Choose DB ======================================================
function chooseDb() {
    clear
    echo -e "${BG_MAGENTA} This is all the DB you have created: ${RESET}"
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
    echo -e "${BLUE}Choose a DB to Access: ${RESET}"
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



#======================================================================================
#=========================== Sub Menu ===========================
function showSubMenu() {
    clear
echo -e "${BOLD}${YELLOW}========================================== ${RESET}"
echo -e "${BOLD}${BLUE}Welcome to TaBle Menu of This DB  ${RESET}"

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
            SelectTB
            ;;
        "DeleteFromTable")
            echo "Delete from Table"
            ;;
        "UpdateTable")
            echo "Update from Table"
            ;;
        "exit")
            cd ..
            echo -e "${RED} Exiting the Database ${RESET}"
            break
            ;;
        *)
            echo -e "${RED} Invalid option. Please try again ${RESET}"
            ;;
        esac
    done
}

###################################################################
##---------------------------------- MainMenu -----------------------------------------------

MainMenu(){
  while true ;
  do
  echo -e "${BOLD}${YELLOW}========================================== ${RESET}"
echo "Welcome to Our DBMS"
echo -e "${BOLD}${YELLOW}========================================== ${RESET}"

select choice in CreateDB ListDB ConnectDB DropDB exit; do
    case $choice in
    "CreateDB")
        createDb
        # result=$?
        # echo $result
          break
        ;;
    "ListDB")
        listDb
          break
        ;;
    "ConnectDB")
        chooseDb
        #	showSubMenu
          break
        ;;
    "DropDB")
        dropDb
          break
        ;;
    "exit")
        echo -e "${RED}Exiting the script. Goodbye!${RESET}"
        exit 0  # Exits the script completely
        break
        ;;
    *)
        echo -e "${RED} Invalid option. Please try again ${RESET} "
          break
        ;;
    esac
done
done 
}

##############################################################
################################################ MainCode #################################################################
#------------- this the calling of our main Code -----------------

check_Existence
MainMenu

