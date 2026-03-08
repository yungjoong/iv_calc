import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class TappingScreen extends StatefulWidget {
  const TappingScreen({super.key});
  @override
  State<TappingScreen> createState() => _TappingScreenState();
}

class _TappingScreenState extends State<TappingScreen>
    with SingleTickerProviderStateMixin {
  final List<DateTime> _taps = [];
  double _dropFactor = 20.0;
  double _gttMin = 0;
  double _mlHr = 0;

  // 애니메이션 (탭 시 파동 효과)
  late AnimationController _rippleCtrl;
  late Animation<double> _rippleAnim;

  @override
  void initState() {
    super.initState();
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rippleAnim = CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _rippleCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    final now = DateTime.now();
    setState(() {
      _taps.add(now);
      // 30초 이상 된 탭은 제거
      _taps.removeWhere(
          (t) => now.difference(t).inSeconds > 30);
      _calculate();
    });
    // 파동 애니메이션
    _rippleCtrl.forward(from: 0);
  }

  void _calculate() {
    if (_taps.length < 2) return;
    // 마지막 최대 8개 탭의 간격 평균
    final recent = _taps.length > 8
        ? _taps.sublist(_taps.length - 8)
        : _taps;
    double totalMs = 0;
    for (int i = 1; i < recent.length; i++) {
      totalMs += recent[i].difference(recent[i - 1]).inMilliseconds;
    }
    final avgIntervalMs = totalMs / (recent.length - 1);
    final intervalSec = avgIntervalMs / 1000;
    setState(() {
      _gttMin = 60 / intervalSec;
      _mlHr = (_gttMin / _dropFactor) * 60;
    });
  }

  void _reset() {
    setState(() {
      _taps.clear();
      _gttMin = 0;
      _mlHr = 0;
    });
  }

  String get _statusText {
    if (_taps.isEmpty) return '방울이 떨어질 때마다\n화면을 탭하세요';
    if (_taps.length == 1) return '계속 탭하세요...';
    return '탭 ${_taps.length}회 측정 중';
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _taps.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('속도 측정 (태핑)'),
        backgroundColor: Colors.indigo[50],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '초기화',
            onPressed: _reset,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDisclaimerDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Drop Factor 선택
          buildInputCard([
            const Text('점적수 (Drop Factor)', style: TextStyle(fontSize: 12)),
            RadioGroup<double>(
              groupValue: _dropFactor,
              onChanged: (val) => setState(() {
                _dropFactor = val!;
                _calculate();
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [15.0, 20.0, 60.0]
                    .map((v) => Row(children: [
                          Radio<double>(value: v),
                          Text('${v.toInt()} gtt'),
                        ]))
                    .toList(),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // 탭 버튼
          GestureDetector(
            onTap: _onTap,
            child: AnimatedBuilder(
              animation: _rippleAnim,
              builder: (context, child) {
                return Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo
                            .withValues(alpha: 0.4 * (1 - _rippleAnim.value)),
                        blurRadius: 0,
                        spreadRadius: 40 * _rippleAnim.value,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, color: Colors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'TAP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            _statusText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
          ),

          const SizedBox(height: 24),

          // 결과
          if (hasResult) ...[
            resultCard(
              '현재 속도',
              _gttMin.toStringAsFixed(1),
              'gtt/min',
              Colors.blue,
            ),
            resultCard(
              '시간당 주입량',
              _mlHr.toStringAsFixed(1),
              'ml/hr',
              Colors.green,
            ),
            resultCard(
              '방울 간격',
              (_gttMin > 0 ? 60 / _gttMin : 0).toStringAsFixed(2),
              '초/방울',
              Colors.orange,
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '탭을 2회 이상 하면\n결과가 표시됩니다',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
              ),
            ),
        ]),
      ),
    );
  }
}
