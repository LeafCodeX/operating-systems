#!/bin/bash

# Author           : Marcin Bajkowski ( s193696@student.pg.edu.pl )
# Created On       : 2023-05-21
# Last Modified By : Marcin Bajkowski ( s193696@student.pg.edu.pl )
# Last Modified On : 2023-05-29
# Version          : v1.0
# Description      : Script for resizing, modifying appearance, extract
#       color curves, changing orientation and converting image formats using
#       ImageMagick and Zenity software!

function showHelp() { #Help code for the manual
  echo "==================  Help  ==================="
  echo " Program for modifying image using "
  echo " ImageMagick and Zenity software!  "
  echo " Run the program with the following command: "
  echo " ./Large_Script.sh"
  echo " Rest will be explained in the program! "
  echo "============================================="
}

function showVersion() { #Version code for the manual
  echo "============ Version! ============"
  echo " Version: v1.0 "
  echo " Author:  Marcin Bajkowski "
  echo " Created: 21 May 2023 "
  echo " Email: s193696@student.pg.edu.pl "
  echo " Faculty: Computer Science "
  echo " License: MIT license "
  echo " Copyright (C) 2023 "
  echo "=================================="
}

while [[ $# -gt 0 ]]; do #Checking if the user has entered the correct command
  key="$1"

  case $key in #Calling help or version information if the user has entered the correct command 
    -h|-help) 
      showHelp
      exit 0
      ;;
    -v|-version)
      showVersion
      exit 0
      ;;
    *) #Printing an error if the user has entered an incorrect command
      echo "Unknown option: $key"
      exit 1
      ;;
  esac

  shift 
done

DIRECTORY="$HOME" #Setting the directory
SELECTED_OPTION=0 #Variable for the menu

function menuResize() { #Image resizing code
    RESIZE_OPTION=$(zenity --list --width 500 --height 130 --title "Resize Image" --text "Select an option:" --column="Option" --column="Description" "1. Resize by Pixels" "Resize the image by specifying size in pixels" "2. Resize by Percentage" "Resize the image by specifying size as a percentage")
    case "$RESIZE_OPTION" in
        "1. Resize by Pixels") #Resizing by pixels
            while true; do
                SIZE=$(zenity --entry --title "Resize Image" --text "Enter the size in pixels (e.g., 800):")
                if [[ $SIZE =~ ^[0-9]+$ ]]; then #Checking if the user has entered a number and not a letter or symbol
                    OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                    convert "$IMAGE_FILE" -resize "$SIZE" "$OUTPUT_FILE"
                    if [[ $? -eq 0 ]]; then #Checking if the image has been resized
                        zenity --info --title "Image Processing Script" --text "Image has been resized and saved as '$OUTPUT_FILE'."
                    else
                        zenity --error --title "Image Processing Script" --text "Failed to resize the image."
                    fi
                    break
                elif [[ -z $SIZE ]]; then #Checking if SIZE variable is empty
                    zenity --error --width 180 --title "Image Processing Script" --text "No size entered."
                    break
                else
                    zenity --error --title "Image Processing Script" --text "Invalid size entered. Please enter a valid pixel size (e.g., 800)."
                fi
            done ;;
        "2. Resize by Percentage") #Resizing by percentage
            while true; do
                PERCENTAGE=$(zenity --entry --title "Resize Image" --text "Enter the resize percentage (e.g., 50 for 50%):")
                if [[ $PERCENTAGE =~ ^[0-9]+([.][0-9]+)?$ ]]; then #Checking if the user has entered a number and not a letter or symbol in the correct format
                    OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                    convert "$IMAGE_FILE" -resize "$PERCENTAGE%" "$OUTPUT_FILE"
                    if [[ $? -eq 0 ]]; then #Checking if the image has been resized
                        zenity --info --title "Image Processing Script" --text "Image has been resized and saved as '$OUTPUT_FILE'."
                    else
                        zenity --error --title "Image Processing Script" --text "Failed to resize the image."
                    fi
                    break
                elif [[ -z $PERCENTAGE ]]; then #Checking if PERCENTAGE variable is empty
                    zenity --error --width 180 --title "Image Processing Script" --text "No percentage entered."
                    break
                else
                    zenity --error --title "Image Processing Script" --text "Invalid percentage entered. Please enter a valid percentage value (e.g., 50 for 50%)."
                fi
            done ;;
    esac
}

