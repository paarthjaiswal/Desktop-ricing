#!/bin/bash

brightnessctl set 5%-
pkill -SIGRTMIN+1 waybar
