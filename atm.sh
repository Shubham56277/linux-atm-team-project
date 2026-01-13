#!/bin/bash

echo "------ Welcome to ATM ------"

read -p "Enter Account Number: " acc_no
read -sp "Enter PIN: " entered_pin
echo

receipt_file="receipt.txt"

# find account line
account=$(grep "^$acc_no|" accounts.txt)

if [ "$account" = "" ]; then
    echo "Account not found!"
    exit
fi

# split data
IFS="|" read acc pin balance last_transaction <<< "$account"

if [ "$entered_pin" != "$pin" ]; then
    echo "Wrong PIN!"
    exit
fi

echo "Login successful!"

while true; do
    echo "----- ATM Menu -----"
    echo "1. Check Balance"
    echo "2. Withdraw Money"
    echo "3. Deposit Money"
    echo "4. Transaction Receipt"
    echo "5. Exit"
    read -p "Choose option: " choice

    case $choice in
        1)
            echo "Balance: $balance"

            echo "-----------------------------" >> "$receipt_file"
            echo "Account No : $acc_no" >> "$receipt_file"
            echo "BALANCE CHECKED" >> "$receipt_file"
            echo "Balance : $balance" >> "$receipt_file"
            ;;

        2)
            read -p "Enter amount to withdraw: " amt
            if [ $amt -le $balance ]; then
                balance=$((balance - amt))
                last_transaction="Withdraw $amt"
                echo "Withdraw successful"

                echo "-----------------------------" >> "$receipt_file"
                echo "Account No : $acc_no" >> "$receipt_file"
                echo "WITHDRAW : $amt" >> "$receipt_file"
                echo "Balance  : $balance" >> "$receipt_file"
            else
                echo "Insufficient balance"
            fi
            ;;

        3)
            read -p "Enter amount to deposit: " amt
            balance=$((balance + amt))
            last_transaction="Deposit $amt"
            echo "Deposit successful"

            echo "-----------------------------" >> "$receipt_file"
            echo "Account No : $acc_no" >> "$receipt_file"
            echo "DEPOSIT : $amt" >> "$receipt_file"
            echo "Balance : $balance" >> "$receipt_file"
            ;;

        4)
            echo "----- TRANSACTION RECEIPT -----"
            if [ -f "$receipt_file" ]; then
                cat "$receipt_file"
            else
                echo "No transactions found"
            fi
            ;;

        5)
            break
            ;;

        *)
            echo "Invalid choice"
            ;;
    esac
done

# update file (overwrite old data)
grep -v "^$acc_no|" accounts.txt > temp.txt
echo "$acc_no|$pin|$balance|$last_transaction" >> temp.txt
mv temp.txt accounts.txt

echo "Thank you for using ATM"
