#!/bin/bash

brew install gnupg
mkdir ~/.gnupg
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;