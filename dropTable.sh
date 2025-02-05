#! /usr/bin/bash
shopt -s extglob


#=========================== Drop Table===========================

function dropTable() {
   echo -e "\e[34mThis is all the tables you have created:\e[0m"

    # Get a list of table files (excluding metadata files)
#    tables=($(ls))
    tables=($(find . -maxdepth 1 -type f ! -name '*-metadata' -printf "%f\n"))


    # Check if no tables exist
    if [[ ${#tables[@]} -eq 0 ]]; then
        echo -e "\e[33mNo tables found to delete.\e[0m"
        return
    fi

    # Display a menu for table selection
    echo -e "\e[32mChoose a table to delete:\e[0m"
    select tableName in "${tables[@]}" "Cancel"; do
        case $tableName in
            "Cancel")
                echo -e "\e[33mTable deletion canceled.\e[0m"
                return
                ;;
            "")
                echo -e "\e[31mInvalid selection. Please try again.\e[0m"
                ;;
            *)
                # Confirm before deletion
                read -p "Are you sure you want to delete '$tableName'? (y/n): " confirm
                if [[ $confirm =~ ^[yY](es)?$ ]]; then
                    rm "$tableName" "$tableName-metadata" 2>/dev/null
                    echo -e "\e[32mTable '$tableName' has been dropped successfully.\e[0m"
                else
                    echo -e "\e[33mTable deletion canceled.\e[0m"
                fi
                return
                ;;
        esac
    done
}
