import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _state = 'PAUSED';
        print(_state);
        break;
      case AppLifecycleState.resumed:
        _state = 'RESUMED';
        print(_state);
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
