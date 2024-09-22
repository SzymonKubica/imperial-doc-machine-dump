#!/bin/bash

# cd into the directory containing this script
cd "$(dirname "$0")"

# uncomment and complete the following calls to javac and java
# compiled class files should be placed in the out/ directory


javac -d out/ --source-path src/ src/Main.java 
java --class-path out/ Main

