import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String _state = 'UNKNOWN';
  String _lockKey = 'LOCK_KEY';
  bool _lockState = false;

  @override
  void initState() {
    super.initState();
    _getLock();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _state = 'PAUSED';
        print(_state);
        if (_lockState == false) {
          _lockState = true;
          _setLock();
        }
        break;
      case AppLifecycleState.resumed:
        _state = 'RESUMED';
        print(_state);
        if (_lockState == true) {
          bool _biometrics = await hasBiometrics();
          if (_biometrics == true) {
            LocalAuthentication localAuth = new LocalAuthentication();
            await localAuth.authenticateWithBiometrics(
              localizedReason: 'USE Biometrics',
              useErrorDialogs: false,
            );
            print('USE Biometrics');
          }
          _lockState = false;
          _setLock();
        }
        break;
      case AppLifecycleState.inactive:
        _state = 'INACTIVE';
        print(_state);
        break;
      case AppLifecycleState.suspending:
        _state = 'SUSPANDING';
        print(_state);
        break;
      default:
        _state = 'DEFAULT';
        print(_state);
        break;
    }

    setState(() {});
  }

  void _getLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lockState = prefs.getBool(_lockKey) ?? false;
  }

  void _setLock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lockKey, _lockState);
  }

  Future<bool> hasBiometrics() async {
    LocalAuthentication localAuth = new LocalAuthentication();
    bool canCheck = await localAuth.canCheckBiometrics;
    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      if (Platform.isIOS && availableBiometrics.contains(BiometricType.face)) {
        return true;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    //_showToast();
    return Scaffold(
      appBar: AppBar(
        title: Text("App Lifecycle State"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(_state),
          ),
        ],
      ),
    );
  }
}
