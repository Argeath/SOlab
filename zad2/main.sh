#!/bin/bash

NAZWA=""
KATALOG="."
PUSTY="B"
ZMIENIONY=0
ZAWARTOSC=""
WLASCICIEL=""

function printMenu {
  echo
  echo "Witaj w wyszukETIwarce. Opcje: "
  echo "1. Nazwa pliku: $NAZWA"
  echo "2. Katalog: $KATALOG"
  echo "3. Czy jest pusty? $PUSTY"
  echo "4. Zmieniony do x dni temu: $ZMIENIONY"
  echo "5. Wlasciciel pliku: $WLASCICIEL" 
  echo "6. Zawartość pliku: $ZAWARTOSC"
  echo "7. Szukaj!"
  echo "8. Zabierz mnie stąd"
  echo
}

OPCJA=0
while [ $OPCJA != 8 ]; do
  printMenu
  echo -n "Wybieram: "
  read OPCJA

  case "$OPCJA" in 
    1)  echo -n "Podaj nazwe pliku: "
        read NAZWA
	;;
    2)  echo -n "Podaj nazwe katalogu: "
	read KATALOG
	;;
    3)  echo -n "Czy plik jest pusty? (T - tak, N - nie, B - tak lub nie): "
	read PUSTY
	while [[ "$PUSTY" != "T" && "$PUSTY" != "N"  && "$PUSTY" != "B" ]]; do
	  echo -n "Sprobuj ponownie: "
	  read PUSTY
	  if [ $PUSTY = "t" ]; then
		PUSTY="T"
	  fi
	  if [ $PUSTY = "n" ]; then
		PUSTY="N"
	  fi
	  if [ $PUSTY = "b" ]; then
		PUSTY="B"
	  fi
	done
	;;
    4)  echo -n "Ilosc dni: "
        read ZMIENIONY
	;;
    5)  echo -n "Wlasciciel: "
	    read WLASCICIEL
	;;
    6)  echo -n "Zawartość: "
	    read ZAWARTOSC
	;;
    7)  echo "Znaleziono: "
        if [ ! -z $WLASCICIEL ]; then
            OWNERCMD="-user $WLASCICIEL"
        else
            OWNERCMD=""
        fi

        if [ $ZMIENIONY -gt 0 ]; then
            DNICMD="-atime $ZMIENIONY"
        else
            DNICMD=""
        fi

        if [ $PUSTY = "T" ]; then
            EMPTYCMD="-empty"
        elif [ $PUSTY = "N" ]; then
            EMPTYCMD="-not -empty"
        else
            EMPTYCMD=""
        fi

        #if [ ! -z $ZAWARTOSC ]; then
        #    CONTENTCMD="-type f -exec grep -l \"$ZAWARTOSC\" {} \\;"
        #else
        #    CONTENTCMD=""
        #fi

        RET=$(find $KATALOG -maxdepth 1 -iname "*$NAZWA*" $OWNERCMD $DNICMD $EMPTYCMD | sed "s#^$KATALOG[/]*# #")
        if [ ! -z $ZAWARTOSC ]; then
            grep -l "$ZAWARTOSC" $RET
        else
            echo $RET
        fi
    ;;
    *) OPCJA=0
  esac
done
