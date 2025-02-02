#! /usr/bin/bash
shopt -s extglob


#=========================== Drop Table===========================

function dropTable() {
    echo "This is all the Tables you have created:"
    ls

    files=($(ls))

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found to delete."
        return
    fi

    echo "Choose a Table to delete:"

    select file_name in "${files[@]}" "Cancel"; do
        if [[ $REPLY -le ${#files[@]} && $REPLY -gt 0 ]]; then

            echo "You selected to delete: $file_name"
            rm -r "$file_name"
            rm -r ".$file_name-metadata.txt"
            echo "Table $file_name deleted successfully."
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Deletion canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done

}