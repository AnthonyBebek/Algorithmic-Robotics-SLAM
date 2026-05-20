xhost +local:root
docker compose -f compose-simulation.yaml pull
docker compose -f compose-simulation.yaml up -d