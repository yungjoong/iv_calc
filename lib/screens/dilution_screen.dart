import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

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
      appBar: AppBar(
        title: const Text('약물 용량/희석'),
        backgroundColor: Colors.teal[50],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDisclaimerDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          buildInputCard([
            rowInput('처방 용량 (Desired)', _desiredCtrl, 'mg/mcg', _calc),
            const SizedBox(height: 12),
            rowInput('약물 함량 (Have)', _haveCtrl, 'mg/mcg', _calc),
            const SizedBox(height: 12),
            rowInput('약물 용적 (Volume)', _volCtrl, 'ml', _calc),
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
