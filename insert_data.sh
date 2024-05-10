#! /bin/bash

if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS; do

  # Inserting data to teams table
  if [[ $WINNER_NAME != "winner" ]]; then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER_NAME'")

    if [[ -z $WINNER_ID ]]; then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER_NAME')")
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]; then
        echo INSERT_WINNER_NAME, $WINNER_NAME
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER_NAME'")
    fi
  fi

  if [[ $OPPONENT_NAME != "opponent" ]]; then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT_NAME'")

    if [[ -z $OPPONENT_ID ]]; then
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT_NAME')")
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]; then
        echo INSERT_OPPONENT_NAME, $OPPONENT_NAME
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT_NAME'")
    fi
  fi

  # Inserting data to games table
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_GAME == "INSERT 0 1" ]]; then
    echo INSERT_GAME, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
  fi
  
done
