import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  String? _accessToken;
  String? _email;
  String? _response;
  @override
  void initState() {
    // may or may not need this
    // FirebaseAuth.instance.getRedirectResult().then((result) {
    //   if (result.user != null) {
    //     print('User is signed in!');
    //     result.user!.getIdToken().then((token) {
    //       setState(() {
    //         _accessToken = token;
    //         _email = result.user!.email;
    //       });
    //     });
    //   }
    // });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        user.getIdToken().then((token) {
          setState(() {
            _accessToken = token;
            _email = user.email;
          });
        });
      }
    });
    super.initState();
  }

  Future<void> callBackend() async {
    if (_accessToken == null) {
      setState(() {
        _response = 'Access token is null';
      });
    } else {
      final response = await http.get(
        Uri.parse('http://localhost:8080/ping'),
        headers: <String, String>{
          'Authorization': 'Bearer $_accessToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _response = response.body;
        });
      } else {
        setState(() {
          _response = 'Failed to call backend';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Firebase Login'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signInWithRedirect(googleProvider);
                },
                child: const Text('Sign in with Google'),
              ),
              if (_accessToken != null)
                Text('Email: $_email'),
              ElevatedButton(
                  onPressed: callBackend, child: const Text('Call Backend')),
              if (_response != null) Text('Response: $_response'),
            ],
          ),
        ));
  }
}
