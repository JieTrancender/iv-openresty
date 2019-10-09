#!/bin/bash

# curl -ig 'localhost:6080/iv/welcome'

curl -ig 'localhost:6080/iv/notes'

# curl -ig 'localhost:6080/iv/notes' -X POST -d '
# {
    # "content": "i like, i love."
# }'