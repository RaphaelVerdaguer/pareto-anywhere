echo "Are you sure you want to remove all the volumes? (yes/no)"
read answer

if [ "$answer" = "yes" ]; then
    docker volume rm pareto-anywhere_esdata01 pareto-anywhere_esdata02 pareto-anywhere_esdata03 pareto-anywhere_certs pareto-anywhere_kibanadata
    echo "Volumes removed."
else
    echo "Volumes not removed. Exiting."
fi
