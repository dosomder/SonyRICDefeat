@echo off
7z.exe a ..\RICDefeat_.zip ..\RICDefeat\*
java.exe -Xmx1024m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ..\RICDefeat_.zip ..\RICDefeat.zip
del ..\RICDefeat_.zip
