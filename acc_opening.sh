#!/bin/bash

echo "------ Account Opening ------"

read -p "Enter new account number: " acc_no
read -sp "Set your PIN: " pin
echo
read -p "Enter opening balance: " balance

# save data in text file
echo "$acc_no|$pin|$balance|No transaction" >> accounts.txt

echo "Account created successfully!"
echo "You can now use ATM."
