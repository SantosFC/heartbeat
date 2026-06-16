#!/bin/bash

# Diretório a monitorar e diretório de backup (podem ser passados como argumentos)
WATCH_DIR="${1:-/tmp/monitored}"
BACKUP_DIR="${2:-/tmp/backup}"

if ! command -v inotifywait &>/dev/null; then
    echo "Erro: inotifywait não encontrado. Instale com: sudo apt install inotify-tools" >&2
    exit 1
fi

mkdir -p "$WATCH_DIR" "$BACKUP_DIR"

echo "Monitorando '$WATCH_DIR' → backups em '$BACKUP_DIR'"
echo "Pressione Ctrl+C para parar."

inotifywait -m -e close_write,moved_to --format '%f' "$WATCH_DIR" |
while IFS= read -r filename; do
    src="$WATCH_DIR/$filename"
    timestamp=$(date +%Y%m%d_%H%M%S)
    dest="$BACKUP_DIR/${filename%.*}_${timestamp}.${filename##*.}"

    # Arquivo sem extensão
    [[ "$filename" == "${filename##*.}" ]] && dest="$BACKUP_DIR/${filename}_${timestamp}"

    cp -- "$src" "$dest" && \
        echo "[$(date -Iseconds)] Backup: '$filename' → '$dest'"
done
