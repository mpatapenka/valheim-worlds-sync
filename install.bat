@Echo Off

Set "SteamPath="
For /F "Tokens=1,2*" %%A In ('Reg Query HKCU\SOFTWARE\Valve\Steam') Do (
    If "%%A" Equ "SteamPath" Set "SteamPath=%%C"
)
If Not Defined SteamPath Exit/B

Set "ValheimDistrib=%SteamPath%\steamapps\common\Valheim"
Set "ValheimWorlds=%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds"
Set "ValheimHostScript=%USERPROFILE%\Desktop\ValheimHost.bat"

echo Valheim distrib path "%ValheimDistrib%"
echo Valheim worlds path "%ValheimWorlds%"
echo Valheim Host script path "%ValheimHostScript%"

rem Setup worlds
cd /d %ValheimWorlds%
If Not Exist ".git" (
    git clone https://github.com/mpatapenka/valheim-worlds-sync.git
    xcopy /Y valheim-worlds-sync\ . /E/H
    rmdir valheim-worlds-sync /Q/S
)

rem Setup distrib
If Not Exist %ValheimHostScript% (
    (
        echo @Echo Off
        echo cd /d %ValheimWorlds%
        echo git pull origin main
        echo cd /d %ValheimDistrib%
        echo rem echo start steam://rungameid/892970
        echo valheim.exe
        echo sleep 5000
        echo cd /d %ValheimWorlds%
        echo git add .
        echo git commit -m "Automatic World Update"
        echo git push origin main
        echo set /p DUMMY=Hit ENTER to continue...
    ) > %ValheimHostScript%
)