function menuModifyAppearance() { #Image modification code
    MODIFY_OPTION=$(zenity --list --width 400 --height 180 --title "Modify Image Appearance" --text "Select an option:" --column="Option" --column="Description" "1. Adjust Brightness" "Adjust the brightness of the image" "2. Apply Filter" "Apply a filter to the image" "3. Change Color" "Change the color of the image" "4. Add Frame" "Add frame to the image")
    case "$MODIFY_OPTION" in
        "1. Adjust Brightness") #Code for adjusting brightness
            while true; do
                BRIGHTNESS=$(zenity --scale --title "Adjust Brightness" --text "Enter the brightness adjustment value:" --min-value="-100" --max-value="100" --step="1")
                if [[ -n $BRIGHTNESS ]]; then #Checking if BRIGHTNESS variable is empty
                    OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                    convert "$IMAGE_FILE" -brightness-contrast "${BRIGHTNESS}x0" "$OUTPUT_FILE"
                    if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                        zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                    else
                        zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                    fi
                    break
                else #Printing an error if the user has not entered a value
                    zenity --error --title "Image Processing Script" --text "No brightness adjustment value entered."
                    break
                fi
            done ;;
        "2. Apply Filter") #Code for applying filters
            FILTER_OPTION=$(zenity --list --width 350 --height 199 --title "Apply Filter" --text "Select a filter:" --column="Option" --column="Description" "1. Grayscale" "Add grayscale to image" "2. Sepia" "Add sepia to image" "3. Blur" "Add blur to image" "4. Sharpen" "Add sharpen to image" "5. Negative" "Add negative to image")
                case "$FILTER_OPTION" in
                    "1. Grayscale") #Code for applying grayscale
                        OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                        convert "$IMAGE_FILE" -colorspace Gray "$OUTPUT_FILE"
                        if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                        else
                            zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                        fi ;;
                    "2. Sepia") #Code for applying sepia
                        OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                        convert "$IMAGE_FILE" -sepia-tone 80% "$OUTPUT_FILE"
                        if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                        else
                            zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                        fi ;;
                    "3. Blur") #Code for applying blur
                        RADIUS=$(zenity --scale --title "Adjust Blur Radius" --text "Enter the blur radius:" --min-value="0" --max-value="10" --step="1")
                        if [[ -n $RADIUS ]]; then #Checking if RADIUS variable is empty
                            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                            convert "$IMAGE_FILE" -blur 0x${RADIUS} "$OUTPUT_FILE"
                            if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                                zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                            else
                                zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                            fi
                        else
                            zenity --error --width 180 --title "Image Processing Script" --text "No blur radius entered."
                        fi ;;
                    "4. Sharpen") #Code for applying sharpen
                        SHARPNESS=$(zenity --scale --title "Adjust Sharpening" --text "Enter the sharpening level (0 to 5):" --min-value="0" --max-value="5" --step="1")
                        if [[ -n $SHARPNESS ]]; then #Checking if SHARPNESS variable is empty
                            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                            convert "$IMAGE_FILE" -sharpen 0x${SHARPNESS} "$OUTPUT_FILE"
                            if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                                zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                            else
                                zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                            fi
                        else
                            zenity --error --width 180 --title "Image Processing Script" --text "No sharpening level entered."
                        fi ;;
                    "5. Negative") #Code for applying negative
                        OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                        convert "$IMAGE_FILE" -negate "$OUTPUT_FILE"
                        if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                        else
                            zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                        fi ;;
                esac ;;
        "3. Change Color") #Code for changing color
            COLOR=$(zenity --color-selection --title "Select Text Color")
            if [[ -n $COLOR ]]; then #Checking if COLOR variable is empty
                OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                convert "$IMAGE_FILE" -fill "$COLOR" -colorize 50% "$OUTPUT_FILE"
                if [[ $? -eq 0 ]]; then #Checking if the image has been modified
                    zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                else
                    zenity --error --title "Image Processing Script" --text "Failed to modify the image."
                fi
            else #Printing an error if the user has not selected a color
                zenity --error --width 180 --title "Image Processing Script" --text "No color selected."
            fi ;;
        "4. Add Frame") #Code for adding frame
            FRAME_SIZE=$(zenity --entry --title "Add Frame" --text "Enter frame size (0-10 pixels):")
            if [[ -z $FRAME_SIZE ]]; then #Checking if FRAME_SIZE variable is empty
                zenity --error --width 180 --title "Image Processing Script" --text "Frame size is required."
            elif ((FRAME_SIZE < 1 || FRAME_SIZE > 10)); then #Checking if FRAME_SIZE variable is between 1 and 10
                zenity --error --title "Image Processing Script" --text "Frame size must be between 1 and 10 pixels."
            else
                FRAME_COLOR=$(zenity --color-selection --title "Add Frame" --text "Select frame color:")
                if [[ -z $FRAME_COLOR ]]; then #Checking if FRAME_COLOR variable is empty and printing an error if it is
                    zenity --error --width 180 --title "Image Processing Script" --text "Frame color is required."
                else  #Code for adding frame
                    OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                    convert "$IMAGE_FILE" -bordercolor "$FRAME_COLOR" -border "$FRAME_SIZE"x"$FRAME_SIZE" "$OUTPUT_FILE"
                    zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
                fi
            fi ;;
    esac
}

