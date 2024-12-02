if [ $# -ne 1 ]
then
    echo "Usage: $0 <app>"
    exit 1
fi
APP_NAME=${1}

if [ ! -e workspace/${APP_NAME} ]
then
    echo "Error: workspace/${APP_NAME} does not exist."
    exit 1
fi

rm -f workspace/${APP_NAME}/*.o
rm -f workspace/${APP_NAME}/*.elf*
