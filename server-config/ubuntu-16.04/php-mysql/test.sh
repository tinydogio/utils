#!/usr/bin/env bash

echo "Please enter your name: "
read name

if [ $name = "Joshua" ]; then
    echo "Hello $name"
else
    echo "I don't know you $name."
fi
