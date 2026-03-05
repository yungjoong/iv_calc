import 'package:flutter/material.dart';

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
