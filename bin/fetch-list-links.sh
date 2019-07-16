#!/bin/bash

link_url=$1

./script/volmoe-list-scraper.rb "$link_url" |
  while IFS= read -r line
  do
    ./script/volmoe-link-scraper.rb epub "$line"
  done
