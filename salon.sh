#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

#display services
  echo -e "\nWelcome to My Salon, what do you want to do today? :D"
  SERVICE=$($PSQL "SELECT service_id, name FROM services")
  echo -e "\n$SERVICE" | sed 's/ |/)/g'
  read SERVICE_ID_SELECTED

#if not valid
  if [[ $($PSQL "SELECT COUNT(service_id) FROM services WHERE service_id = $SERVICE_ID_SELECTED") -eq 0 ]]
  then
  MAIN_MENU "Sorry, I couldn't find the service :( Please choose another service."

#service selected
  else
  #get phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  
  #if not found
  if [[ $($PSQL "SELECT COUNT(phone) FROM customers WHERE phone = '$CUSTOMER_PHONE'") -eq 0 ]]
  then
  #get name
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  
  #get service choice
  SERVICE_CHOICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  #get time
  echo -e "\nWhat time would you like to $(echo $SERVICE_CHOICE | sed 's/^ *//g') your hair, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  #insert into customers
  INSERT_CUSTOMERS_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  
  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
  
  echo -e "\nI have put you down for a $(echo $SERVICE_CHOICE | sed 's/^ *//g') at $SERVICE_TIME, $CUSTOMER_NAME."
  echo -e "\nThank you, have a good hair day."

  else 
  #get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #get service choice
  SERVICE_CHOICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  #get time
  echo -e "\nWhat time would you like to $(echo $SERVICE_CHOICE | sed 's/^ *//g') your hair, $(echo $CUSTOMER_NAME | sed 's/^ *//g')?"
  read SERVICE_TIME
  
  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")
  
  echo -e "\nI have put you down for a $(echo $SERVICE_CHOICE | sed 's/^ *//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/^ *//g')."
  echo -e "\nThank you, have a good hair day."

  fi
  fi
}

MAIN_MENU