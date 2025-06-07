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
set PROJ_INSTALL_DIR=%PWD%\out\install\%OHOS_ABI%
set INSTALL_DIR=%PROJ_INSTALL_DIR%\%OHOS_ABI%\rime
set BUILD_DIR=%PWD%\out\build\%OHOS_ABI%\rime

@REM 删除构建目录和安装目录
if exist %INSTALL_DIR% (
    rmdir /s /q %INSTALL_DIR%
)
if exist %BUILD_DIR% (
    rmdir /s /q %BUILD_DIR%
)

%CMAKE_EXE% -G "Ninja" ^
    -B%BUILD_DIR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% ^
    -DOHOS_ARCH=%OHOS_ABI% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DBUILD_TEST=OFF ^
    -DGlog_INCLUDE_PATH=%PROJ_INSTALL_DIR%\Glog\include ^
    -DGlog_LIBRARY=%PROJ_INSTALL_DIR%\Glog\lib\libglog.a ^
    -DBoost_INCLUDE_DIR=%PROJ_INSTALL_DIR%\boost\include ^
    -DYamlCpp_INCLUDE_PATH=%PROJ_INSTALL_DIR%\YamlCpp\include\ ^
    -DYamlCpp_NEW_API=%PROJ_INSTALL_DIR%\YamlCpp\include\yaml-cpp\node\ ^
    -DYamlCpp_LIBRARY=%PROJ_INSTALL_DIR%\YamlCpp\lib\libyaml-cpp.a ^
    -DLevelDb_INCLUDE_PATH=%PROJ_INSTALL_DIR%\LevelDb\include ^
    -DLevelDb_LIBRARY=%PROJ_INSTALL_DIR%\LevelDb\lib\libleveldb.a ^
    -DOpencc_INCLUDE_PATH=%PROJ_INSTALL_DIR%\Opencc\include ^
    -DOpencc_LIBRARY=%PROJ_INSTALL_DIR%\Opencc\lib\libopencc.a ^
    -DMarisa_INCLUDE_PATH=%PROJ_INSTALL_DIR%\Marisa\include ^
    -DMarisa_LIBRARY=%PROJ_INSTALL_DIR%\Marisa\lib\libmarisa.a ^
    -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR%

%CMAKE_EXE% --build %BUILD_DIR% -j32 --config Release --target install 

if %ERRORLEVEL% neq 0 (
    echo Boost 构建失败，请检查错误信息。
    exit /b %ERRORLEVEL%
)

@echo on