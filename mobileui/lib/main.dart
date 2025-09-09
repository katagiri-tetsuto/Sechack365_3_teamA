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
  int _selectedIndex = 0;

  void _toggleSleepMode(bool value) {
    setState(() {
      _sleepMode = value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
                Spacer(),
                Container(
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.add), onPressed: () {}),
                        Text('温度'),
                        IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                      ],
                    ),
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
                Container(
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_upward),
                          onPressed: () {},
                        ),
                        Text('風量'),
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Top'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '詳細'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}
