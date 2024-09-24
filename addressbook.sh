#!/bin/bash

BUCKET_NAME="my-address-book-bucket"   
ADDRESS_BOOK_FILE="addressbook.txt"     


if [ ! -f "$ADDRESS_BOOK_FILE" ]; then
    touch "$ADDRESS_BOOK_FILE"
fi


add_contact() {
  echo "Enter Name:"
  read name
  echo "Enter Phone Number:"
  read phone
  echo "Enter Email:"
  read email

  echo "$name, $phone, $email" >> "$ADDRESS_BOOK_FILE"

  aws s3 cp "$ADDRESS_BOOK_FILE" "s3://$BUCKET_NAME/$ADDRESS_BOOK_FILE"

  echo "Contact added successfully!"
}

search_contact() {
  echo "Enter search term:"
  read search_term

  
  aws s3 cp "s3://$BUCKET_NAME/$ADDRESS_BOOK_FILE" "$ADDRESS_BOOK_FILE"

  
  grep -i "$search_term" "$ADDRESS_BOOK_FILE"
}


remove_contact() {
  echo "Enter the name, phone, or email of the contact to remove:"
  read search_term

  
  aws s3 cp "s3://$BUCKET_NAME/$ADDRESS_BOOK_FILE" "$ADDRESS_BOOK_FILE"

  
  grep -v -i "$search_term" "$ADDRESS_BOOK_FILE" > temp.txt
  mv temp.txt "$ADDRESS_BOOK_FILE"

  
  aws s3 cp "$ADDRESS_BOOK_FILE" "s3://$BUCKET_NAME/$ADDRESS_BOOK_FILE"

  echo "Contact removed successfully!"
}

if [ "$1" == "add" ]; then
  add_contact
elif [ "$1" == "search" ]; then
  search_contact
elif [ "$1" == "remove" ]; then
  remove_contact
else
  echo "Usage: $0 {add|search|remove}"
fi
