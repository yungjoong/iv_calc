import 'package:flutter/material.dart';

void main() {
  runApp(const IvCalcApp());
}

class IvCalcApp extends StatelessWidget {
  const IvCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '수액 속도 계산기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IvCalcHome(),
    );
  }
}

class IvCalcHome extends StatefulWidget {
  const IvCalcHome({super.key});

  @override
  State<IvCalcHome> createState() => _IvCalcHomeState();
}

class _IvCalcHomeState extends State<IvCalcHome> {
  final _volumeController = TextEditingController();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  
  double _dropFactor = 20.0; // 기본 점적수 (20 gtt/ml)
  
  double _gttPerMin = 0.0;
  double _mlPerHour = 0.0;
  double _secPerDrop = 0.0;

  void _calculate() {
    double volume = double.tryParse(_volumeController.text) ?? 0.0;
    double hours = double.tryParse(_hourController.text) ?? 0.0;
    double minutes = double.tryParse(_minuteController.text) ?? 0.0;
    
    double totalMinutes = (hours * 60) + minutes;

    if (totalMinutes > 0 && volume > 0) {
      setState(() {
        _gttPerMin = (volume * _dropFactor) / totalMinutes;
        _mlPerHour = (volume / totalMinutes) * 60;
        _secPerDrop = _gttPerMin > 0 ? 60 / _gttPerMin : 0.0;
      });
    } else {
      setState(() {
        _gttPerMin = 0.0;
        _mlPerHour = 0.0;
        _secPerDrop = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수액 속도 계산기', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _volumeController.clear();
                _hourController.clear();
                _minuteController.clear();
                _dropFactor = 20.0;
                _calculate();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 입력 섹션
            _buildInputSection(),
            const SizedBox(height: 24),
            
            // 결과 섹션
            _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('수액 정보 입력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _volumeController,
              decoration: const InputDecoration(
                labelText: '총 수액량 (ml)',
                border: OutlineInputBorder(),
                suffixText: 'ml',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hourController,
                    decoration: const InputDecoration(
                      labelText: '시간',
                      border: OutlineInputBorder(),
                      suffixText: 'hr',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _minuteController,
                    decoration: const InputDecoration(
                      labelText: '분',
                      border: OutlineInputBorder(),
                      suffixText: 'min',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('점적수 (Drop Factor)', style: TextStyle(fontSize: 14)),
            Row(
              children: [
                _dropFactorRadio(15),
                _dropFactorRadio(20),
                _dropFactorRadio(60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropFactorRadio(double value) {
    return Row(
      children: [
        Radio<double>(
          value: value,
          groupValue: _dropFactor,
          onChanged: (newValue) {
            setState(() {
              _dropFactor = newValue!;
              _calculate();
            });
          },
        ),
        Text('${value.toInt()} gtt'),
      ],
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        _resultCard('분당 방울 수 (gtt/min)', _gttPerMin.toStringAsFixed(1), 'gtt/min', Colors.blue),
        const SizedBox(height: 12),
        _resultCard('시간당 주입량 (ml/hr)', _mlPerHour.toStringAsFixed(1), 'ml/hr', Colors.green),
        const SizedBox(height: 12),
        _resultCard('방울 간격 (Drop Interval)', _secPerDrop.toStringAsFixed(2), '초(sec)', Colors.orange),
      ],
    );
  }

  Widget _resultCard(String title, String value, String unit, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
