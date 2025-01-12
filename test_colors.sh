#!/bin/bash
# Basic colors
echo -e "\e[31mRed\e[0m \e[32mGreen\e[0m \e[34mBlue\e[0m"
# Compound colors
echo -e "\e[1;31mBright Red\e[0m \e[1;32mBright Green\e[0m"
# Multiple colors on one line
echo -e "\e[33mYellow\e[0m and \e[35mMagenta\e[0m and \e[36mCyan\e[0m"
# Command outputs
ls --color=always
git -c color.status=always -c color.ui=always status
