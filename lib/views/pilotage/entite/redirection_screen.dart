import 'package:flutter/material.dart';

class RedirectionScreen extends StatefulWidget {
  const RedirectionScreen({super.key});

  @override
  State<RedirectionScreen> createState() => _RedirectionScreenState();
}

class _RedirectionScreenState extends State<RedirectionScreen> {

  void goToRoute() async{
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    goToRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.amber,),
      ),
    );
  }
}
