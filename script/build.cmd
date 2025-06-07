@echo off
chcp 65001 > nul
if not defined OHOS_SDK (
    echo OHOS_SDK 环境变量未设置，请先设置 OHOS_SDK 环境变量。
    exit /b 1
)

echo "build x86_64"
set OHOS_ABI=x86_64
call script\build-Boost.cmd
call script\build-Glog.cmd
call script\build-Marisa.cmd
call script\build-OpenCC.cmd
call script\build-YamlCpp.cmd
call script\build-LevelDb.cmd
call script\build-rime.cmd
if %ERRORLEVEL% neq 0 (
    echo 构建失败，请检查错误信息。
    exit /b %ERRORLEVEL%
)

echo "build arm64"
set OHOS_ABI=arm64-v8a
call script\build-Boost.cmd
call script\build-Glog.cmd
call script\build-Marisa.cmd
call script\build-OpenCC.cmd
call script\build-YamlCpp.cmd
call script\build-LevelDb.cmd
call script\build-rime.cmd
if %ERRORLEVEL% neq 0 (
    echo 构建失败，请检查错误信息。
    exit /b %ERRORLEVEL%
)


@echo on