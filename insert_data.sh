#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #check winner team
    winner_id=$($PSQL "select team_id from teams where name = '$WINNER'")
    #if not insert
    if [[ -z $winner_id ]]
    then
      echo $($PSQL "insert into teams(name) values('$WINNER')")
      winner_id=$($PSQL "select team_id from teams where name = '$WINNER'")
      
    fi

    #check opponent team
    opponen_id=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    #if not insert
    if [[ -z $opponen_id ]]
    then
      echo $($PSQL "insert into teams(name) values ('$OPPONENT')")
      opponen_id=$($PSQL "select team_id from teams where name = '$OPPONENT'")
      
    fi

    #insert info into games table
    echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $winner_id, $opponen_id, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done
