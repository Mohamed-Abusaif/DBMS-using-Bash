#! /usr/bin/bash
shopt -s extglob

#=========================== Create Table===========================

#table is a file inside the directory
function createTable() {

    read -p "Please Enter Your Table Name: " TableName
    if [[ -e $TableName ]]; then
        echo "Table $TableName exists"
    else
        while [[ $TableName == "" || $TableName =~ ^[[:space:]]*$ || $TableName =~ ^[[:punct:]]*$ || $TableName =~ ^[0-9] ]]; do
            echo "Invalid Table Name"
            read -p "Please Enter Your Table Name: " TableName
        done
        touch "$TableName"
        touch "$TableName-metadata"
        echo "Table $TableName Created Successfully"
    fi

    read -p "Please Enter Primary Key: " PrimaryKey
    read -p "Please Enter Primary Key Data Type(int/string): " PrimaryKeyDataType
    while [[ $PrimaryKeyDataType != "int" && $PrimaryKeyDataType != "string" ]]; do
        read -p "Please Enter Primary Key Data Type(int/string): " PrimaryKeyDataType
    done

    # Initialize column names list with primary key
    columns=("$PrimaryKey")
    echo "$PrimaryKey:$PrimaryKeyDataType:PK" >>"$TableName-metadata"

    read -p "Please Enter Number of Columns: " NumberOfColumns
    for ((i = 1; i <= NumberOfColumns; i++)); do
        read -p "Please Enter Column Name $i: " ColumnName
        read -p "Please Enter Column Data Type(int/string) $i: " ColumnDataType
        while [[ $ColumnDataType != "int" && $ColumnDataType != "string" ]]; do
            read -p "Please Enter Column Data Type(int/string) $i: " ColumnDataType
        done
        columns+=("$ColumnName")
        echo "$ColumnName:$ColumnDataType" >>"$TableName-metadata"
    done

    # Join all column names with ":" and write to the table file
    echo "${columns[*]}" | tr ' ' ':' >"$TableName"

    echo "Table $TableName Created Successfully"
}
