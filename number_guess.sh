#! /bin/bash

MAIN_FUCTION(){

  # PSQL connection
  PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

  echo "Enter your username:"
  read USERNAME

  # Load user data
  USER_DATA=$($PSQL "SELECT user_id, tries_best_game, games_played_overall FROM users INNER JOIN games USING (user_id) WHERE name='$USERNAME'")

  # if user not exists
  if [[ -z $USER_ID ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_NEW_USER=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if user exists
  else
    echo $USER_DATA | while IFS='|' read USER_ID TRIES_BEST_GAME GAMES_PLAYED_OVERALL
    do
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED_OVERALL games, and your best game took $TRIES_BEST_GAME guesses."
    done
  fi

  # start guess game
  # Create random number between 1 and 1000
  RANDOME_NUMBER=$((( RANDOM % 1000 )  + 1 ))

  # Ask user to guess a number
  echo "Guess the secret number between 1 and 1000:"

  # count for tries
  GUESS_TRIES=0

  # loop for the game
  while [[ $RANDOME_NUMBER != $NUMBER_USER_GUESS ]] || [[ -z $NUMBER_USER_GUESS ]]
  do

    read NUMBER_USER_GUESS

    # if number user guess is not a INT
    if [[ NUMBER_USER_GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"

    else
      # if randome number is bigger
      if [ $NUMBER_USER_GUESS -lt $RANDOME_NUMBER ]
      then
        echo "It's higher than that, guess again:"

      # if randome number is smaller
      else
        echo "It's lower than that, guess again:"
      fi

      #add a guess count
      GUESS_TRIES=$(( $GUESS_TRIES + 1 ))
    fi
  done

}




MAIN_FUCTION