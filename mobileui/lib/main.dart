import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// APIサービスクラス
class ApiService {
  static const String baseUrl =
      'http://ectodermoidal-caryn-sanatory.ngrok-free.dev'; // 適切なURLに変更してください

  // 温度アップAPI呼び出し
  static Future<int?> temperatureUp() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/control/temperature/up'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['body'] as int;
      }
    } catch (e) {
      print('Temperature up API error: $e');
    }
    return null;
  }

  // 温度ダウンAPI呼び出し
  static Future<int?> temperatureDown() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/control/temperature/down'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['body'] as int;
      }
    } catch (e) {
      print('Temperature down API error: $e');
    }
    return null;
  }

  // 電源状態取得
  static Future<bool?> getPowerStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/control/power'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['body'] as bool;
      }
    } catch (e) {
      print('Power status API error: $e');
    }
    return null;
  }

  // ルーム情報取得
  static Future<Map<String, dynamic>?> getRoomInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/info/room'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Room info API error: $e');
    }
    return null;
  }
}

// 予約データクラス
class ReservationData {
  DateTime startTime;
  DateTime endTime;
  int temperature;
  int fanSpeed;
  String mode;

  ReservationData({
    required this.startTime,
    required this.endTime,
    required this.temperature,
    required this.fanSpeed,
    required this.mode,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _reservationIdController =
      TextEditingController();

  void _login() {
    if (_reservationIdController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Air Conditioner Remote'),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  String _mode = '冷房';
  bool _powerOn = true;
  int _powerConsumption = 500;
  List<ReservationData> _reservations = [];

  void _toggleSleepMode(bool value) {
    setState(() {
      _sleepMode = value;
    });
  }

  void _togglePower() async {
    try {
      // まず現在の電源状態を切り替え
      final newPowerState = !_powerOn;

      // API呼び出しを実行（具体的なON/OFFエンドポイントは仮定）
      final response = await http.get(Uri.parse(
          '${ApiService.baseUrl}/control/power/${newPowerState ? "on" : "off"}'));

      if (response.statusCode == 200) {
        setState(() {
          _powerOn = newPowerState;
          _powerConsumption = _powerOn ? 500 : 0;
        });
      } else {
        // API呼び出しが失敗した場合はローカル状態のみ更新
        setState(() {
          _powerOn = newPowerState;
          _powerConsumption = _powerOn ? 500 : 0;
        });
      }
    } catch (e) {
      print('Power toggle error: $e');
      // エラーの場合はローカル状態のみ更新
      setState(() {
        _powerOn = !_powerOn;
        _powerConsumption = _powerOn ? 500 : 0;
      });
    }
  }

  // 初期データをサーバーから取得
  void _loadInitialData() async {
    try {
      // ルーム情報取得
      final roomInfo = await ApiService.getRoomInfo();
      if (roomInfo != null && roomInfo['body'] != null) {
        final roomData = roomInfo['body'];
        setState(() {
          _temperature = roomData['temperature'] ?? 25;
          _powerOn = roomData['power'] ?? true;
          _updatePowerConsumption();
        });
      }

      // 電源状態を個別に取得
      final powerStatus = await ApiService.getPowerStatus();
      if (powerStatus != null) {
        setState(() {
          _powerOn = powerStatus;
          _updatePowerConsumption();
        });
      }
    } catch (e) {
      print('Initial data load error: $e');
      // エラーの場合はデフォルト値を使用
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // アプリ起動時に初期データを読み込み
  }

  void _increaseTemperature() async {
    if (_temperature < 30) {
      final newTemp = await ApiService.temperatureUp();
      if (newTemp != null) {
        setState(() {
          _temperature = newTemp;
          _updatePowerConsumption();
        });
      } else {
        // API呼び出し失敗時はローカルで更新
        setState(() {
          _temperature++;
          _updatePowerConsumption();
        });
      }
    }
  }

  void _decreaseTemperature() async {
    if (_temperature > 16) {
      final newTemp = await ApiService.temperatureDown();
      if (newTemp != null) {
        setState(() {
          _temperature = newTemp;
          _updatePowerConsumption();
        });
      } else {
        // API呼び出し失敗時はローカルで更新
        setState(() {
          _temperature--;
          _updatePowerConsumption();
        });
      }
    }
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

  void _showReservationDialog() {
    DateTime startTime = DateTime.now().add(Duration(hours: 1));
    DateTime endTime = DateTime.now().add(Duration(hours: 2));
    int reservationTemp = _temperature;
    int reservationFanSpeed = _fanSpeed;
    String reservationMode = _mode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text('運転予約'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 開始時刻
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text('開始時刻'),
                      subtitle: Text(
                        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(startTime),
                        );
                        if (time != null) {
                          setDialogState(() {
                            startTime = DateTime(
                              startTime.year,
                              startTime.month,
                              startTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                    // 終了時刻
                    ListTile(
                      leading: Icon(Icons.stop),
                      title: Text('終了時刻'),
                      subtitle: Text(
                        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(endTime),
                        );
                        if (time != null) {
                          setDialogState(() {
                            endTime = DateTime(
                              endTime.year,
                              endTime.month,
                              endTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                    Divider(),
                    // 温度設定
                    ListTile(
                      leading: Icon(Icons.thermostat),
                      title: Text('設定温度'),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (reservationTemp > 16) {
                                setDialogState(() {
                                  reservationTemp--;
                                });
                              }
                            },
                          ),
                          Text('${reservationTemp}°C'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (reservationTemp < 30) {
                                setDialogState(() {
                                  reservationTemp++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // 風量設定
                    ListTile(
                      leading: Icon(Icons.air),
                      title: Text('風量'),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (reservationFanSpeed > 1) {
                                setDialogState(() {
                                  reservationFanSpeed--;
                                });
                              }
                            },
                          ),
                          Text('$reservationFanSpeed'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (reservationFanSpeed < 5) {
                                setDialogState(() {
                                  reservationFanSpeed++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // モード選択
                    ListTile(
                      leading: Icon(Icons.ac_unit),
                      title: Text('運転モード'),
                      subtitle: Container(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: reservationMode,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                reservationMode = newValue;
                              });
                            }
                          },
                          items: ['冷房', '暖房', '除湿']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (startTime.isBefore(endTime)) {
                      setState(() {
                        _reservations.add(
                          ReservationData(
                            startTime: startTime,
                            endTime: endTime,
                            temperature: reservationTemp,
                            fanSpeed: reservationFanSpeed,
                            mode: reservationMode,
                          ),
                        );
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('予約を追加しました'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('終了時刻は開始時刻より後に設定してください'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('予約追加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteReservation(int index) {
    setState(() {
      _reservations.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('予約を削除しました'), backgroundColor: Colors.orange),
    );
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
            SizedBox(height: 5),

            // 予約状態表示
            if (_reservations.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.blue[700], size: 16),
                        SizedBox(width: 4),
                        Text(
                          '運転予約 (${_reservations.length}件)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = _reservations[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 1),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  radius: 8,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${reservation.startTime.hour.toString().padLeft(2, '0')}:${reservation.startTime.minute.toString().padLeft(2, '0')}-${reservation.endTime.hour.toString().padLeft(2, '0')}:${reservation.endTime.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        '${reservation.mode} ${reservation.temperature}°C 風${reservation.fanSpeed}',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _deleteReservation(index),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (_reservations.isNotEmpty) SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('快眠モード', style: TextStyle(fontSize: 12)),
                Switch(
                  value: _sleepMode,
                  onChanged: _toggleSleepMode,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 15),
                IconButton(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: _powerOn ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  onPressed: _togglePower,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 10),
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
                          backgroundColor:
                              _mode == '冷房' ? Colors.lightBlue : null,
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
            SizedBox(height: 5),

            // 予約ボタン
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: _showReservationDialog,
                icon: Icon(Icons.schedule, size: 16),
                label: Text(
                  '運転予約',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
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
