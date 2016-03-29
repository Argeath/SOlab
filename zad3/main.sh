#!/bin/bash

NAZWAPROGRAMU="WyszukETIwarka"

NAZWA=""
KATALOG="."
PUSTY="Obojetnie"
ZMIENIONY=0
ZAWARTOSC=""
WLASCICIEL=""
informacja=""

menu=("Nazwa pliku" "Katalog" "Czy jest pusty?" "Zmienione do x dni temu" "Wlasciciel pliku" "Zawartosc pliku" "Szukaj!")

function printMenu {
    informacja="Witaj w WyszukETIwarce.\nSprecyzuj filtry, po ktorych chcesz wyszukac plik:\n"
    informacja="$informacja\nNazwa pliku: $NAZWA\nKatalog: $KATALOG\nCzy jest pusty? $PUSTY\nZmieniony do $ZMIENIONY dni temu\nWlasciciel: $WLASCICIEL\nZawartosc: $ZAWARTOSC"
}

OPCJA=0
while true; do
  printMenu
  OPCJA=$(zenity --list --height 450 --title=$NAZWAPROGRAMU --text="$informacja" --cancel-label "Wyjdz" --ok-label "Wybierz opcję" --column="Menu" "${menu[@]}")
  if [[ $? -eq 1 ]]; then
    break
  fi

  case "$OPCJA" in 
    "${menu[0]}")
        NAZWA=$(zenity --entry --title $NAZWAPROGRAMU --text "Podaj nazwe pliku: " --height 120)
        if [ -z NAZWA ]; then
            NAZWA=""
        fi
	;;
    "${menu[1]}")
        KATALOG=$(zenity --entry --title $NAZWAPROGRAMU --text "Podaj katalog: " --height 120)
        if [ -z KATALOG ]; then
            KATALOG="."
        fi
	;;
    "${menu[2]}")
        PUSTY=$(zenity --list --title $NAZWAPROGRAMU --text "Czy plik jest pusty?" --height 200 --radiolist --column "Wybierz" --column "Opcja" TRUE Obojetnie FALSE Nie FALSE Tak)
	;;
    "${menu[3]}")
        ZMIENIONY=$(zenity --scale --title $NAZWAPROGRAMU --text "Zmienione do x dni temu" --height 120 --value=0 --max-value=365)
    ;;
    "${menu[4]}")
        WLASCICIEL=$(zenity --entry --title $NAZWAPROGRAMU --text "Podaj wlasciciela: " --height 120)
	;;
    "${menu[5]}")
        ZAWARTOSC=$(zenity --entry --title $NAZWAPROGRAMU --text "Podaj zawartosc: " --height 120)
	;;
    "${menu[6]}")
	if [ ! -z $WLASCICIEL ]; then
            OWNERCMD="-user $WLASCICIEL"
        else
            OWNERCMD=""
        fi

        if [ $ZMIENIONY -gt 0 ]; then
            DNICMD="-atime -$ZMIENIONY"
        else
            DNICMD=""
        fi

        if [ $PUSTY = "Tak" ]; then
            EMPTYCMD="-empty"
        elif [ $PUSTY = "Nie" ]; then
            EMPTYCMD="-not -empty"
        else
            EMPTYCMD=""
        fi
        echo $DNICMD
        RET=$(find $KATALOG -maxdepth 1 -iname "*$NAZWA*" $OWNERCMD $DNICMD $EMPTYCMD | sed "s#^$KATALOG[/]*# #")
        if [ ! -z $ZAWARTOSC ]; then
            grep -l "$ZAWARTOSC" $RET | zenity --list --title=$NAZWAPROGRAMU --text="Znaleziono a:" --column="Plik/katalog" --height 400
        else
            zenity --list --title=$NAZWAPROGRAMU --text="Znaleziono:" --column="Plik/katalog" $RET --height 400
        fi
	;;
	*) echo "no marked";;
  esac
done
