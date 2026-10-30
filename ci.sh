
#!/bin/bash

set -Eeuo pipefail

# Vérifier si l'argument est fourni
if [ -z "${1:-}" ]; then
    echo "Erreur : veuillez fournir l'URL du dépôt Git."
    exit 1
fi

# Récupérer l'argument
REPO_URL="$1"

# Définir le nom du dossier du projet
PROJECT_DIR="projet-ci"

# Définir le fichier journal
LOG_FILE="ci.log"
# Fonction pour enregistrer les messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}
# Fonction pour récupérer le dépôt Git
get_project() {
    if [ -d "$PROJECT_DIR" ]; then
        log "Le projet existe déjà. Mise à jour..."
        git -C "$PROJECT_DIR" pull
    else
        log "Clonage du dépôt Git..."
        git clone "$REPO_URL" "$PROJECT_DIR"
    fi
}
# Fonction pour simuler les tests
run_tests() {
    log "Début des tests..."

    # Simulation d'un test réussi
    if [ -f "$PROJECT_DIR/README.md" ]; then
        log "Test réussi : README.md existe."
    else
        log "Erreur : README.md est absent."
        return 1
    fi

    log "Tous les tests sont réussis."
}
# Pipeline principal
main() {
    log "========== Début du pipeline CI =========="

    # Étape 1 : récupérer le projet
    log "Étape 1 : récupération du projet"
    get_project || return 1
    log "Récupération terminée."

    # Étape 2 : exécuter les tests
    log "Étape 2 : exécution des tests"
    run_tests || return 1
    log "Tests terminés avec succès."

    log "========== Pipeline terminé avec succès =========="
}

# Exécuter le pipeline
if main; then
    exit 0
else
    log "ÉCHEC : le pipeline a rencontré une erreur."
    exit 1
fi
