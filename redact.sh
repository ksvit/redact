#!/bin/bash

#loop through file of words to redact
while read word; do
    # inner loop to loop through file to change
    while read line; do   
        #replace word with ----
        sed -i "s/$word/"\-\-\-\-"/g" $1
    #end inner loop
    done < $1 
#end outer loop
done < $2

#create new temp file
> temp.txt
#loop through file one more time to replace lines if necessary
while read line; do
  #check if two sets of dashes are found on same line
  echo $line | grep -q .*\-\-\-\-.*\-\-\-\-.*
  #if grep found a match, then...
    if [ $? -eq 0 ]; then
        #count number of chars on the line
        totalChars=$(echo $line | wc -m)
        #for add a new dash totalChars number of times
        for i in $(seq 1 $totalChars); do
        #print a new dash into temp file
        echo -n "-" >> temp.txt
        done
        #print a new line character after every line
        echo >> temp.txt
    #debug to make sure loop runs
    #echo $totalChars
    else
        #print line as is if pattern not found
        echo $line >> temp.txt
    fi
 done < $1
 
 #copy temp file to original file
 cp temp.txt $1
 #remove temp file because it was supposed to be temporary
 rm temp.txt