#! /usr/bin/bash
shopt -s extglob

#===================================================================
#===================================================================
#===================================================================
#===================================================================
#===================================================================
#===================================================================

#=========================== Create Table===========================

#table is a file inside the directory 
function createTable(){
    read -p "Please Enter Your Table Name: " TableName
    if [[ -e  $TableName ]]
    then 
        echo "Table $TableName alreadt exist"	
    else 
        touch "$TableName"
        echo "Table $TableName Created Succsesfully" 
        #create columns 
        read -p "Please Enter Number of Columns: " NumberOfColumns
        for (( i=1; i<=$NumberOfColumns; i++ ))
        do
            read -p "Please Enter Column Name: " ColumnName
            echo -n "$ColumnName:" >> $TableName
        done
        echo "Columns Created Successfully" 
    fi

}

#=========================== Drop Table===========================

function dropTable(){
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


# insert Data into table

function insertIntoTable(){
    read -p "Please Enter Your Table Name: " TableName
    if [[ -e  $TableName ]]
    then 
        echo "Table $TableName exists"	
    else 
        touch "$TableName"
        echo "Table $TableName Created Successfully" 	
    fi

    # Read the columns from the file
    columns=$(head -n 1 $TableName)
    IFS=':' read -r -a columnsArray <<< "$columns"
    NumberOfColumns=${#columnsArray[@]}

    # Determine the next ID
    if [[ $(wc -l < $TableName) -eq 1 ]]; then
        nextID=1
    else
        lastID=$(tail -n 1 $TableName | cut -d':' -f1)
        nextID=$((lastID + 1))
    fi

    # Get the data to insert and automatically add ID to the data
    dataToInsert="$nextID"
    for (( i=1; i<$NumberOfColumns; i++ ))
    do
        read -p "Please Enter Data for ${columnsArray[$i]}: " data
        dataToInsert="$dataToInsert:$data"
    done

    echo $dataToInsert >> $TableName
    echo "Data Inserted Successfully"
}

# delete from table 


# update from table


# select from table



