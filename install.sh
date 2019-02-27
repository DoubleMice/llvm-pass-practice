#get LLVM
git clone --depth=1 http://llvm.org/git/llvm.git


#get clang
git clone --depth=1 http://llvm.org/git/clang.git


#get compiler-rt
git clone --depth=1 http://llvm.org/git/compiler-rt.git


#Set up clang, compiler-rt
pushd llvm/tools
ln -s ../../clang .
popd

pushd llvm/projects
ln -s ../../compiler-rt .
popd

mkdir build
pushd build
cmake -G "Unix Makefiles" ../llvm
make -j4
popd
