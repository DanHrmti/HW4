#!/bin/bash

# save main news page html file to current dir:
wget https://www.ynetnews.com/category/3082
# create list of links in links.txt:
egrep -o "https://www.ynetnews.com/article/[A-Za-z0-9]{9}[^A-Za-z0-9]" 3082 \
> links.txt
# remove last character in every link:
sed -i 's/.$//g' links.txt
# sort and deduplicate links:
sort -uo links.txt links.txt
# write number of links to results file:
wc -l < links.txt > results.txt
# access each link and append search results to results.txt by format: 
while read link; do
  wget "$link"
  filename=$(echo "$link" | cut -d / -f5)
  N=$(grep -o Netanyahu $filename | wc -l) # count number of "Netanyahu" in file
  G=$(grep -o Gantz $filename | wc -l) # count number of "Gantz" in file
  if [ $N -eq 0 ] && [ $G -eq 0 ]; then
  	echo "$link, -" >> results.txt
  else
  	echo "$link, Netanyahu, $N, Gantz, $G" >> results.txt
  fi
  rm $filename
done < links.txt
# convert results to csv file and delete unecessary files:
mv results.txt results.csv
rm links.txt 3082
