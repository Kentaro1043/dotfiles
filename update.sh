#!/bin/bash

home-manager switch --flake .#kentaro@$(cat /etc/hostname)
