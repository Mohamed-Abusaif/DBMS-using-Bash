#! /usr/bin/bash
shopt -s extglob


#=========================== Drop Table===========================

function dropTable() {
    echo "This is all the Tables you have created:"
    ls

    echo "Enter the name of the Table you want to drop: "
    read tableName

    if [ -f "$tableName" ]
    then
        rm $tableName
        rm $tableName-metadata
        echo "Table $tableName has been dropped successfully"
    else
        echo "Table $tableName does not exist"
    fi

}