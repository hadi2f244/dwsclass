# dwsclass
solution of dwsclass exercises: dev-006-bash

[@dwsclass](https://github.com/dwsclass) dws-dev-006-bash

# Usage

`try` is bash compatible command that try to run a **command** repeatedly until the return code is not zero. If it fails n times, an error occurs and it exits with 1 status code.


*Syntax*: ```try [-i|-n|-h|-v] commmand```

Options:

    -n   number of tries.
    -i   interval between each try.[seconds]
    -v   verboose
    -h   help

There are two versions: 

## try1.sh
`-i` and `-n` are mandatory.

examples:
```
./try1.sh -n 3 -i 10 echo "Hello, World!"
./try1.sh try -n 3 -i 10 ./run.sh
```

## try2.sh
Default values for interval and number of repetitions.( **i=15**, **n=10** )

Also you can use environment variables to pass arguments.

    TRY_INTERVAL   same as '-i'
    TRY_NUMBER     same as '-n'
    TRY_COMMAND    the command

examples:
```
TRY_INTERVAL=10 ./try2.sh -n 3 -i 1 echo "Hello, World!"
./try2.sh ./run.sh
```



