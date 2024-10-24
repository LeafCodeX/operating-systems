#!/bin/bash
#author & index: Marcin Bajkowski & s193696
#faculty & field of study: ETI & IT, Gdańsk University of Technology, 2023
#DO PRZEROBIENIA DIALOG I ZENITY
DIRECTORY="$HOME"
SELECTED_OPTION=0
while [[ $SELECTED_OPTION != "$OPTION8" ]]; do
    OPTION1="1. File name: $FILE_NAME"
    DESCRIPTION1="Search by file name"
    OPTION2="2. Directory: $DIRECTORY"
    DESCRIPTION2="Search by directory"
    OPTION3="3. File permissions: $FILE_PERMISSIONS"
    DESCRIPTION3="Search by file permissions"
    OPTION4="4. Latest file modification: $MODIFICATION"
    DESCRIPTION4="Search by latest file modification"
    OPTION5="5. File smaller than: (bytes) $MAX_FILE_SIZE"
    DESCRIPTION5="Search by file size"
    OPTION6="6. File content: $FILE_CONTENT"
    DESCRIPTION6="Search by file content"
    OPTION7="7. Search!"
    DESCRIPTION7="Search by the entered data!"
    OPTION8="8. Quit!"
    DESCRIPTION8="End of program!"
    MENU=("$OPTION1" "$DESCRIPTION1" "$OPTION2" "$DESCRIPTION2" "$OPTION3" "$DESCRIPTION3" "$OPTION4" "$DESCRIPTION4" "$OPTION5" "$DESCRIPTION5" "$OPTION6" "$DESCRIPTION6" "$OPTION7" "$DESCRIPTION7" "$OPTION8" "$DESCRIPTION8")
    SELECTED_OPTION=$(zenity --list --title "Linux file finder" --text "Select the option(s) by which you want to find the file!" --column=Menu --column=Description "${MENU[@]}" --height 260 --width 500)
    
    case "$SELECTED_OPTION" in
            $OPTION1) FILE_NAME=$(zenity --entry --title "Linux file finder" --text "Enter the name of the file:") ;;
            $OPTION2) DIRECTORY=$(zenity --entry --title "Linux file finder" --text "Enter directory:") ;;
            $OPTION3) FILE_PERMISSIONS=$(zenity --entry --title "Linux file finder" --text "Enter the permissions assigned to the file in UGO format:")
                if [[ $FILE_PERMISSIONS =~ ^[0-7]{3}$ ]]; then
                    SEARCH_BY_PERSMISSIONS="-perm $FILE_PERMISSIONS"
                else
                    FILE_PERMISSIONS=""
                    SEARCH_BY_PERSMISSIONS=""
                fi ;;
            $OPTION4) MODIFICATION=$(zenity --entry --title "Linux file finder" --text "Enter when the file was last modified (number of days):")
                if [[ $MODIFICATION =~ ^[0-9]+$ ]]; then
                    SEARCH_BY_MODIFICATION="-mtime $MODIFICATION"
                else
                    MODIFICATION=""
                    SEARCH_BY_MODIFICATION=""
                fi ;;
            $OPTION5) MAX_FILE_SIZE=$(zenity --entry --title "Linux file finder" --text "Enter the maximum file size:")
                if [[ $MAX_FILE_SIZE =~ ^[0-9]+$ ]]; then
                    SEARCH_BY_SIZE="-size -$MAX_FILE_SIZE"
                else
                    MAX_FILE_SIZE=""
                    SEARCH_BY_SIZE=""
                fi ;;
            $OPTION6) FILE_CONTENT=$(zenity --entry --title "Linux file finder" --text "Enter the content of the file:")
                if [[ $FILE_CONTENT ]]; then
                    SEARCH_BY_CONTENT="-exec grep -l -i $FILE_CONTENT {} +"
                else
                    SEARCH_BY_CONTENT=""
                fi ;;
            $OPTION7) RESULT=$(find $DIRECTORY -type f -iname "*$FILE_NAME*" $SEARCH_BY_PERSMISSIONS $SEARCH_BY_MODIFICATION $SEARCH_BY_SIZE $SEARCH_BY_CONTENT)
                if [[ -n $RESULT ]]; then
                    echo "$RESULT" | zenity --text-info --width 500 --height 260 --title "Linux file finder - Results!"
                else
                    zenity --info --title "Linux file finder" --text "No files found matching the search criteria." --timeout 4
                fi ;;
            $OPTION8) zenity --question --title "Linux file finder" --text "Do you want to end the program?"
                if [[ $? -eq 0 ]]; then
                    exit
                else
                    SELECTED_OPTION=0
                fi ;;
    esac
done

