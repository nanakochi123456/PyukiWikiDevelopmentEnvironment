#!/bin/sh
rm -rf *.core
make  JOBS=12 release
rm -rf *.core
