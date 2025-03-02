import 'package:flutter/material.dart';
import 'permission_handler.dart';
import 'intro_screen.dart';
import 'sms_collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await updatePermissionStatus();
    if (isPermissionGranted) {
      //* Navigate to the main content
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SmsCollection()));
    } else {
      //* Show introduction screen
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বাংলা বার্তা সুরক্ষা অ্যাপ'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
