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