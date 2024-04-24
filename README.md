# Firebase Full Stack Example

An example of a full stack application authenticated with Firebase Authentication using Google as a provider.
The front end uses the Flutterfire CLI to integrate with your Firebase project, and the back end uses the Go Admin SDK.
Once the Firebase clients are configured according to the below instructions, any other Firebase services enabled on 
your project can easily be integrated into either the client or server side logic.

## Configuration

These instructions assume you have the following installed on your system:
- Flutter and Dart with dependencies for web and mobile development (run 'flutter doctor' to ensure dependencies are present)
- Go 1.18+

1. Install Firebase CLI
```
npm install -g firebase-tools
```
2. Login to the Firebase CLI
```
firebase login
```
3. Install Flutterfire CLI
```
dart pub global activate flutterfire_cli
```
4. Create a Firebase project
    - Log in to https://console.firebase.google.com/ and click 'Add Project'
    - Once created, go to the project console's Authentication tab and click 'Get Started' to enable Authentication services
    - In the Authentication menu, enable Google as a provider.
5. Clone this repo and run flutterfire configure from the fbprotofront directory
```
git clone https://github.com/andymillerfs/firebase_fullstack_example
cd firebase_fullstack_example/fbprotofront
flutterfire configure
```
    - Flutterfire will request a password for your Firebase account
    - You will need to specify the project you just created when prompted
6. Configure Android debug keys
    - For Google's Oauth2 authorization code flow, you need to register the SHA1 and SHA256 keys for your Android debug keystore to locally test the application on Android.
    - In production, you will need to provide the keys for the release keystore.
    - To retrieve the keys for your debug keystore, run
```
keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
```
    - Go to General -> Project Settings in the Firebase project console and scroll down to find the Android application that the Flutterfire CLI registered for you automatically.
    - Navigate into it and click "Add fingerprint" to enter both the SHA1 and SHA256 fingerprints from the previous command output
7. Obtain credentials for Admin SDK
    - While you're still in the project settings page, navigate to a tab at the top called Service Accounts
    - Click the "Generate new private key" button. This will download a JSON file.
    - Rename this JSON file "serviceAccountKey.json" and store it in the fbprotoback folder alongside the main.go and firebase.go files
    - In production, the string value of this JSON file can be stored as an environment variable provided by any number of secret management solutions during deployment
    - WARNING: never expose the values found in serviceAccountKey.json as they grant admin level access to your Firebase project. Sensitive values are also present in the firebase.json and firebase_options.dart files generated by Flutterfire CLI, so they are included in the gitignore file to avoid exposing them.
8. Test the app!
    - In one terminal, run
```
cd fbprotoback
go run .
```
    - In another terminal, run
```
cd fbprotofront
flutter run
```
    - To test on a live Android device, connect to your device with adb either via USB or wirelessly before running 'flutter run'

## Next Steps

- A list of official Flutter libraries for consuming Firebase services can be found in the left-hand Flutter blade at https://firebase.google.com/docs/reference
- Documentation for the Go Admin SDK can be found at https://pkg.go.dev/firebase.google.com/go.