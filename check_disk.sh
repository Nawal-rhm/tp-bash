#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : espace disque utilise à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 1
else
    echo "Disque OK : espace utilise à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 0
fi
