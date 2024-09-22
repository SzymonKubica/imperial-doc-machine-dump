all: libs

clean: 
	/bin/rm -f $(BUILD) *.o core
	cd cond; make clean
	cd common_functions; make clean
	cd data_processing; make clean
	cd multiply; make clean
	cd single_data_transfer; make clean
	cd branch; make clean
	cd gpio; make clean
	
libs: 
	cd cond; make
	cd common_functions; make
	cd data_processing; make
	cd multiply; make
	cd single_data_transfer; make
	cd branch; make
	cd gpio; make



