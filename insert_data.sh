#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $WINNER
      fi
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    #get opponent_id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi

    #insert in games
    GAME_ID=$($PSQL "select game_id from games where year=$YEAR AND round='$ROUND' AND winner_id=$WINNER_ID")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $WINNER $WINNER_GOALS-$OPPONENT_GOALS $OPPONENT 
      fi
    fi

  fi
done
