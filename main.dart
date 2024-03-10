import 'package:alert_arrival/data_model.dart';
import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';

import 'welcome_page.dart';
import 'data_page.dart';

List<ActivationEntry> activationEntries = [];
int alerts = 0;
String deactivatedPath = 'assets/images/happy-face.png';
String activatedPath = 'assets/images/sleepy-face.png';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 253, 38, 23)),
        useMaterial3: true,
      ),
      home: WelcomePage(),
      routes: {
        '/home':(context) => MyHomePage(title: 'Alert Arrival'),
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
  bool isDrowsyActivated = false;

  Color getBackgroundColor()
  {
    return isDrowsyActivated ? Colors.green : Colors.blueAccent;
  }


  void _toggleDrowsyMode(){
    setState(() {
      isDrowsyActivated = !isDrowsyActivated;

      if(isDrowsyActivated)
        {
          late ActivationEntry newEntry;
          newEntry = ActivationEntry(DateTime.now(), 0);

          activationEntries.insert(0, newEntry);

          if(activationEntries.length > 10)
            {
              activationEntries.removeLast();
            }

          AlanVoice.playText("Activating Alert Arrival");
        }
      //unactivated
      else
        {
          if(activationEntries.isNotEmpty)
            {
              activationEntries.first.alertNum = alerts;
            }
          //reset alerts
          alerts = 0;

          AlanVoice.playText("Deactivating Alert Arrival");

          Future.delayed(const Duration(seconds: 2), () {
            //so it says phrase above
            AlanVoice.deactivate();
          });
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
      if(isDrowsyActivated)
        {
          //turn on here
          AlanVoice.activate();

          Future.delayed(const Duration(seconds: 1), () {
            // Play additional phrases
            AlanVoice.playText("Alert detected");
            AlanVoice.playText("Hi! I'm Alan");
          });

          alerts++;
        }
    });
  }

  _MyHomePageState() {

    /// Init Alan Button with project key from Alan AI Studio
    AlanVoice.addButton("a692a72b78371c661865f11c615a99332e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });


    /// Handling events
    void _handleEvent(Map<String, dynamic> event) {
      switch (event["name"]) {
        case "recognized":
          debugPrint("Interim results: ${event["text"]}");
          break;
        case "parsed":
          debugPrint("Final result: ${event["text"]}");
          if(event["text"] == 'turn on alert arrival')
            {
              _toggleDrowsyMode();
            }
          if(isDrowsyActivated)
            {
              if(event["text"] == 'turn off alert arrival')
              {
                _toggleDrowsyMode();
              }
              if(event["text"] == 'Alan turn off')
                {
                  AlanVoice.deactivate();
                }
            }
          break;
        case "text":
          debugPrint("Alan AI's response: ${event["text"]}");
          break;
        default:
          debugPrint("Unknown event");
      }
    }

    /// Registering the event listener
    AlanVoice.onEvent.add((event) => _handleEvent(event.data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              alignment: Alignment.topCenter,
              child: Image.asset(
                isDrowsyActivated ? activatedPath : deactivatedPath,
                color: Colors.white,
              ),
            ),
            Container(
              alignment: Alignment.center,
            child: Text(
              isDrowsyActivated ? 'Activated' : 'Not Activated',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _toggleDrowsyMode,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isDrowsyActivated ? Colors.red : Colors.green,
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
                      isDrowsyActivated
                      ? Icons.power_settings_new
                          : Icons.power_settings_new_outlined,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDrowsyActivated
                      ? 'Deactivated Drowsy Mode'
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
                onPressed: _incrementAlerts,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                ),
                child: const Text('Add Alert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _navigateToDataPage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),

              ),
                child: const Text('Go to Data Page'),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
