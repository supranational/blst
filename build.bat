@echo off
set TOP=%~dp0
cl /nologo /c /O2 /Zi /Zl %TOP%src\server.c || EXIT /B
FOR %%F IN (%TOP%build\win64\*.asm) DO (
    ml64 /nologo /c /Cp /Cx /Zi %%F || EXIT /B
)
rem FOR %%F IN (%TOP%src\asm\*-x86_64.pl) DO (
rem     IF NOT EXIST %%~nF.asm (perl %%F masm %%~nF.asm)
rem )
rem FOR %%F IN (*.asm) DO (ml64 /nologo /c /Cp /Cx /Zi %%F || EXIT /B)
lib /nologo /OUT:blst.lib *.obj && del *.obj
