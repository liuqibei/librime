@echo off
chcp 65001 > nul
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

@REM set CMAKE_EXE=%OHOS_SDK%\native\build-tools\cmake\bin\cmake.exe
set CMAKE_EXE=cmake
set CMAKE_TOOLCHAIN_FILE=%OHOS_SDK%\native\build\cmake\ohos.toolchain.cmake

@REM 安装目录
set INSTALL_DIR=%PWD%\out\install\%OHOS_ABI%\Opencc
set BUILD_DIR=%PWD%\out\build\%OHOS_ABI%\Opencc

@REM 删除构建目录和安装目录
if exist %INSTALL_DIR% (
    rmdir /s /q %INSTALL_DIR%
)
if exist %BUILD_DIR% (
    rmdir /s /q %BUILD_DIR%
)

cd deps/opencc

%CMAKE_EXE% -G "Ninja" ^
    -B%BUILD_DIR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% ^
    -DOHOS_ARCH=%OHOS_ABI% ^
    -DBUILD_SHARED_LIBS=OFF ^
    -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR%

%CMAKE_EXE% --build %BUILD_DIR% -j32 --config Release --target install 

if %ERRORLEVEL% neq 0 (
    echo Boost 构建失败，请检查错误信息。
    exit /b %ERRORLEVEL%
)

cd %PWD%

@echo on