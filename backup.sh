#!/bin/bash

set -Eeuo pipefail

DOSSIER=${1:-logs}
DESTINATION=${2:-backups}

# Verifier que le dossier source existe
if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier $DOSSIER n'existe pas." >&2
    exit 1
fi

# Creer le dossier de sauvegarde
mkdir -p "$DESTINATION"

# Creer un nom avec la date et l'heure
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DESTINATION/backup_$DATE.tar.gz"
LOG="backup.log"
# Creer l'archive compressee
tar -czf "$ARCHIVE" "$DOSSIER"

echo "[$DATE] Sauvegarde creee : $ARCHIVE" | tee -a "$LOG"

# Supprimer les sauvegardes de plus de 7 jours

 



for fichier in "$DESTINATION"/*.tar.gz; do
    if [ -f "$fichier" ] && [ "$fichier" != "$ARCHIVE" ]; then
        if find "$fichier" -maxdepth 0 -type f -mtime +7 -print -quit | grep -q .; then
            rm -- "$fichier"
            echo "[$DATE] Ancienne sauvegarde supprimee : $fichier" | tee -a "$LOG"
        fi
    fi
done
echo "[$DATE] Sauvegarde terminee." | tee -a "$LOG"
