import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Conditioner Remote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Air Conditioner Remote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _sleepMode = false;

  void _toggleSleepMode(bool value) {
    setState(() {
      _sleepMode = value;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thermostat),
                SizedBox(width: 5),
                Text('25°C'),
                SizedBox(width: 15),
                Icon(Icons.power),
                SizedBox(width: 5),
                Text('500W'),
                SizedBox(width: 15),
                Icon(Icons.ac_unit),
                SizedBox(width: 5),
                Text('Cool'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('快眠モード'),
                Switch(value: _sleepMode, onChanged: _toggleSleepMode),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Icon(Icons.local_fire_department),
                            Text('暖房'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Column(
                          children: [Icon(Icons.water_drop), Text('除湿')],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Column(
                          children: [Icon(Icons.ac_unit), Text('冷房')],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
