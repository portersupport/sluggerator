
log () {
  echo "       $1"
}

killfile () {
  if [[ -z "$DRY_RUN" ]]; then
#    echo "REAL: rm -f $1"
    rm -f $1
  else
    log "DRY: rm -f $1"
  fi
}

killdir () {
  if [[ -z "$DRY_RUN" ]]; then
#    echo "REAL: rm -rf $1"
    rm -rf $1
  else
    log "DRY: rm -rf $1"
  fi
}

slugitout () {
  log "Finding files for $1"

  sluggy="$(ls -1d $1 2>/dev/null || echo '')"

  if [[ -z "$sluggy" ]]; then
    log "  WARN: No files found!"
    return
  fi

  tf="$(mktemp)"

  echo "$sluggy" > $tf

  while read -r line_item; do
    log "  Deleting $line_item"

    if [[ -f "$line_item" ]]; then
      killfile $line_item
    elif [[ -d "$line_item" ]]; then
      killdir $line_item
    else
      log "  WARN: No file or directory: $line_item"
    fi
  done < $tf
}
