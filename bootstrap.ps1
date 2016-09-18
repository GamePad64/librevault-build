mkdir -force tmp
#$hh = Get-WmiObject -Class Win32_Processor -ComputerName . | Select-Object -Property NumberOfLogicalProcessors
cd tmp
Import-Module BitsTransfer
if(!(Test-Path ".\jom.zip")) {
  Start-BitsTransfer -source 'http://download.qt.io/official_releases/jom/jom.zip' -Destination "jom.zip"
  & 7z x jom.zip -ojom
}
if(!(Test-Path ".\jom")) {
  & 7z x jom.zip -ojom
}
$env:Path += ";"+ $(Resolve-Path .\jom\)

Start-BitsTransfer -source 'https://github.com/google/protobuf/releases/download/v3.0.0/protobuf-cpp-3.0.0.zip' -Destination "protobuf-cpp-3.0.0.zip"
& 7z.exe x protobuf-cpp-3.0.0.zip
cd protobuf-3.0.0\cmake
mkdir build
cd build
mkdir Release
cd  Release
cmake -G "NMake Makefiles JOM" -DCMAKE_BUILD_TYPE=Release ../..
cmake --build . -- /j 16
jom install

if(!(Test-Path ".\qt-everywhere-opensource-src-5.7.0.7z")) {
  Start-BitsTransfer -Priority Foreground -source "http://download.qt.io/archive/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.7z" -Destination "qt-everywhere-opensource-src-5.7.0.7z"
  & 7z x qt-everywhere-opensource-src-5.7.0.7z
}
if(!(Test-Path ".\qt-everywhere-opensource-src-5.7.0")) {
  & 7z x qt-everywhere-opensource-src-5.7.0.7z
}
cd qt-everywhere-opensource-src-5.7.0
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
configure.bat -opensource -platform win32-msvc2015 -release -confirm-license -prefix $PWD/qtbase
jom -j 16

cd ..
git clone https://github.com/librevault/librevault.git
cd librevault
git submodule update --init
mkdir build
cd build
#cmake -DBOOST_ROOT="C:\Libraries\boost_1_59_0" -DBOOST_LIBRARYDIR="C:\Libraries\boost_1_59_0\lib32-msvc-14.0" -DCMAKE_PREFIX_PATH="C:\Qt\5.7\msvc2015\lib\cmake\Qt5" -DUSE_BUNDLED_SQLITE3=TRUE -DPROTOBUF_INCLUDE_DIR="C:\libraries\protoc-3.0.0\cmake\build\release" -DPROTOBUF_LIBRARY=C:\libraries\protoc-3.0.0\cmake\build\release -DCRYPTOPP_ROOT_DIR="C:\Program Files (x86)\cryptopp\" -DCRYPTOPP_LIBRARY="C:\Program Files (x86)\cryptopp\lib" ..
#cmake --build .