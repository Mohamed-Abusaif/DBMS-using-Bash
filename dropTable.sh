#! /usr/bin/bash
shopt -s extglob


#=========================== Drop Table===========================

function dropTable() {
    echo "This is all the Tables you have created:"
    ls

    echo "Enter the name of the Table you want to drop: "
    read tableName

    if [ -f "$tableName.txt" ]
    then
        rm $tableName.txt
        rm $tableName-metadata.txt
        echo "Table $tableName has been dropped successfully"
    else
        echo "Table $tableName does not exist"
    fi

}