# llvm-pass-practice
the road to write llvm pass


## notice

* path should not include Chinese character

## install llvm
`./install.sh`

## practices

* my first pass:show function name


## how to write a simplest pass

take `FuncName.cpp` in `my first pass` as an example

### setup env
1. add library
add
    ```
    add_llvm_library( LLVMFuncName MODULE
    YOUR_PASS.cpp

    PLUGIN_TOOL
    opt
    )
    ```
    into `PASS_DIR_PATH/CMakeLists.txt`

2. add subdirectory
    add `add_subdirectory(PASS_DIR_PATH)` into `lib/Transforms/CMakeLists.txt`

### coding

1. the necessary header
    ```cpp
    #include "llvm/Pass.h"
    #include "llvm/IR/Function.h"
    #include "llvm/Support/raw_ostream.h"
    ```

2. add namespace
    ```cpp
    using namespace llvm;
    ```

3. write your own pass in an anonymous namespace
    ```cpp
    namespace {
        
    }
    ```

### build

```sh
⇒  doublemice@DoubleMice-MBP:~/Documents/graduate/llvm-pass-practice|master⚡ pwd
/Users/doublemice/Documents/graduate/llvm-pass-practice
pushd llvm/lib/Transforms
ln -s ../../../my\ first\ pass/FuncName .
popd
pushd build
make
popd
```

### load the pass

#### the output lib
```sh
doublemice@DoubleMice-MBP:~/Documents/graduate/llvm-pass-practice|master⚡ 
⇒  ls build/lib/LLVMFuncName.dylib 
build/lib/LLVMFuncName.dylib
```

as we see,the output dylib name is exact the name we define in `PASS_DIR_PATH/CMakeLists.txt`(see: setup env -> 1)

#### load it with opt
1. prepare a test file in test/FuncName_test.c
    ```cpp
    #include <stdio.h>
    void sayHello() {
        printf("hello\n");
    }
    void sayGoodbye() {
        printf("goodbye\n");
    }
    int main() {
        sayHello();
        sayGoodbye();
        return 0;
    }
    ```

2. compile it into a llvm bitcode
    ```sh
    $LLVM_BIN/clang -O3 -emit-llvm test/FuncName_test.c -c -o test/FuncName_test.bc
    ```
3. run the pass with opt
    ```sh
    doublemice@DoubleMice-MBP:~/Documents/graduate/llvm-pass-practice|master⚡ 
    ⇒  $LLVM_BIN/opt -load build/lib/LLVMFuncName.dylib -funcName < test/FuncName_test.bc > /dev/null
    sayHello
    sayGoodbye
    main
    ```

## a skeleton
```cpp
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;
namespace {
    struct Example:public FunctionPass {
        static char ID;
        Example():FunctionPass(ID) {}

        //tells llvm which other pass we need
        void getAnalysisUsage(AnalysisUsage &AU) const {
            ...
        }
        virtual bool runOnFunction(Function &F) {
            ...
            //true:this pass will change our program
            //false:won't change
            return false;
        }
    };
}

char Example::ID = 0;
static RegisterPass<Example> X("PASS_NAME","PASS_DESCRIPTION")
```