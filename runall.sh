#!/bin/bash

# Start simulation
xhost +local:root
docker compose -f compose-simulation.yaml pull
docker compose -f compose-simulation.yaml up -d

CONTAINER_NAME="aralgorithmicrobotics-ar-workspace-1"
RVIZ_CONFIG="/workspace/succulence_ws/src/succulence_rover_ros/config/succulance_slam.rviz"

echo "Building package..."
# Run the build inside the container first. We source the system ROS, not the workspace.
docker exec -it $CONTAINER_NAME /bin/bash -c "cd succulence_ws && colcon build --packages-select succulence_rover_ros --symlink-install"

sleep 2 # Wait a bit for the build to finish and the container to be ready

# Now define the command to use for the windows (since build is done)
BASE_CMD="source /opt/ros/jazzy/setup.bash && cd succulence_ws && source install/setup.bash"

# 1. Start RViz terminal
konsole -e docker exec -it $CONTAINER_NAME /bin/bash -c "$BASE_CMD && rviz2 -d $RVIZ_CONFIG" &

# 2. Start Mission Launch
konsole -e docker exec -it $CONTAINER_NAME /bin/bash -c "$BASE_CMD && ros2 launch succulence_rover_ros dead_reckoning.launch.py" &

#konsole -e btop &

read -p "Press Enter to close the terminals..."
docker compose -f compose-simulation.yaml down