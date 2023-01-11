#! /bin/bash

MAIN_FUCTION(){

  # PSQL connection
  PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

  echo "Enter your username:"
  read USERNAME

  # Load user data
  USER_DATA=$($PSQL "SELECT tries_best_game, games_played_overall FROM users INNER JOIN games USING (user_id) WHERE name='$USERNAME'")

  # if user not exists
  if [[ -z $USER_ID ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."

  # if user exists
  else
    echo $USER_DATA | while IFS='|' read TRIES_BEST_GAME GAMES_PLAYED_OVERALL
    do
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED_OVERALL games, and your best game took $TRIES_BEST_GAME guesses."
    done
  fi
}

NUMBER_GUESS_GAME(){

  # Create random number betwwen 1 and 1000
  RANDOM_NUMBER=$((( RANDOM % 1000 )  + 1 ))

  # Ask user to guess a number
  echo "Guess the secret number between 1 and 1000:"
  read NUMBER_USER_GUESS

}

MAIN_FUCTION