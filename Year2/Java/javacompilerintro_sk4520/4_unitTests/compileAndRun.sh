#!/bin/bash

# cd into the directory containing this script
cd "$(dirname "$0")"

# uncomment and complete the following calls to javac and java
# libraries for unit tests can be found in the testLib/ directory
# compiled class files should be placed in the testOut/ directory
# for the java call you only need to fill in the classpath correctly

javac -d testOut/ -cp lib/junit4.jar -sourcepath "test/:src/" test/SquareTest.java src/Square.java
java -cp "testOut/:lib/*" org.junit.runner.JUnitCore SquareTest

