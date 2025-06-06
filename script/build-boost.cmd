@echo off
@REM 检查是否有 OHOS-SDK 环境变量
if not defined OHOS_SDK (
    echo OHOS_SDK 环境变量未设置，请先设置 OHOS_SDK 环境变量。
    exit /b 1
)

if not defined OHOS_ABI (
    echo OHOS_ABI 环境变量未设置，请先设置 OHOS_ABI 环境变量。
    exit /b 1
)

set PWD=%cd%

set CMAKE_EXE=%OHOS_SDK%\native\build-tools\cmake\bin\cmake.exe
set CMAKE_TOOLCHAIN_FILE=%OHOS_SDK%\native\build\cmake\ohos.toolchain.cmake

@REM 安装目录
set INSTALL_DIR=%PWD%\out\install
set BUILD_DIR=%PWD%\out\build\boost

%CMAKE_EXE% -G "Ninja" ^
    -B%BUILD_DIR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% ^
    -DOHOS_ARCH=%OHOS_ABI% ^
    -DBUILD_SHARED_LIBS=OFF ^
    -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
    -S %PWD% ^

@echo on