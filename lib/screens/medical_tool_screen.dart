import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/common_widgets.dart';

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
          buildInputCard([
            rowInput('신장 (Height)', _heightCtrl, 'cm', _calc),
            const SizedBox(height: 12),
            rowInput('체중 (Weight)', _weightCtrl, 'kg', _calc),
          ]),
          const SizedBox(height: 30),
          Row(children: [
            Expanded(child: resultCard('BMI (지수)', _bmi.toStringAsFixed(1), 'kg/m²', Colors.blueGrey)),
            const SizedBox(width: 10),
            Expanded(child: resultCard('BSA (체표면적)', _bsa.toStringAsFixed(2), 'm²', Colors.indigo)),
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
