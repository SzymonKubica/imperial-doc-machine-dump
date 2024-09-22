#!/bin/bash

# cd into the directory containing this script
cd "$(dirname "$0")"

# uncomment and complete the following calls to javac and java
# required code libraries can be found in the lib/ directory
# compiled class files should be placed in the out/ directory

javac -d out/ -cp lib/utils.jar --source-path src/ src/Main.java
java -cp "lib/utils.jar:out/" Main
