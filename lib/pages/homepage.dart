import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;

  Future<void> canCheckBiometric() async {
    bool canCheck = false;
    try {
      canCheck =
          await auth.canCheckBiometrics && await auth.isDeviceSupported();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _canCheckBiometric = canCheck;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    String authorized = "";
    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint to authenticate",
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      authorized = authenticated ? "Access granted" : "Access denied";
      debugPrint(authorized);

      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor:
                  authenticated ? Colors.green[400] : Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: authenticated ? Colors.green[400] : Colors.red[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        authenticated
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color:
                            authenticated ? Colors.green[400] : Colors.red[400],
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      authorized,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }

  @override
  void initState() {
    super.initState();
    canCheckBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: _canCheckBiometric
            ? Column(
                children: [
                  const Spacer(flex: 5),
                  Icon(
                    Icons.fingerprint_rounded,
                    color: Colors.grey[200],
                    size: 100,
                  ),
                  const Spacer(flex: 3),
                  ZoomTapAnimation(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      _authenticate();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 10,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Submit fingerprint",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            : Center(
                child: Text(
                  "This device has no fingerprint scanner",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[200],
                  ),
                ),
              ),
      ),
    );
  }
}
