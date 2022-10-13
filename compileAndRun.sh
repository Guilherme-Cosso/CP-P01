#!/bin/bash
g++ -std=c++11 -fopenmp -lm -c -o decision_treep.o decision_tree.cpp
g++ -std=c++11 -fopenmp -lm -o dtp.exe decision_treep.o
time ./dtp.exe dt_train2.txt dt_test2.txt dt_result.txt