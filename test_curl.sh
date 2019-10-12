#!/bin/bash

# curl -ig 'localhost:8080/iv/welcome'

# curl -ig 'localhost:8080/iv/notes?page=2&per_page=12'

curl -ig 'localhost:8080/iv/notes' -X POST -d '
{
    "content": "i like, i love by curl."
}'