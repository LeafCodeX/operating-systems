#!/bin/bash
#author & index: Marcin Bajkowski & s193696
#faculty & field of study: ETI & IT, Gdańsk University of Technology, 2023
DIRECTORY="$HOME"
SELECTED_OPTION=0
while [[ $SELECTED_OPTION -ne 8 ]]; do
    SELECTED_OPTION=0
    clear
    echo "Linux file finder. Select the option(s) by which you want to find the file:"
    echo "1. File name: $FILE_NAME"
    echo "2. Directory: $DIRECTORY"
    echo "3. File permissions: $FILE_PERMISSIONS"
    echo "4. Latest file modification: $MODIFICATION"
    echo "5. File smaller than: (bytes) $MAX_FILE_SIZE"
    echo "6. File content: $FILE_CONTENT"
    echo "7. Search by the data entered!"
    echo "8. End of program!"
    read -p "Select option: " SELECTED_OPTION
    
    case $SELECTED_OPTION in
        1*) read -p "Enter the name of the file: " FILE_NAME
        SELECTED_OPTION=0 ;;
        2*) read -p "Enter directory: " DIRECTORY ;;
        3*) read -p "Enter the permissions assigned to the file in UGO format: " FILE_PERMISSIONS
            if [[ $FILE_PERMISSIONS =~ ^[0-7]{3}$ ]]; then
                SEARCH_BY_PERSMISSIONS="-perm $FILE_PERMISSIONS"
            else
                FILE_PERMISSIONS=""
                SEARCH_BY_PERSMISSIONS=""
            fi ;;
        4*) read -p "Enter when the file was last modified (number of days): " MODIFICATION
            if [[ $MODIFICATION =~ ^[0-9]+$ ]]; then
                SEARCH_BY_MODIFICATION="-mtime $MODIFICATION"
            else
                MODIFICATION=""
                SEARCH_BY_MODIFICATION=""
            fi ;;
        5*) read -p "Enter the maximum file size: " MAX_FILE_SIZE
            if [[ $MAX_FILE_SIZE =~ ^[0-9]+$ ]]; then
                SEARCH_BY_SIZE="-size -$MAX_FILE_SIZE"
            else
                MAX_FILE_SIZE=""
                SEARCH_BY_SIZE=""
            fi ;;
        6*) read -p "Enter the content of the file: " FILE_CONTENT
            if [[ $FILE_CONTENT ]]; then
                SEARCH_BY_CONTENT="-exec grep -l -i $FILE_CONTENT {} +"
            else
                SEARCH_BY_CONTENT=""
            fi ;;
        7*) echo "Extracted file(s) according to the data provided: "
            echo
            RESULT=$(find $DIRECTORY -type f -iname "*$FILE_NAME*" $SEARCH_BY_PERSMISSIONS $SEARCH_BY_MODIFICATION $SEARCH_BY_SIZE $SEARCH_BY_CONTENT)
            if [[ -n $RESULT ]]; then
                echo "Linux file finder - RESULTS!"
                echo "$RESULT"
            else
                echo "No files found matching the search criteria."
            fi
            sleep 6 ;;
        8*) echo "The program has been finished!"
            exit ;;
        *) echo "An invalid option has been selected!"
            sleep 1 ;;
    esac
done
