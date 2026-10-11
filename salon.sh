#!/bin/bash
# https://www.freecodecamp.org/
# Curriculum: Relational Databases Certification
# Project: Build a Salon Appointment Scheduler
# Copyright (C) 2026 Maksim Petrenko


# Not constants (for test passing only)
#read SERVICE_ID_SELECTED
#read CUSTOMER_PHONE
#read CUSTOMER_NAME
#read SERVICE_TIME

# CONSTANTS
# Prompts
WELCOME="\n~~~~~ MY SALON ~~~~~\n\nWelcome to My Salon, how can I help you?\n\n"
SERVICES="1) cut\n2) color\n3) perm\n4) style\n5) trim\n"
ID_NOT_FOUND="\nI could not find that service. What would you like today?\n"
PHONE_PROMPT="\nWhat's your phone number?\n"
NAME_PROMPT="\nI don't have a record for that phone number, what's your name?\n"
TIME_PROMPT="\nWhat time would you like your %s, %s?\n"
MESSAGE="\nI have put you down for a %s at %s, %s.\n"
# Parameterized queries
SELECT_SERVICE_NAME="
SELECT name
FROM services
WHERE service_id = :service_id;"
SELECT_CUSTOMER_INFO="
SELECT customer_id, name
FROM customers
WHERE phone = :phone;"
INSERT_CUSTOMER="
INSERT INTO customers VALUES (:customer_id, :phone, :name);"
INSERT_APPOINTMENT="
INSERT INTO appointments VALUES (:appointment_id, :service_id, :customer_id, :time);"
# Options
DB_USER="freecodecamp"
DB_NAME="salon"


# Function

main () {
    printf "$WELCOME"

    # services
    while true
    do
        printf "$SERVICES"
        read service_id_selected
        case "$service_id_selected" in
            1|2|3|4|5) break ;;
            *) printf "$ID_NOT_FOUND" ;;
        esac
    done
    service_name=$(echo "$SELECT_SERVICE_NAME" | psql -U "$DB_USER" -d "$DB_NAME" -At -v service_id="$service_id_selected")

    # customers
    printf "$PHONE_PROMPT"
    read customer_phone
    # TODO: validate customer_phone
    customer_info=$(echo "$SELECT_CUSTOMER_INFO" | psql -U "$DB_USER" -d "$DB_NAME" -At -v phone="'""$customer_phone""'")
    if [ -z "$customer_info" ]
    then
        printf "$NAME_PROMPT"
        read customer_name
        # TODO: validate customer_name
        customer_id="$RANDOM"
        status=$(echo "$INSERT_CUSTOMER" | psql -U "$DB_USER" -d "$DB_NAME" -At -v customer_id="$customer_id" -v phone="'""$customer_phone""'" -v name="'""$customer_name""'")
        # TODO: check status
    else
        customer_id=$(echo "$customer_info" | cut -d "|" -f 1)
        customer_name=$(echo "$customer_info" | cut -d "|" -f 2)
    fi

    # appointments
    printf "$TIME_PROMPT" "$service_name" "$customer_name"
    read service_time
    # TODO: validate service_time
    appointment_id="$RANDOM"
    status=$(echo "$INSERT_APPOINTMENT" | psql -U "$DB_USER" -d "$DB_NAME" -At -v appointment_id="$appointment_id" -v service_id="$service_id_selected" -v customer_id="$customer_id" -v time="'""$service_time""'")
    # TODO: check status
    printf "$MESSAGE" "$service_name" "$service_time" "$customer_name"
}


# Create the database
# PostgreSQL
#dropdb --if-exists -U "$DB_USER" "$DB_NAME"
#createdb -U "$DB_USER" "$DB_NAME"
#psql -U "$DB_USER" "$DB_NAME" < salon.sql

# Execution
main
