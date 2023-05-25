#!/bin/bash

######################################################
#                                    DBA                                                                                    #
# Nombre del script: expdp_.sh                                                                   #
# Descripcion: Generar backup full de la BD                                          #
# Fecha creacion:                                                                                               #
# Creado por:                                                                                                       #
# Fecha modificacion:                                                                                     #
# Modificado por:                                                                                              #
######################################################

######################
# SETEO DE VARIABLES #
######################
export TMP=/tmp
export TMPDIR=$TMP

export ORACLE_HOSTNAME=db11g.localdomain
export ORACLE_UNQNAME=DB11G
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0.4/db_1
export ORACLE_SID=DB11G
export ORACLE_TERM=xterm
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export ORACLE_SCHEMA1=B2_TRACKING2

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

export ruta=/backups
export fecha=`date +%d%b%Y`

#######################
# 5 DIAS DE RETENCION     #
#######################
find $ruta/$ORACLE_SCHEMA1*.* -type f -mtime +5 -exec rm -f {} \;

##############################
# EXPORT DE LA BASE DE DATOS     #
##############################

expdp system/12345678 schemas=B2_TRACKING2 directory=EXPORT1 dumpfile=$ORACLE_SCHEMA1'_'$fecha.dmp  logfile=$ORACLE_SCHEMA1'_'$fecha.log  exclude=statistics
####################
# COMPRIMIR BACKUP #
####################
OUTRUTA=$ruta/$ORACLE_SCHEMA1'_'$fecha.dmp
#OUTRUTA=/backups/B2_TRACKING2_15may2023.dmp
gzip $OUTRUTA
######################
# SUBIR BACKUP A GCP #
######################
export LD_LIBRARY_PATH=/usr/lib64/:$LD_LIBRARY_PATH
cd /home/oracle/script_backup
python3 uploadfile.py $(echo ${OUTRUTA}.gz) >> ~/script_backup/uploadp.log
python3 uploadfile.py ./uploadp.log >> ~/script_backup/uploadp.log
