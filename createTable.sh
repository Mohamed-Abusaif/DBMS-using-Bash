#! /usr/bin/bash
shopt -s extglob

#=========================== Create Table===========================

#table is a file inside the directory
function createTable() {

    read -p "Please Enter Your Table Name: " TableName
    if [[ -e $TableName ]]; then
        echo "Table $TableName exists"
    else
        #if user enter nothing or space or special characters or numbers or start with numbers or start with space give him warning and ask him to enter valid name
        while [[ $TableName == "" || $TableName == +([[:space:]]) || $TableName == +([[:punct:]]) || $TableName == +([0-9]) || $TableName == +([0-9])[a-zA-Z]* || $TableName == +([[:space:]])[a-zA-Z]* ]]; do
            echo "Invalid Table Name"
            read -p "Please Enter Your Table Name: " TableName
        done
        touch "$TableName.txt"
        touch "$TableName-metadata.txt"
        echo "Table $TableName Created Successfully"
    fi

    read -p "Please Enter Primary Key: " PrimaryKey
    read -p "Please Enter Primary Key Data Type(int/string): " PrimaryKeyDataType
    while [[ $PrimaryKeyDataType != "int" && $PrimaryKeyDataType != "string" ]]; do
        read -p "Please Enter Primary Key Data Type(int/string): " PrimaryKeyDataType
    done
    echo -n "$PrimaryKey:" >>"$TableName.txt"
    echo -n "$PrimaryKey:" >>"$TableName-metadata.txt"
    echo "$PrimaryKeyDataType:PK" >>"$TableName-metadata.txt"

    read -p "Please Enter Number of Columns: " NumberOfColumns
    for ((i = 1; i <= NumberOfColumns; i++)); do
        read -p "Please Enter Column Name $i: " ColumnName
        read -p "Please Enter Column Data Type(int/string) $i: " ColumnDataType
        while [[ $ColumnDataType != "int" && $ColumnDataType != "string" ]]; do
            read -p "Please Enter Column Data Type(int/string) $i: " ColumnDataType
        done
        echo -n "$ColumnName:" >>"$TableName.txt"
        echo -n "$ColumnName:" >>"$TableName-metadata.txt"
        echo "$ColumnDataType" >>"$TableName-metadata.txt"
    done
    echo "Table $TableName Created Successfully"

}
