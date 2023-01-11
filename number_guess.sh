#! /bin/bash

MAIN_FUCTION(){

  # PSQL connection
  PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

  echo "Enter your username:"
  read USERNAME

  # Load user data
  USER_DATA=$($PSQL "SELECT user_id, games_played_overall, tries_best_game FROM users INNER JOIN games USING (user_id) WHERE name='$USERNAME'")

  # if user not exists
  if [[ -z $USER_DATA ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_NEW_USER_TO_USERS=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
    INSERT_NEW_USER_TO_GAMES=$($PSQL "INSERT INTO games(user_id,  games_played_overall) VALUES($USER_ID ,  0)")
    USER_DATA=$($PSQL "SELECT user_id, games_played_overall, tries_best_game FROM users INNER JOIN games USING (user_id) WHERE name='$USERNAME'")

  # if user exists
  else
    echo $USER_DATA | while IFS='|' read USER_ID GAMES_PLAYED_OVERALL TRIES_BEST_GAME
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
    if [[ ! $NUMBER_USER_GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"

    else
      # if randome number is bigger
      if [ $NUMBER_USER_GUESS -lt $RANDOME_NUMBER ]
      then
        echo "It's higher than that, guess again:"

      # if randome number is smaller
      elif [ $NUMBER_USER_GUESS -gt $RANDOME_NUMBER ]
      then
        echo "It's lower than that, guess again:"
      
      fi

      #add a guess count
      GUESS_TRIES=$(( $GUESS_TRIES + 1 ))
    fi
  done

  echo "You guessed it in $GUESS_TRIES tries. The secret number was $RANDOME_NUMBER. Nice job!"

  # UPDATE DATA in  DATABASE
  echo $USER_DATA | while IFS='|' read USER_ID GAMES_PLAYED_OVERALL TRIES_BEST_GAME
    do
      # if first game INSERT data
      if [[ -z $TRIES_BEST_GAME ]]
      then
        UPDATE_DATA=$($PSQL "UPDATE games SET tries_best_game=$GUESS_TRIES, games_played_overall=$(( $GAMES_PLAYED_OVERALL + 1)) WHERE user_id=$USER_ID")

      # if new best game
      elif [[ $TRIES_BEST_GAME > $GUESS_TRIES ]]
      then
        UPDATE_DATA=$($PSQL "UPDATE games SET tries_best_game=$GUESS_TRIES, games_played_overall=$(( $GAMES_PLAYED_OVERALL + 1)) WHERE user_id=$USER_ID")

      # if worst games 
      else
        UPDATE_DATA=$($PSQL "UPDATE games SET games_played_overall=$(( $GAMES_PLAYED_OVERALL + 1)) WHERE user_id=$USER_ID")

      fi
    done
}




MAIN_FUCTION