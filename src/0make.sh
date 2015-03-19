#!/bin/sh
rm -rf *.core
make  JOBS=8 pkg
rm -rf *.core
