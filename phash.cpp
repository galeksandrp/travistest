#include <iostream>

#include <pHash.h>

using namespace std;

int main(int argc, char* argv[])
{
    ulong64 myhash=0;
    
    ph_dct_imagehash(argv[1], myhash);
    cout<<myhash<<endl;
}
