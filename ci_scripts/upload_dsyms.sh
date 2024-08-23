#!/bin/sh

echo "Trying to upload dSYMs."
if [ -d ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME} ]; then
    echo "Start uploading dSYMs"
    ${SRCROOT%/*/*}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run
else
    echo "dSYMs is not found"
fi