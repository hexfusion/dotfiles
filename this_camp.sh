shopt -s extglob
camp=$1
if [ ! "$camp" ]
then
    camp=${PWD#$HOME/}
fi
camp=${camp%%/*}
campno=${camp%%+(digit:)}
if [ "$camp" != "$campno" ]; then echo $camp; exit; fi
exit
