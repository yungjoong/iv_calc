import 'package:flutter/material.dart';

void showDisclaimerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text('면책 조항 (Disclaimer)'),
        ],
      ),
      content: const SingleChildScrollView(
        child: Text(
          '본 애플리케이션에서 제공하는 계산 결과는 참고용이며, 어떠한 경우에도 의료진의 판단이나 전문적인 의학적 조언을 대신할 수 없습니다.\n\n'
          '사용자는 계산 결과를 실제 임상에 적용하기 전에 반드시 수동으로 재확인해야 하며, 앱의 오류나 계산 결과로 인해 발생하는 문제에 대해 개발자는 법적 책임을 지지 않습니다.',
          style: TextStyle(height: 1.5),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

Widget buildInputCard(List<Widget> children) {
  return Card(
    elevation: 0,
    color: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: children)),
  );
}

Widget rowInput(String label, TextEditingController ctrl, String suffix, VoidCallback onChanged) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(labelText: label, suffixText: suffix, filled: true, fillColor: Colors.white),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (_) => onChanged(),
  );
}

Widget resultCard(String title, String value, String unit, Color color) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.8))),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 4),
          Text(unit, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7))),
        ]),
      ],
    ),
  );
}
