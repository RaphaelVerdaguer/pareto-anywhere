# Append changes to /etc/sysctl.conf
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Apply sysctl.conf updates without rebooting
sudo sysctl -p

./install_docker_compose.sh
systemctl start docker