#!/bin/bash

# consigne : faire un script qui, avec tshark, va capturer les paquets réseau pendant 1mn et croner pour qu'il se lance ttes les 5mn puis faire un logrotate

# ce script ne peut etre lancé qu'en tant que root

# au préalable : sudo apt-get update & sudo apt-get install tshark

# capture les trames circulants sur le réseau pendant 1 minute et les sauvegarde dans le fichier "/var/log/tshark.log" :
tshark -a duration:60 -w "/var/log/tshark.log"

# pour automatiser ce script pour qu’il se lance toutes les 5 minutes avec un cron :
# crontab -e : pour éditer la crontab de root
# aller sur crontab.guru pour générer la ligne : "toutes les 5mn" = */5 * * * *
# on ajoute donc dans la crontab : */5 * * * * /opt/job3.sh

# pour mettre en place une rotation de logs lorsque le fichier /var/log/tshark.log fera plus 1 Mo
# installer logrotate
# dans /etc/logrotate.d on créé le fichier tshark-logrotate-job3 : sudo touch tshark-logrotate-job3
# sudo chmod 700 tshark-logrotate-job3
# puis on ajoute cette config :
#/var/log/tshark.log {
#    size 1M    -> lorsque tshark.log atteint 1 Mo
#    rotate 4   -> logrotate conserve 4 fichiers de logs
#    compress   -> pour créer les fichiers en tar gz
#}
# pour tester logrotate : logrotate -f tshark-logrotate-job3

echo "apperçu de /var/log/ :"
ls -la /var/log/