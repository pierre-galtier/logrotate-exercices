#!/bin/bash

# consigne : faire un script de backup en fonction de 4 options qui seront groupés dans un tar selon le format user-option-choisie-jj-MOIS-aaaa.tar.gz dans le rep /var/backup/

# script à lancer en sudo pour pouvoir deplacer dans /var/backup/
# pas oublier l'arg selon l'option choisie

fichiers-crees-moins-7-jours() {
    find "$1" -type f -ctime -7 -exec cp {} "$user-tmp" \;
}

fichiers-modifies-plus-7-jours() {
    find "$1" -type f -mtime +7 -exec cp {} "$user-tmp" \;
}

repertoires-superieur-10-mo() {
    find "$1" -type d -size +10M -exec cp {} "$user-tmp" \;
}

repertoires-et-fichiers-caches() {
    find "$1" -name "\.*" -exec cp {} "$user-tmp" \;
}

# pour lister les utilisateurs qui ont un home
users=`ls /home`

# la date
date=`date +%d-%^b-%Y | sed s/"\."//` # le sed permet de passer 09-SEPT.-2023 à 09-SEPT-2023

for user in $users;
do
    mkdir "$user-tmp" #creation d'un rep juste pour pouvoir le tar

    case $1 in #l'argument quand on lance le script
        "1")
            fichiers-crees-moins-7-jours "/home/$user"
            choix="fichiers-crees-moins-7-jours"
            ;;
        "2")
            fichiers-modifies-plus-7-jours "/home/$user"
            choix="fichiers-modifies-plus-7-jours"
            ;;
        "3")
            repertoires-superieur-10-mo "/home/$user"
            choix="repertoires-superieur-10-mo"
            ;;
        "4")    
            repertoires-et-fichiers-caches "/home/$user"
            choix="repertoires-et-fichiers-caches"
            ;;
        "*")
            exit 1
            ;;
    esac

    tar_name="$user-$choix-$date".tar.gz

    tar -cf $tar_name "$user-tmp"           # pour créer une archive contenant le resultat du choix precedent avec le nom de l'archive user-date (-f)
    chmod 700 $tar_name                     # Les backups seront rwx que par l’utilisateur concerné
    chown $user: $tar_name                  # donne la propriété du tar à l'utilisateur concerné
    mv $tar_name "/var/backup/"             # pour déplacer le fichier tar vers la destination demandée
    rm -rf "$user-tmp"                      # supprime le dossier temporaire

done

echo "apperçu de /var/backup :"
ls -la /var/backup/