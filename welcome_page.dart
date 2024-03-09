//welcome_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';

class WelcomePage extends StatelessWidget{
  @override

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Alert Arrival!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute
                (builder: (context) => MyHomePage(
                  title: 'Alert Arrival')),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(4.0),
            ), 
            child: const Text(
              'Enter Application',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
            //add more design elements or widgets for welcome page
          ],
        ),
      ),
    );
  }
}