function menuColorCurves() { #Image color curves code
    COLORS=$(convert "$IMAGE_FILE" -format "%c" histogram:info:-) #Extracting colors from image
    echo "$COLORS" > ColorCurvesList.txt #Saving colors to a file
    NUM_LINES=$(wc -l < ColorCurvesList.txt)
    if (( NUM_LINES > 5000 )); then #Checking if the number of lines is greater than 5000
        DATA=$(awk '{sub(":", "", $1); print NR, $0}' ColorCurvesList.txt | head -n 5000)
        zenity --list --width 500 --height 300 --title "Extract Color Curves" --text "Colors from Image!" \
            --column "Nr" --column "Quantity" --column "Color RGB" --column "Color HEX" --column "Color Name/sRGB" $DATA
        zenity --info --title "Extract Color Curves" --text "Number of colors exceeds the limit (5000). Please check the output file for the complete color list."
    else #Printing the list of colors if the number of lines is less than 5000
        DATA=$(awk '{sub(":", "", $1); print NR, $0}' ColorCurvesList.txt)
        zenity --list --width 500 --height 300 --title "Extract Color Curves" --text "Colors from Image!" \
            --column "Nr" --column "Quantity" --column "Color RGB" --column "Color HEX" --column "Color Name/sRGB" $DATA
    fi
}

function changeImageOrientation() { #Image rotation code
    ORIENTATION=$(zenity --list --title "Change Image Orientation" --text "Select the rotation option:" --column="Option" --column="Description" \
    "Angle" "Rotate by a custom angle" \
    "Right" "Rotate 90 degrees to the right" \
    "Left" "Rotate 90 degrees to the left" \
    "Rotate 180" "Rotate 180 degrees" \
    "Flip Vertical" "Flip image vertically" \
    "Flip Horizontal" "Flip image horizontally")
    
    if [[ -n $ORIENTATION ]]; then #Checking if ORIENTATION variable is empty
        if [[ $ORIENTATION == "Angle" ]]; then
            ROTATION_ANGLE=$(zenity --scale --title "Rotate Image" --text "Select the rotation angle (in degrees):" --min-value=-180 --max-value=180 --value=0 --step=1)
            if [[ $? -eq 1 ]]; then #Checking if the user has canceled the rotation
                zenity --error --width 180 --title "Image Processing Script" --text "Rotation canceled."
            else #Code for rotating the image by a custom angle and saving it
                OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
                convert "$IMAGE_FILE" -rotate "$ROTATION_ANGLE" "$OUTPUT_FILE"
                zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
            fi
        elif [[ $ORIENTATION == "Right" ]]; then #Code for rotating the image to the right
            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
            convert "$IMAGE_FILE" -rotate 90 "$OUTPUT_FILE"
            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
        elif [[ $ORIENTATION == "Left" ]]; then #Code for rotating the image to the left
            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
            convert "$IMAGE_FILE" -rotate -90 "$OUTPUT_FILE"
            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
        elif [[ $ORIENTATION == "Rotate 180" ]]; then #Code for rotating the image 180 degrees
            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
            convert "$IMAGE_FILE" -rotate 180 "$OUTPUT_FILE" 
            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
        elif [[ $ORIENTATION == "Flip Vertical" ]]; then #Code for flipping the image vertically
            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
            convert "$IMAGE_FILE" -flip "$OUTPUT_FILE" 
            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
        elif [[ $ORIENTATION == "Flip Horizontal" ]]; then #Code for flipping the image horizontally
            OUTPUT_FILE="${IMAGE_FILE%.*}_modified.${IMAGE_FILE##*.}"
            convert "$IMAGE_FILE" -flop "$OUTPUT_FILE"
            zenity --info --title "Image Processing Script" --text "Image has been modified and saved as '$OUTPUT_FILE'."
        fi
    fi
}

