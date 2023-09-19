#!/bin/bash

# consigne : pour 2 dates données en arg, faire un tar des logs compris dans l'intervalle

# on recupere les dates au format à la française passées en arg
d1="$1"
d2="$2"

recuperer-data-entre-deux-dates() {
    
    # on les reformate en aaaa-mm-jj puis en timestamp
    j1=$(echo "$d1" | cut -d'-' -f1)
    m1=$(echo "$d1" | cut -d'-' -f2)
    a1=$(echo "$d1" | cut -d'-' -f3)
    d1="$a1-$m1-$j1" # en aaaa-mm-jj
    d1=$(date -d "$d1" +%s) # en timestamp

    j2=$(echo "$d2" | cut -d'-' -f1)
    m2=$(echo "$d2" | cut -d'-' -f2)
    a2=$(echo "$d2" | cut -d'-' -f3)
    d2="$a2-$m2-$j2" #en aaaa-mm-jj
    d2=$(date -d "$d2" +%s) #en timestamp

    touch tmp.txt

    # boucle while qui va lire le contenu du fichier de logs
    cat $file | while  read ligne ;
    do
        log_date=`echo $ligne | awk '{ print $1, $2 }'`             # on extrait les deux premieres colonnes dans les logs et on les mets dans log_date
        log_date=`date -d "$log_date" "+%Y-%m-%d"`                  # on formate log_date (qui est en SEP 8) en aaaa-mm-jj
        log_date=$(date -d "$log_date" +%s)                         # on convertie log_date en timestamp
        if [ $log_date -ge $d1 ] && [ $log_date -le $d2 ];          # (on utilise un if pour comparer des nb puisque dates converties en nb) on vérifie si $d1 >= log_date <= $d2
        then
            echo $ligne >> tmp.txt                                  #si oui, on ajoute la ligne à tmp.txt
        fi
    done

    # creation du fichier tar selon format demandé dans la consigne
    date=`date +%d-%^b-%Y | sed s/"\."//` # le sed permet de passer 09-SEPT.-2023 à 09-SEPT-2023
    tar_name="recuperation-$date.tar.gz"
    tar -cf $tar_name "tmp.txt" # on tar le fichier tmp avec le nom choisi dans tar_name
    mv $tar_name "/var/backup/"
    rm -rf "tmp.txt"
}

file="/var/log/auth.log"
recuperer-data-entre-deux-dates $file
echo "apperçu de /var/backup :"
ls -la /var/backup/