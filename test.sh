PATH=$PATH:.

TRY_COMMAND="echo test" try -v
try -v echo test 
TRY_INTERVAL=5 try -v echo test 
TRY_NUMBER=5 try -v echo test 
TRY_NUMBER=5 TRY_INTERVAL=5 try -v echo test 
TRY_NUMBER=5 TRY_INTERVAL=5 TRY_COMMAND="echo test1" try -v echo test2

TRY_COMMAND="echo test" try -v -i 5
TRY_COMMAND="echo test" try -v -n 5
try -v -i 5 echo test
try -v -n 5 echo test
TRY_COMMAND="echo test" try -v -i 5 -n 5
try -v -i 5 -n 5 echo test