function convertImageFormat() { #Image format conversion code
    DESTINATION_FORMAT=$(zenity --list --width 250 --height 237 --title "Convert Image Format" --text "Select the destination format:" --column="Format" --column="Description" \
    "jpg" "JPEG image format" \
    "png" "PNG image format" \
    "gif" "GIF image format" \
    "bmp" "BMP image format" \
    "eps" "EPS image format" \
    "heic" "HEIC image format" \
    "pdf" "PDF image format")

    if [[ -n $DESTINATION_FORMAT ]]; then #Checking if DESTINATION_FORMAT variable is empty
        OUTPUT_FILE="${IMAGE_FILE%.*}_modified.$DESTINATION_FORMAT"
        convert "$IMAGE_FILE" "$OUTPUT_FILE"
        zenity --info --title "Image Processing Script" --text "Image converted to '$DESTINATION_FORMAT' format. Saved as '$OUTPUT_FILE'."
    fi
}

function featuresOfTheLargeScript() { #Code for displaying the program description and capabilities
    while true; do
        OPTION1="1. Load Image"
        DESCRIPTION1="Supported formats: JPG, PNG, GIF, BMP or HEIC."
        OPTION2="2. Resize Image"
        DESCRIPTION2="Resize the loaded image"
        OPTION3="3. Modify Image Appearance"
        DESCRIPTION3="Modify the appearance of the loaded image"
        OPTION4="4. Extract Color Curves"
        DESCRIPTION4="Extract color curves from the loaded image"
        OPTION5="5. Rotate Image"
        DESCRIPTION5="Rotate the loaded image"
        OPTION6="6. Convert Image Format"
        DESCRIPTION6="Convert the loaded image to a different format"
        OPTION7="7. Program Description"
        DESCRIPTION7="Display program description and capabilities"
        OPTION8="8. Quit"
        DESCRIPTION8="Exit the program"
        MENU=("$OPTION1" "$DESCRIPTION1" "$OPTION2" "$DESCRIPTION2" "$OPTION3" "$DESCRIPTION3" "$OPTION4" "$DESCRIPTION4" "$OPTION5" "$DESCRIPTION5" "$OPTION6" "$DESCRIPTION6" "$OPTION7" "$DESCRIPTION7" "$OPTION8" "$DESCRIPTION8")
        SELECTED_OPTION=$(zenity --list --width 500 --height 256 --title "Image Processing Script" --text "Select an option:" --column="Menu" --column="Description" "${MENU[@]}")
        
        case "$SELECTED_OPTION" in
            "$OPTION1") # Image loading code
                IMAGE_FILE=$(zenity --file-selection --title "Load Image" --file-filter="Image files | *.jpg *.jpeg *.png *.gif *.bmp *.heic")
                if [[ -n $IMAGE_FILE ]]; then #Checking if IMAGE_FILE variable is empty
                    zenity --info --title "Image Processing Script" --text "Image '$IMAGE_FILE' has been loaded."
                else
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                fi ;;
            "$OPTION2") #Image resizing code
                if [[ -z $IMAGE_FILE ]]; then 
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                else
                    menuResize
                fi ;;
            "$OPTION3") #Image modification code
                if [[ -z $IMAGE_FILE ]]; then
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                else
                    menuModifyAppearance
                fi ;;
            "$OPTION4") #Image color curves code
                if [[ -z $IMAGE_FILE ]]; then
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                else
                    menuColorCurves
                fi ;;
            "$OPTION5") #Image rotation code
                if [[ -z $IMAGE_FILE ]]; then
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                else
                    changeImageOrientation
                fi ;;
            "$OPTION6") #Image format conversion code
                if [[ -z $IMAGE_FILE ]]; then
                    zenity --error --width 180 --title "Image Processing Script" --text "No image selected."
                else
                    convertImageFormat
                fi ;;
            "$OPTION7") #Program description code
                zenity --info --title "Image Processing Script" --text "Program description and capabilities:\n\n- Load Image: Load an image file.\n- Resize Image: Change the size of the loaded image.\n- Modify Image Appearance: Adjust the appearance of the loaded image.\n- Extract Color Curves: Extract color curves from the loaded image.\n- Rotate Image: Rotate the loaded image.\n- Convert Image Format: Convert the loaded image to a different format.\n- Program Description: Display this program description and capabilities.\n- Quit: Exit the program."
                ;;
            "$OPTION8") #Exit code
                if [[ $? -eq 0 ]]; then 
                    exit
                else
                    break
                fi
                ;;
        esac
    done
}

