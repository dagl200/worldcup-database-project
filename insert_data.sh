#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

  R3=$($PSQL "TRUNCATE TABLE teams, games;")

  echo -e "\n~~ Insert data script ~~\n"

  sed 1d games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOAL OGOAL ;do

  #Get Winner id from teams table
  WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER';")

  #If not found insert Winner info into table teams 
  if [[ -z $WINNER_ID ]]
  then
  R1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
  WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER';")
  fi

  #Get Opponent id from teams table
  OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT';")

  #If not found insert Opponent info into table teams 
  if [[ -z $OPPONENT_ID ]]
  then
  R2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
  OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT';")
  fi
 
  #Insert information to games table
  echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WGOAL,$OGOAL);")
  done