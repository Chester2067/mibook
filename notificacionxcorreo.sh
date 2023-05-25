#!/bin/bash
EMAIL="grp-operaciones@prodigio.tech"
ASUNTO="Respaldo de base de datos completado Cliente TIEX"
MENSAJE="El respaldo de la base de datos se ha completado correctamente."
FILE="backups_`date +%d%b%Y_%H%M`.txt"

ls -lhtr  /backups > /backups/$FILE
 # Enviar correo 
echo "$MENSAJE" | mail -a "/backups/$FILE" -s "$ASUNTO" "$EMAIL"
rm -rf /backups/$FILE
