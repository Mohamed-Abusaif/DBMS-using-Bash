#! /usr/bin/bash
shopt -s extglob

#=========================== Create Table===========================

#table is a file inside the directory
function createTable() {

   # hna han Validate Table Name
    while true; do
        read -p "Please Enter Your Table Name: " TableName
        if [[ -z "$TableName" || "$TableName" =~ [^a-zA-Z0-9_] || "$TableName" =~ ^[0-9] ]]; then
            echo -e "\e[31mInvalid Table Name! Use letters, numbers, and underscores only (must not start with a number).\e[0m"
        elif [[ -e "$TableName" ]]; then
            echo -e "\e[31mTable '$TableName' already exists!\e[0m"
        else
            break
        fi
    done

    touch "$TableName"
    touch "$TableName-metadata"
    echo -e "\e[32mTable '$TableName' Created Successfully.\e[0m"

    # here will Validate Primary Key Name
    while true; do
        read -p "Please Enter Primary Key Name: " PrimaryKey
        if [[ -z "$PrimaryKey" || "$PrimaryKey" =~ [^a-zA-Z0-9_] || "$PrimaryKey" =~ ^[0-9] ]]; then
            echo -e "\e[31mInvalid Primary Key! Use letters, numbers, and underscores only.\e[0m"
        else
            break
        fi
    done

    # hna hanvalidate Primary Key Data Type
    while true; do
        read -p "Please Enter Primary Key Data Type (int/string): " PrimaryKeyDataType
        if [[ "$PrimaryKeyDataType" != "int" && "$PrimaryKeyDataType" != "string" ]]; then
            echo -e "\e[31mInvalid Data Type! Choose either 'int' or 'string'.\e[0m"
        else
            break
        fi
    done

    # Store metadata
    echo "$PrimaryKey:$PrimaryKeyDataType:PK" >> "$TableName-metadata"
    columns=("$PrimaryKey")

    # Validate Number of Columns
    while true; do
        read -p "Please Enter Number of Additional Columns: " NumberOfColumns
        if ! [[ "$NumberOfColumns" =~ ^[1-9][0-9]*$ ]]; then
            echo -e "\e[31mInvalid Number! Please enter a positive integer.\e[0m"
        else
            break
        fi
    done

    # Column Names and Data Types Validation
    for ((i = 1; i <= NumberOfColumns; i++)); do
        while true; do
            read -p "Enter Column Name $i: " ColumnName
            if [[ -z "$ColumnName" || "$ColumnName" =~ [^a-zA-Z0-9_] || "$ColumnName" =~ ^[0-9] ]]; then
                echo -e "\e[31mInvalid Column Name! Use letters, numbers, and underscores only.\e[0m"
            elif [[ " ${columns[*]} " =~ " $ColumnName " ]]; then
                echo -e "\e[31mColumn Name '$ColumnName' already exists! Choose a different name.\e[0m"
            else
                break
            fi
        done

        # Validate Data Type
        while true; do
            read -p "Enter Data Type for '$ColumnName' (int/string): " ColumnDataType
            if [[ "$ColumnDataType" != "int" && "$ColumnDataType" != "string" ]]; then
                echo -e "\e[31mInvalid Data Type! Choose either 'int' or 'string'.\e[0m"
            else
                break
            fi
        done

        # Append to metadata and columns list
        columns+=("$ColumnName")
        echo "$ColumnName:$ColumnDataType" >> "$TableName-metadata"
    done

    # Store column headers in table file
    echo "${columns[*]}" | tr ' ' ':' > "$TableName"

    echo -e "\e[32mTable '$TableName' Created Successfully with Primary Key '$PrimaryKey'.\e[0m"

}
