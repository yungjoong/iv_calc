import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

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

  // 분 단위 직접 입력 모드
  final _directVolCtrl = TextEditingController();
  final _directMinCtrl = TextEditingController();
  double _directMlHr = 0;

  void _calc() {
    double vol = double.tryParse(_volCtrl.text) ?? 0;
    double totalMin =
        ((double.tryParse(_hrCtrl.text) ?? 0) * 60) + (double.tryParse(_minCtrl.text) ?? 0);
    if (totalMin > 0 && vol > 0) {
      setState(() {
        _gtt = (vol * _dropFactor) / totalMin;
        _mlHr = (vol / totalMin) * 60;
        _sec = _gtt > 0 ? 60 / _gtt : 0;
      });
    }
  }

  void _calcDirect() {
    double vol = double.tryParse(_directVolCtrl.text) ?? 0;
    double min = double.tryParse(_directMinCtrl.text) ?? 0;
    if (min > 0 && vol > 0) {
      setState(() {
        _directMlHr = (vol / min) * 60;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수액 속도 계산'),
        backgroundColor: Colors.indigo[50],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDisclaimerDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // --- gtt 계산기 ---
          buildInputCard([
            rowInput('총 수액량', _volCtrl, 'ml', _calc),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: rowInput('시간', _hrCtrl, 'hr', _calc)),
              const SizedBox(width: 12),
              Expanded(child: rowInput('분', _minCtrl, 'min', _calc)),
            ]),
            const SizedBox(height: 12),
            const Text('점적수 (Drop Factor)', style: TextStyle(fontSize: 12)),
            RadioGroup<double>(
              groupValue: _dropFactor,
              onChanged: (val) => setState(() {
                _dropFactor = val!;
                _calc();
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [15.0, 20.0, 60.0]
                    .map((v) => Row(children: [
                          Radio<double>(value: v),
                          Text('${v.toInt()} gtt')
                        ]))
                    .toList(),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          resultCard('분당 방울 수', _gtt.toStringAsFixed(1), 'gtt/min', Colors.blue),
          resultCard('시간당 주입량', _mlHr.toStringAsFixed(1), 'ml/hr', Colors.green),
          resultCard('방울 간격', _sec.toStringAsFixed(2), '초/방울', Colors.orange),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          // --- 분 단위 빠른 계산 ---
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '⚡ 빠른 계산 — N분간 X ml 주입 시',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[700]),
            ),
          ),
          const SizedBox(height: 8),
          buildInputCard([
            Row(children: [
              Expanded(child: rowInput('수액량', _directVolCtrl, 'ml', _calcDirect)),
              const SizedBox(width: 12),
              Expanded(child: rowInput('주입 시간', _directMinCtrl, 'min', _calcDirect)),
            ]),
          ]),
          const SizedBox(height: 12),
          resultCard('시간당 주입 속도', _directMlHr.toStringAsFixed(1), 'ml/hr', Colors.purple),
        ]),
      ),
    );
  }
}
