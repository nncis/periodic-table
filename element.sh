#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

RESULT() {
    ATOMIC_NUMBER=$1
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = $ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}
if [[ -z $INPUT ]]
then
echo Please provide an element as an argument.
fi
# #if input is a symbol
if [[ ${#INPUT} -lt 3 && ${#INPUT} -gt 0 ]] && [[ ! $INPUT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    RESULT $ATOMIC_NUMBER
  fi
fi
#if input is atomic number
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$INPUT'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    RESULT $ATOMIC_NUMBER
  fi
fi
# #if input it's the name of element
if [[ ${#INPUT} -gt 2 ]] && [[ ! $INPUT =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT'")
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo I could not find that element in the database.
  else
    RESULT $ATOMIC_NUMBER
  fi
fi
