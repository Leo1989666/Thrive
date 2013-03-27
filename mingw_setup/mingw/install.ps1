param(
    [string]$MINGW_ENV
)

$DIR = Split-Path $MyInvocation.MyCommand.Path

#################
# Include utils #
#################

. (Join-Path "$DIR\.." "utils.ps1")


############################
# Create working directory #
############################

$WORKING_DIR = Join-Path $MINGW_ENV temp\mingw

mkdir $WORKING_DIR -force

###################
# Check for 7-Zip #
###################

$7z = Join-Path $MINGW_ENV "temp\7zip\7za.exe"

if (-Not (Get-Command $7z -errorAction SilentlyContinue))
{
    [Windows.Forms.MessageBox]::Show(
        “Could not find 7-Zip command line tool. Please follow the directions in the Readme.txt to resolve this problem.”, 
        “7-Zip not found”, 
        [Windows.Forms.MessageBoxButtons]::OK, 
        [Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}


####################
# Download archive #
####################

$REMOTE_DIR="http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/rubenvb/gcc-4.8-dw2-release"
$ARCHIVE="i686-w64-mingw32-gcc-dw2-4.8.0-win32_rubenvb.7z"

$DESTINATION = Join-Path $WORKING_DIR $ARCHIVE

if (-Not (Test-Path $DESTINATION)) {
    $CLIENT = New-Object System.Net.WebClient
    $CLIENT.DownloadFile("$REMOTE_DIR/$ARCHIVE", $DESTINATION)
}

##########
# Unpack #
##########

$ARGUMENTS = "x",
             "-y",
             "-o$WORKING_DIR",
             $DESTINATION
             
& $7z $ARGUMENTS

robocopy (Join-Path $WORKING_DIR mingw32-dw2) $MINGW_ENV /E
