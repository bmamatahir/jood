<p align="center">
    <img alt="Jood Logo" src="https://raw.githubusercontent.com/bmamatahir/jood/master/assets/logo.png" width="200" />
</p>
<h1 align="center">
  Jood
</h1>

The app users can signal a homeless and identify their locations, then the app notifies their volunteers and provides them with a detailed report about homeless needs. 
Briefly, the app act as a bridge between the homeless and volunteers.

## Quick toor
![Demo](assets/demo.gif)

## Technical guidelines

     Generate the app lunch icon `flutter pub run flutter_launcher_icons:main`

     Build release apk `flutter build apk --release`

     The SHA-1 of your signing certificate
    - Using Gradle's Signing Report `./gradlew signingReport`
    
    - Using Keytool `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore`

     Google Maps API key (gently use your own 😊) 
     - AIzaSyCl2Hdpenhy2OOf_FjURE5cDbPdCxFzCHQ