while [[ $SELECTED_OPTION != "$OPTION4" ]]; do # Main menu code
    OPTION1="1. Install ImageMagick"
    DESCRIPTION1="Install ImageMagick if not installed"
    OPTION2="2. Run program"
    DESCRIPTION2="Run the program if ImageMagick is installed"
    OPTION3="3. Uninstall ImageMagick"
    DESCRIPTION3="Uninstall ImageMagick if installed"
    OPTION4="4. Quit!"
    DESCRIPTION4="Exit the program"
    MENU=("$OPTION1" "$DESCRIPTION1" "$OPTION2" "$DESCRIPTION2" "$OPTION3" "$DESCRIPTION3" "$OPTION4" "$DESCRIPTION4")
    SELECTED_OPTION=$(zenity --list --title "Image Processing Script" --text "Select an option:" --column="Menu" --column="Description" "${MENU[@]}" --width 500 --height 180)
    
    case "$SELECTED_OPTION" in
        "$OPTION1") # Installation of ImageMagick
            if ! command -v convert &> /dev/null; then
                brew install imagemagick
                if [[ $? -eq 0 ]]; then # Checking if the installation was successful
                    zenity --info --title "Image Processing Script" --text "ImageMagick has been successfully installed."
                else
                    zenity --info --title "Image Processing Script" --text "Failed to install ImageMagick."
                fi
            else
                zenity --info --title "Image Processing Script" --text "ImageMagick is already installed."
            fi ;;
        "$OPTION2") # Running the program
            if command -v convert &> /dev/null; then
                featuresOfTheLargeScript # Calling the function that contains the main code
            else
                zenity --info --title "Image Processing Script" --text "ImageMagick is not installed. Please install it first."
            fi ;;
        "$OPTION3") # Uninstalling ImageMagick
            if command -v convert &> /dev/null; then
                brew uninstall imagemagick
                if [[ $? -eq 0 ]]; then # Checking if the uninstallation was successful
                    zenity --info --title "Image Processing Script" --text "ImageMagick has been successfully uninstalled."
                else
                    zenity --info --title "Image Processing Script" --text "Failed to uninstall ImageMagick."
                fi
            else
                zenity --info --title "Image Processing Script" --text "ImageMagick is not installed."
            fi ;;
        "$OPTION4") # Quitting the program
            if [[ $? -eq 0 ]]; then
                exit
            else
                SELECTED_OPTION=0
            fi ;;
    esac
done
