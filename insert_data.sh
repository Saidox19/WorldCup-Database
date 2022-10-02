#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#! /bin/bash
echo $($PSQL "TRUNCATE teams, games")
echo -e "\n~~ Building and Querying a World Cup Database \n"

#Read the column in the CSV file 
cat games.csv | while IFS=(,) read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #Get the winner id  from the team table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")

    #If winner id not found
    if [[ -z $WINNER_ID ]]
    then
      #Insert the Values
      INSERT_WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      if [[ $INSERT_WINNER_ID_RESULT == "INSERT 0 1" ]]
      then
        echo -e Inserted into teams, $WINNER
      fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
    fi
  #Get opponent data from the game.csv file
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT")

    #IF NOT FOUND
    if [[ -z $OPPONENT_ID ]]
    then
      #Inseert the values
      INSERT_OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT_ID_RESULT == "INSERT 0 1" ]]
      then
        echo -e Inserted into teams, $OPPONENT
      fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'")
    fi
  
  fi
  INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
  then
    echo -e Inserted into games, $WINNER $OPPONENT
  fi 
done