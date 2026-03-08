import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

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
        _endTime = TimeOfDay.fromDateTime(
                DateTime.now().add(Duration(minutes: (hours * 60).round())))
            .format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수액 잔여 시간'),
        backgroundColor: Colors.orange[50],
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
            rowInput('남은 수액량', _remainVolCtrl, 'ml', _calc),
            const SizedBox(height: 12),
            rowInput('현재 주입 속도', _rateCtrl, 'ml/hr', _calc),
          ]),
          const SizedBox(height: 30),
          resultCard('남은 시간', _timeLeft, '후 종료', Colors.orange),
          resultCard('예상 완료 시각', _endTime, '', Colors.deepOrange),
        ]),
      ),
    );
  }
}
