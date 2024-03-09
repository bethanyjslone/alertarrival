import 'package:eyes/data_model.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'data_page.dart';

List<ActivationEntry> activationEntries = [];
int alerts = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Alert Arrival',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 253, 38, 23)),
        useMaterial3: true,
      ),
      home: WelcomePage(),
      routes: {
        '/home':(context) => MyHomePage(title: 'Alert Arrival',
        ),
        '/data':(context) => DataPage(activationEntries: activationEntries),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDrowsyModeActivated = false;
  

  void _toggleDrowsyMode() {
    setState(() {
      isDrowsyModeActivated = !isDrowsyModeActivated;
       
      if(isDrowsyModeActivated)
      {
        late ActivationEntry newEntry;
        newEntry = ActivationEntry(DateTime.now(), 0);

        activationEntries.insert(0, newEntry);

        if(activationEntries.length > 10)
        {
          activationEntries.removeLast();
        }
      }
      else{

        if(activationEntries.isNotEmpty)
        {
          activationEntries.first.alertNum = alerts;
        }

        //set back to 0
        alerts = 0;
      }
    });
  }

  void _navigateToDataPage()
  {
    Navigator.pushNamed(context, '/data');
  }

  void _incrementAlerts()
  {
    setState(() {
      if(isDrowsyModeActivated)
      {
        alerts++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isDrowsyModeActivated ? 'Activated' : 'Not Activated',
              style: TextStyle(
                fontSize: 48,
                color: isDrowsyModeActivated 
                  ? Colors.green 
                  : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleDrowsyMode,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDrowsyModeActivated ? Colors.red : Colors.green,
                  ), 
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),  
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white
                ),
                elevation: MaterialStateProperty.all<double>(
                  4.0
                ),
              ), 
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDrowsyModeActivated
                      ? Icons.power_settings_new
                      : Icons.power_settings_new_outlined,
                    size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDrowsyModeActivated
                      ? 'Deactivate Drowsy Mode'
                      : 'Activate Drowsy Mode',
                      style: const TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToDataPage,
               child: Text('Go to Data Page'),
               ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _incrementAlerts,
                child: Text('Add Alert'),
              ),
          ],
        ),
      ),
    );
  }
}
