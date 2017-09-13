@echo off
cd /d %~dp0

set nowdir=%~dp0

set tomcatName=apache-tomcat-7.0.61

if exist "W:\" (
	echo W盘已挂载
) else (
	echo 磁盘挂载中……
	net use W: \\192.168.35.55\webapps /y 
	echo 挂载成功
)

if exist "%nowdir%Java\" (
   echo	已经安装JDK
) else (
   xcopy "W:\Java" "%nowdir%Java\" /s /e
   echo JDK安装完成
)

if "%JAVA_HOME%" == "%nowdir%Java\jdk1.7.0_79" (
    echo JAVA_HOME已经设置
) else (
    echo 设置JAVA_HOME变量
    setx JAVA_HOME "%nowdir%Java\jdk1.7.0_79">nul     
    echo 环境变量已经变更,请退出后重新运行脚本。。。
    pause
    exit
)

if exist "%nowdir%autolocalservice.bat" (
    echo 自启动脚本已经存在
) else (
    echo 复制自启动脚本
    copy "W:\autolocalservice.bat" "%nowdir%autolocalservice.bat"
    
)

rem pause


if exist "%nowdir%%tomcatName%" (
	set /p localversion=<%nowdir%%tomcatName%\webapps\localservice\version.json
	echo 本地服务已部署,本地版本%localversion%
	
) else (
	echo 部署服务中，请稍等……
	md %nowdir%%tomcatName%
	xcopy /y /s /e /d W:\%tomcatName%\* %nowdir%%tomcatName%\
    rem xcopy /y W:\context.xml %nowdir%\%tomcatName%\conf\context.xml
)

set /p localversion=<%nowdir%%tomcatName%\webapps\localservice\version.json

echo.
set /p remoteversion=<W:\%tomcatName%\webapps\localservice\version.json
echo 最新版本为%remoteversion%
if %localversion% neq %remoteversion% (
	echo 版本更新中，请稍等……
    rd /s /q %nowdir%%tomcatName%
	md %nowdir%%tomcatName%
	xcopy /y /s /e /d W:\%tomcatName%\* %nowdir%%tomcatName%\
   rem xcopy /y W:\context.xml %nowdir%\%tomcatName%\conf\context.xml
) else (
	echo 版本为最新
)

if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\localservice.lnk" goto end

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\localservice.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%nowdir%autolocalservice.bat" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%
del %SCRIPT% 

:end 



echo.
echo 启动tomcat中……
cd "%nowdir%%tomcatName%\bin"
startup.bat

pause>nul

