#!/bin/bash
# run multiple instances of the 'px4' binary, with the gazebo SITL simulation
# It assumes px4 is already built, with 'make px4_sitl_default gazebo'

# The simulator is expected to send to TCP port 4560+i for i in [0, N-1]
# For example gazebo can be run like this:
#./Tools/gazebo_sitl_multiple_run.sh -n 10 -m iris

function cleanup() {
	if [ $simulation=="gazebo" ]; then
		pkill gzclient
		pkill gzserver
	fi
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "Usage: $0 [-n <num_vehicles>] [-m <vehicle_model>] [-w <world>] [-s <script>]"
	echo "-s flag is used to script spawning vehicles e.g. $0 -s iris:3,plane:2"
	exit 1
fi

while getopts n:m:w:s:t: option
do
	case "${option}"
	in
		s) SIMULATION=${OPTARG};;
		d) DEVICE=${OPTARG};;
		b) BAUDRATE=${OPTARG};;
		w) WORLD=${OPTARG};;
	esac
done

device=${DEVICE:=3}
baudrate=${BAUDRATE:=921600}
world=${WORLD:=empty}
simulation=${SIMULATION:="gazebo"}

echo ${SCRIPT}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
src_path="$SCRIPT_DIR/.."

build_path=${src_path}/build/${target}

sleep 1

if [ $simulation=="gazebo" ]; then
	source ${src_path}/Tools/setup_gazebo.bash ${src_path} ${src_path}/build/${target}

	echo "Starting gazebo"
	gzserver ${src_path}/Tools/sitl_gazebo/worlds/${world}.world --verbose &
	sleep 5

	python3 ${src_path}/Tools/sitl_gazebo/scripts/jinja_gen.py ${src_path}/Tools/sitl_gazebo/models/${MODEL}/${MODEL}.sdf.jinja ${src_path}/Tools/sitl_gazebo --device {DEVICE} --output-file /tmp/${MODEL}_hitl.sdf
	gz model --spawn-file=/tmp/${MODEL}_hitl.sdf --model-name=${MODEL} -x 0.0 -y $((3*${N})) -z 0.0

	trap "cleanup" SIGINT SIGTERM EXIT

	echo "Starting gazebo client"
	gzclient
elif [ $simulation=="jmavsim" ]; then
	${src_path}/Tools/jmavsim_run.sh -q -s -d $device -b $baudrate -r 250
else
	echo "Unknown simulation: " $simulation
fi

