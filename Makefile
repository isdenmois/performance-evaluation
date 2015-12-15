all: 
	dmd -O \
	main.d \
	randoms.d \
	first/*.d \
	second/*.d

unittest:
	dmd -unittest \
	main.d \
	randoms.d \
	first/*.d \
	second/*.d
	@./main && echo 'Unit test passed'
