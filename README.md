# jood

Notre devoir de conscience

### app icon
`flutter pub run flutter_launcher_icons:main`

### build apk
`flutter build apk --release`

### the SHA-1 of your signing certificate
- Using Gradle's Signing Report

`./gradlew signingReport`

- Using Keytool

`keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore`