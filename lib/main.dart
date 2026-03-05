import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ClinicalCalcApp());
}

class ClinicalCalcApp extends StatelessWidget {
  const ClinicalCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스마트 임상 계산기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, primary: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const IvRateScreen(),
    const DilutionScreen(),
    const RemainingTimeScreen(),
    const MedicalToolScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: '수액속도'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: '약물희석'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: '잔여시간'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: '건강지표'),
        ],
      ),
    );
  }
}

// --- 1. 수액 속도 계산기 ---
class IvRateScreen extends StatefulWidget {
  const IvRateScreen({super.key});
  @override
  State<IvRateScreen> createState() => _IvRateScreenState();
}

class _IvRateScreenState extends State<IvRateScreen> {
  final _volCtrl = TextEditingController();
  final _hrCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  double _dropFactor = 20.0;
  double _gtt = 0, _mlHr = 0, _sec = 0;

  void _calc() {
    double vol = double.tryParse(_volCtrl.text) ?? 0;
    double totalMin = ((double.tryParse(_hrCtrl.text) ?? 0) * 60) + (double.tryParse(_minCtrl.text) ?? 0);
    if (totalMin > 0 && vol > 0) {
      setState(() {
        _gtt = (vol * _dropFactor) / totalMin;
        _mlHr = (vol / totalMin) * 60;
        _sec = _gtt > 0 ? 60 / _gtt : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수액 속도 계산'), backgroundColor: Colors.indigo[50]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildInputCard([
            _rowInput('총 수액량', _volCtrl, 'ml', _calc),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _rowInput('시간', _hrCtrl, 'hr', _calc)),
              const SizedBox(width: 12),
              Expanded(child: _rowInput('분', _minCtrl, 'min', _calc)),
            ]),
            const SizedBox(height: 12),
            const Text('점적수 (Drop Factor)', style: TextStyle(fontSize: 12)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [15.0, 20.0, 60.0].map((v) => 
              Row(children: [
                Radio<double>(value: v, groupValue: _dropFactor, onChanged: (val) => setState(() { _dropFactor = val!; _calc(); })),
                Text('${v.toInt()} gtt')
              ])).toList()),
          ]),
          const SizedBox(height: 20),
          _resultCard('분당 방울 수', _gtt.toStringAsFixed(1), 'gtt/min', Colors.blue),
          _resultCard('시간당 주입량', _mlHr.toStringAsFixed(1), 'ml/hr', Colors.green),
          _resultCard('방울 간격', _sec.toStringAsFixed(2), '초/방울', Colors.orange),
        ]),
      ),
    );
  }
}

// --- 2. 약물 희석 계산기 (Dosage) ---
class DilutionScreen extends StatefulWidget {
  const DilutionScreen({super.key});
  @override
  State<DilutionScreen> createState() => _DilutionScreenState();
}

class _DilutionScreenState extends State<DilutionScreen> {
  final _desiredCtrl = TextEditingController(); // 처방량
  final _haveCtrl = TextEditingController();    // 보유량
  final _volCtrl = TextEditingController();     // 보유용적
  double _resultMl = 0;

  void _calc() {
    double d = double.tryParse(_desiredCtrl.text) ?? 0;
    double h = double.tryParse(_haveCtrl.text) ?? 0;
    double v = double.tryParse(_volCtrl.text) ?? 0;
    if (h > 0) setState(() => _resultMl = (d / h) * v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약물 용량/희석'), backgroundColor: Colors.teal[50]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildInputCard([
            _rowInput('처방 용량 (Desired)', _desiredCtrl, 'mg/mcg', _calc),
            const SizedBox(height: 12),
            _rowInput('약물 함량 (Have)', _haveCtrl, 'mg/mcg', _calc),
            const SizedBox(height: 12),
            _rowInput('약물 용적 (Volume)', _volCtrl, 'ml', _calc),
          ]),
          const SizedBox(height: 30),
          const Text('투여(추출)할 약물 용량', style: TextStyle(fontSize: 16)),
          Text('${_resultMl.toStringAsFixed(2)} ml', 
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal)),
          const Text('수식: (처방량 / 보유량) × 보유용적', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ),
    );
  }
}

// --- 3. 잔여 시간 계산기 ---
class RemainingTimeScreen extends StatefulWidget {
  const RemainingTimeScreen({super.key});
  @override
  State<RemainingTimeScreen> createState() => _RemainingTimeScreenState();
}

class _RemainingTimeScreenState extends State<RemainingTimeScreen> {
  final _remainVolCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  String _timeLeft = "0시간 0분";
  String _endTime = "-";

  void _calc() {
    double vol = double.tryParse(_remainVolCtrl.text) ?? 0;
    double rate = double.tryParse(_rateCtrl.text) ?? 0;
    if (rate > 0) {
      double hours = vol / rate;
      int h = hours.floor();
      int m = ((hours - h) * 60).round();
      setState(() {
        _timeLeft = "$h시간 $m분";
        _endTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: (hours * 60).round()))).format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수액 잔여 시간'), backgroundColor: Colors.orange[50]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildInputCard([
            _rowInput('남은 수액량', _remainVolCtrl, 'ml', _calc),
            const SizedBox(height: 12),
            _rowInput('현재 주입 속도', _rateCtrl, 'ml/hr', _calc),
          ]),
          const SizedBox(height: 30),
          _resultCard('남은 시간', _timeLeft, '후 종료', Colors.orange),
          _resultCard('예상 완료 시각', _endTime, '', Colors.deepOrange),
        ]),
      ),
    );
  }
}

// --- 4. 건강 지표 (BMI/BSA) ---
class MedicalToolScreen extends StatefulWidget {
  const MedicalToolScreen({super.key});
  @override
  State<MedicalToolScreen> createState() => _MedicalToolScreenState();
}

class _MedicalToolScreenState extends State<MedicalToolScreen> {
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  double _bmi = 0, _bsa = 0;

  void _calc() {
    double h = (double.tryParse(_heightCtrl.text) ?? 0) / 100; // cm to m
    double w = double.tryParse(_weightCtrl.text) ?? 0;
    if (h > 0 && w > 0) {
      setState(() {
        _bmi = w / (h * h);
        _bsa = sqrt(((h * 100) * w) / 3600); // Mosteller formula
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI & BSA 계산'), backgroundColor: Colors.blueGrey[50]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildInputCard([
            _rowInput('신장 (Height)', _heightCtrl, 'cm', _calc),
            const SizedBox(height: 12),
            _rowInput('체중 (Weight)', _weightCtrl, 'kg', _calc),
          ]),
          const SizedBox(height: 30),
          Row(children: [
            Expanded(child: _resultCard('BMI (지수)', _bmi.toStringAsFixed(1), 'kg/m²', Colors.blueGrey)),
            const SizedBox(width: 10),
            Expanded(child: _resultCard('BSA (체표면적)', _bsa.toStringAsFixed(2), 'm²', Colors.indigo)),
          ]),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('※ BSA는 Mosteller 공식을 사용합니다.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          )
        ]),
      ),
    );
  }
}

// --- 공통 위젯들 ---
Widget _buildInputCard(List<Widget> children) {
  return Card(
    elevation: 0,
    color: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: children)),
  );
}

Widget _rowInput(String label, TextEditingController ctrl, String suffix, VoidCallback onChanged) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(labelText: label, suffixText: suffix, filled: true, fillColor: Colors.white),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (_) => onChanged(),
  );
}

Widget _resultCard(String title, String value, String unit, Color color) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color.withOpacity(0.8))),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 4),
          Text(unit, style: TextStyle(fontSize: 12, color: color.withOpacity(0.7))),
        ]),
      ],
    ),
  );
}
