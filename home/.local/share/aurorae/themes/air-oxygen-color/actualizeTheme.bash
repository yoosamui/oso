#!/bin/bash

bash buildButtonFiles.bash
cp -R ../air-oxygen ../../.kde/share/apps/aurorae/themes/
kwin --replace & 
