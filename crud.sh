#! /usr/bin/bash
shopt -s extglob

#=========================== Insert Into Table ===========================
function readMetadataFile() {
    local table_file=$1
    local metadata_file="${table_file}-metadata"

    if [ -f "$metadata_file" ]; then
        echo "Reading metadata from $metadata_file:"

        column_names=()
        data_types=()

        while IFS=: read -r column data_type; do
            column_names+=("$column")
            data_types+=("$data_type")
        done <"$metadata_file"

        echo "Columns: ${column_names[*]}"
        echo "Data Types: ${data_types[*]}"
    else
        echo "Metadata file $metadata_file does not exist."
        return 1
    fi
}

# Function to insert data into a table
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

            if [ ! -f "$file_name-metadata" ]; then
                echo "Metadata file not found. Please create a metadata file first."
                return
            fi

            readMetadataFile "$file_name"

            if [ ${#column_names[@]} -eq 0 ]; then
                echo "Error: No columns found in metadata."
                return
            fi

            echo "Columns: ${column_names[*]}"
            echo "Expected Data Types: ${data_types[*]}"

            read -p "Please enter new data (separated by commas): " NEW_DATA

            IFS=',' read -r -a values <<<"$NEW_DATA"

            echo "Entered Values: ${values[*]}"

            if [ ${#values[@]} -ne ${#column_names[@]} ]; then
                echo "Invalid number of values entered. Expected ${#column_names[@]} values."
                return
            fi

            function validateDataTypes() {
                local value=$1
                local data_type=$2

                case $data_type in
                "int")
                    if [[ ! $value =~ ^[0-9]+$ ]]; then
                        echo "Invalid data type for '$value'. Expected 'int'."
                        return 1
                    fi
                    ;;
                "string")
                    if [[ $value =~ ^[0-9]+$ ]]; then
                        echo "Invalid data type for '$value'. Expected 'string'."
                        return 1
                    fi
                    ;;
                esac
                return 0
            }

            for i in "${!values[@]}"; do
                if ! validateDataTypes "${values[$i]}" "${data_types[$i]}"; then
                    echo "Insertion failed due to data type mismatch."
                    return
                fi
            done

            echo "${values[*]}" >>"$file_name"

            echo "New record inserted successfully."
            break
        elif [[ $REPLY -eq $((${#files[@]} + 1)) ]]; then
            echo "Insertion canceled."
            break
        else
            echo "Invalid option. Please try again."
        fi
    done
}

#=========================== Update From Table ===========================

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

#=========================== List Table ===========================

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
