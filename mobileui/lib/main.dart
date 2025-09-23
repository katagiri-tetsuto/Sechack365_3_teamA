import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _reservationIdController = TextEditingController();

  void _login() {
    if (_reservationIdController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Air Conditioner Remote'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('予約IDを入力してください'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('予約アプリ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アプリロゴまたはアイコン
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.book_online,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              
              // アプリ名
              Text(
                '予約アプリ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              
              // 予約ID入力フィールド
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _reservationIdController,
                  decoration: InputDecoration(
                    labelText: '予約ID',
                    hintText: '予約IDを入力してください',
                    prefixIcon: const Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // ログインボタン
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reservationIdController.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '予約アプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
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
  int _temperature = 25;
  int _fanSpeed = 2; // 1-5段階
  String _mode = 'Cool';
  bool _powerOn = true;
  int _powerConsumption = 500;

  void _toggleSleepMode(bool value) {
    setState(() {
      _sleepMode = value;
    });
  }

  void _togglePower() {
    setState(() {
      _powerOn = !_powerOn;
      _powerConsumption = _powerOn ? 500 : 0;
    });
  }

  void _increaseTemperature() {
    setState(() {
      if (_temperature < 30) {
        _temperature++;
        _updatePowerConsumption();
      }
    });
  }

  void _decreaseTemperature() {
    setState(() {
      if (_temperature > 16) {
        _temperature--;
        _updatePowerConsumption();
      }
    });
  }

  void _increaseFanSpeed() {
    setState(() {
      if (_fanSpeed < 5) {
        _fanSpeed++;
        _updatePowerConsumption();
      }
    });
  }

  void _decreaseFanSpeed() {
    setState(() {
      if (_fanSpeed > 1) {
        _fanSpeed--;
        _updatePowerConsumption();
      }
    });
  }

  void _changeMode(String mode) {
    setState(() {
      _mode = mode;
      _updatePowerConsumption();
    });
  }

  void _updatePowerConsumption() {
    if (!_powerOn) {
      _powerConsumption = 0;
      return;
    }

    int basePower = 300;
    int tempFactor = (_temperature - 20).abs() * 20;
    int fanFactor = _fanSpeed * 30;
    int modeFactor = _mode == '暖房' ? 100 : (_mode == '冷房' ? 80 : 40);

    _powerConsumption = basePower + tempFactor + fanFactor + modeFactor;
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
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 温度表示（大きく）
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue[200]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.thermostat,
                          size: 40,
                          color: Colors.blue[700],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_temperature}°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 電力とモード（縦並び）
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.power, color: Colors.green[700]),
                            SizedBox(width: 5),
                            Text(
                              '${_powerConsumption}W',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.ac_unit, color: Colors.green[700]),
                            SizedBox(width: 5),
                            Text(
                              _mode,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('快眠モード'),
                Switch(value: _sleepMode, onChanged: _toggleSleepMode),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: _powerOn ? Colors.green : Colors.red,
                  ),
                  onPressed: _togglePower,
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
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _increaseTemperature,
                        ),
                        Text('温度'),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decreaseTemperature,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _changeMode('暖房'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mode == '暖房' ? Colors.orange : null,
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.local_fire_department),
                            Text('暖房'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _changeMode('除湿'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mode == '除湿' ? Colors.blue : null,
                        ),
                        child: Column(
                          children: [Icon(Icons.water_drop), Text('除湿')],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _changeMode('冷房'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _mode == '冷房'
                              ? Colors.lightBlue
                              : null,
                        ),
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
                          onPressed: _increaseFanSpeed,
                        ),
                        Text('風量\n${_fanSpeed}'),
                        IconButton(
                          icon: Icon(Icons.arrow_downward),
                          onPressed: _decreaseFanSpeed,
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
