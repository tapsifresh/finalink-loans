@echo off
set JAVA_HOME=C:\Users\Jajabinx.yoda\AppData\Local\hermes\cache\scratch\jdk\jdk-17.0.13+11
set ANDROID_HOME=C:\Android
set PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin;%PATH%
cd /d C:\Users\Jajabinx.yoda\Documents\Yoda-Business\finalink_loans
C:\src\flutter\bin\flutter.bat build apk --release
