#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
    struct FuncName:public FunctionPass {
        static char ID;
        FuncName():FunctionPass(ID) {}
        bool runOnFunction(Function &F) {
            errs()<< F.getName() << "\n";
            return false;
        }
    };
}

char FuncName::ID = 0;
static RegisterPass<FuncName> X("funcName","display function name");