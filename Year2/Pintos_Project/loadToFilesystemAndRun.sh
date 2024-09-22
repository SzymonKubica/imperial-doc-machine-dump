!#/usr/bin/bash

cd build
pintos-mkdisk filesys.dsk --filesys-size=2
pintos -f -q
if [ $1 == "example" ]
then 
  pintos -p ../../examples/$2 -a $2 -- -q
elif [ $1 == "test" ]
then 
  pintos -p tests/userprog/$2 -a $2 -- -q
fi
pintos -q run $2
cd ..

