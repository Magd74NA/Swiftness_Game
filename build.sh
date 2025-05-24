
set -xe

#cc -c Sources/CShit/test.c -shared -o Sources/CShit/libtest.so
#cc -c Sources/CShit/test.c

swiftc -O main.swift -I ./raylib-5.5_linux_amd64/include -L ./raylib-5.5_linux_amd64/include/ -Xlinker ./raylib-5.5_linux_amd64/lib/libraylib.a -Xlinker -lm & ./main
