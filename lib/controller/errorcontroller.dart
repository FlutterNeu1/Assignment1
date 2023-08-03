import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ErrorController extends StatefulWidget {
  final Widget child;

  ErrorController({required this.child});

  @override
  _ErrorControllerState createState() => _ErrorControllerState();
}

class _ErrorControllerState extends State<ErrorController> {
  late ConnectivityResult _connectivityResult;
  late Stream<ConnectivityResult> _connectivityStream;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();

    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen(_updateConnectivity);

    Connectivity().checkConnectivity().then(_updateConnectivity);
  }

  void _updateConnectivity(ConnectivityResult result) {
    setState(() {
      _connectivityResult = result;
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  // void dispose() {
  //   _connectivityStream.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.child : _buildErrorUI();
  }

  Widget _buildErrorUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Internet Not Connected',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _updateConnectivity(await Connectivity().checkConnectivity());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
