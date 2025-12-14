import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const CalculatorScreen({super.key, required this.toggleTheme});

  @override
  State<CalculatorScreen> createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  double result = 0;

  double get firstValue => double.tryParse(firstController.text) ?? 0;
  double get secondValue => double.tryParse(secondController.text) ?? 0;

  void resetCalculator() {
    setState(() {
      firstController.clear();
      secondController.clear();
      result = 0;
    });
  }

  // Для анимации кнопок
  double scalePlus = 1.0;
  double scaleMinus = 1.0;
  double scaleMul = 1.0;
  double scaleDiv = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Color(0xFFF4F6FA);
    final cardColor = isDark ? Colors.grey[800] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Mini Calculator'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// РЕЗУЛЬТАТ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                result.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// ПЕРВОЕ ЧИСЛО
            TextField(
              controller: firstController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Первое число',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// ВТОРОЕ ЧИСЛО
            TextField(
              controller: secondController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Второе число',
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// КНОПКИ С АНИМАЦИЕЙ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _animatedButton('+', Colors.indigo, () {
                  setState(() => result = firstValue + secondValue);
                }, scale: scalePlus, setScale: (val) {
                  setState(() => scalePlus = val);
                }),
                _animatedButton('-', Colors.orange, () {
                  setState(() => result = firstValue - secondValue);
                }, scale: scaleMinus, setScale: (val) {
                  setState(() => scaleMinus = val);
                }),
                _animatedButton('*', Colors.green, () {
                  setState(() => result = firstValue * secondValue);
                }, scale: scaleMul, setScale: (val) {
                  setState(() => scaleMul = val);
                }),
                _animatedButton('/', Colors.red, () {
                  setState(() {
                    result = secondValue == 0 ? 0 : firstValue / secondValue;
                  });
                }, scale: scaleDiv, setScale: (val) {
                  setState(() => scaleDiv = val);
                }),
              ],
            ),
            const SizedBox(height: 20),

            /// СБРОС
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: resetCalculator,
                child: const Text(
                  'Сброс',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Анимированная кнопка
  Widget _animatedButton(
      String text, Color color, VoidCallback onPressed,
      {required double scale, required Function(double) setScale}) {
    return Listener(
      onPointerDown: (_) => setScale(0.9),
      onPointerUp: (_) {
        setScale(1.0);
        onPressed();
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: const CircleBorder(),
              elevation: 5,
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
