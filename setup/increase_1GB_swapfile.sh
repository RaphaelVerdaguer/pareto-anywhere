sudo swapoff /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024 oflag=append conv=notrunc
sudo mkswap /swapfile
sudo swapon /swapfile
