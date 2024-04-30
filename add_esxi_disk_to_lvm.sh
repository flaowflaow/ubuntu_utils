#!/bin/bash
# By DrLaBulle

# Vérifie si l'utilisateur est root
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root" >&2
  exit 1
fi

# Affiche la liste des disques
echo "Liste des disques disponibles :"
lsblk

# Demande à l'utilisateur de spécifier le disque à ajouter au groupe de volumes LVM
read -p "Entrez le nom du disque à ajouter au groupe de volumes LVM (par exemple, /dev/sdb) : " disk

# Vérifie si le disque spécifié existe
if [ ! -b "$disk" ]; then
  echo "Le disque spécifié n'existe pas." >&2
  exit 1
fi

# Affiche la liste des groupes de volumes LVM existants
echo "Liste des groupes de volumes LVM existants :"
vgdisplay

# Demande à l'utilisateur de spécifier le groupe de volumes LVM auquel ajouter le disque
read -p "Entrez le nom du groupe de volumes LVM auquel ajouter le disque : " vg_name

# Vérifie si le groupe de volumes LVM spécifié existe
if ! vgdisplay "$vg_name" &>/dev/null; then
  echo "Le groupe de volumes LVM spécifié n'existe pas." >&2
  exit 1
fi

# Ajoute le disque au groupe de volumes LVM
echo "Ajout du disque $disk au groupe de volumes LVM $vg_name..."
vgextend "$vg_name" "$disk"

# Affiche à nouveau les informations sur le groupe de volumes LVM pour vérifier les modifications
echo "Informations mises à jour sur le groupe de volumes LVM $vg_name :"
vgdisplay "$vg_name"
