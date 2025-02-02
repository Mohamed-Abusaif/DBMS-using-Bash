#! /usr/bin/bash
shopt -s extglob

#=========================== Create Table===========================

#table is a file inside the directory
function createTable() {

    read -p "Please Enter Your Table Name: " TableName
    if [[ -e $TableName ]]; then
        echo "Table $TableName exists"
    else
        touch "$TableName.txt"
        touch ".$TableName-metadata.txt"
        echo "Table $TableName Created Successfully"
    fi

    read -p "Please Enter Number of Columns: " NumberOfColumns
    for ((i = 1; i <= NumberOfColumns; i++)); do
        read -p "Please Enter Column Name $i: " ColumnName
        read -p "Please Enter Column Data Type(int/string) $i: " ColumnDataType
        echo -n "$ColumnName:" >>"$TableName.txt"
        echo -n "$ColumnName:" >>".$TableName-metadata.txt"
        echo "$ColumnDataType" >>".$TableName-metadata.txt"
    done
    echo "Table $TableName Created Successfully"

}

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
#=========================== Insert Into Table ===========================

# insert Data into table
function insertIntoTable() {
    echo "This is all the Tables you have created:"
    ls

    files=($(ls))

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found to insert into."
        return
    fi

    echo "Choose a Table to insert into:"
    select file_name in "${files[@]}" "Cancel"; do
        if [[ $REPLY -le ${#files[@]} && $REPLY -gt 0 ]]; then
            echo "You selected to insert into: $file_name"
            read -p "Please Enter ID: " ID
            read -p "Please Enter Data: " DATA
            echo -e "$ID:$DATA" >> $file_name
            echo "Data inserted successfully."
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Insertion canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}
#=========================== Delete From Table ===========================

function deleteFromTable() {
    echo "This is all the Tables you have created:"
    ls

    files=($(ls))

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found to delete."
        return
    fi

    echo "Choose a Table to delete from:"
    select file_name in "${files[@]}" "Cancel"; do
        if [[ $REPLY -le ${#files[@]} && $REPLY -gt 0 ]]; then
            echo "You selected to delete from: $file_name"
            cat $file_name
            read -p "Please Enter ID to delete: " ID
            sed -i "/^$ID:/d" $file_name
            echo "Row with ID $ID deleted successfully."

            # Delete both the table file and metadata hidden file
            rm -f "$file_name"
            rm -f ".$file_name"
            echo "Table file and metadata hidden file deleted successfully."
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Deletion canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}

# update from table
function updateFromTable() {
    echo "This is all the Tables you have created:"
    ls

    files=($(ls))

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found to update."
        return
    fi

    echo "Choose a Table to update:"
    select file_name in "${files[@]}" "Cancel"; do
        if [[ $REPLY -le ${#files[@]} && $REPLY -gt 0 ]]; then
            echo "You selected to update: $file_name"
            cat $file_name
            read -p "Please Enter ID to update: " ID
            read -p "Please Enter new Data: " NEW_DATA
            sed -i "/^$ID:/c\\$ID:$NEW_DATA" $file_name
            echo "Row with ID $ID updated successfully."
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Update canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}

# list table
# list all data in table (all lines (rows) in the file) but give list of all tables to choose from in the directory
function listAllTableData() {
    echo "This is all the Tables you have created:"
    ls

    files=($(ls))

    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found to list."
        return
    fi

    echo "Choose a Table to list:"

    select file_name in "${files[@]}" "Cancel"; do
        if [[ $REPLY -le ${#files[@]} && $REPLY -gt 0 ]]; then

            echo "You selected to list: $file_name"
            cat $file_name
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Listing canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}
