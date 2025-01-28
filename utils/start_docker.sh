#/bin/bash -e

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script directory
cd "$SCRIPT_DIR"/../ || exit

test -d datadir || mkdir datadir

docker image build --tag zc102_qemu \
	--shm-size=2gb	\
	--build-arg USER=$USER . 

docker container run --name zc102_qemu -v $(pwd)/datadir:/var/datadir -it zc102_qemu 
