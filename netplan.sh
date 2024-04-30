#!/bin/bash
# By DrLaBulle

# Afficher les interfaces réseau disponibles

echo "Interfaces réseau disponibles :"

ip link show | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}'

read -p "Entrez l'interface reseau a configurer: " selected_interface

##### DEMANDE DES VARIABLES PERSONNALISÉES #####
echo "Veuillez fournir les informations suivantes :"
read -p "Adresse IP: " ip_address
read -p "Masque de sous reseau (e.g., 24 for /24): " subnet_mask
read -p "Passerelle par defaut: " gateway
read -p "Serveur DNS primaire: " dns_primary
read -p "Serveur DNS secondaire (en option): " dns_secondary

# Create a Netplan configuration file with the provided details

cat > /etc/netplan/01-network-config.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $selected_interface:
      addresses: [$ip_address/$subnet_mask]
      routes:
        - to: 0.0.0.0/0
          via: $gateway
          on-link: true
      nameservers:
        addresses: [$dns_primary, $dns_secondary]
EOF

sudo chmod 600 /etc/netplan/01-network-config.yaml 

# Apply the Netplan configuration
sudo netplan apply

echo "La configuration réseau s'est déroulée correctement."