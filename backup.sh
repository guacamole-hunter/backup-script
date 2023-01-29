# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi
# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi
# set values to variables
targetDirectory=$1
destinationDirectory=$2
# display values in cmd
echo "The target directory: $targetDirectory"
echo "The destination directory: $destinationDirectory"
# set current timestamp
currentTS=$(date +%s)
# define backup name
backupFileName="backup-$currentTS.tar.gz"
# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory
# To make things easier, we will define some useful variables...
# define orginal path
origAbsPath=$(pwd)
# define target path
cd $destinationDirectory
destAbsPath=$(pwd)
# change to target directory 
cd $origAbsPath
cd $targetDirectory
# define yesterday's timestamp
yesterdayTS=$(($currentTS - 24 * 60 * 60))
# define an array
declare -a toBackup
for file in $(ls) # return all files and directories in current folder
do
  # check if file was modified in the last 24 hrs
  if ((`date -r $file +%s` > $yesterdayTS))
  then
    # if file was updated add to array
    toBackup+=($file)
  fi
done
# compress and archive backup files
tar -czvf $backupFileName ${toBackup[@]}
# move backup file to destination directory
mv $backupFileName $destAbsPath
