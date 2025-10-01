import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}


class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String firstOperand = '';
  String operator = '';
  bool shouldResetDisplay = false;

  // Handle number button press
  void onNumberPressed(String number) {
    setState(() {
      if (display == '0' || shouldResetDisplay) {
        display = number;
        shouldResetDisplay = false;
      } else {
        display += number;
      }
    });
  }

  // Handle operator button press
  void onOperatorPressed(String op) {
    setState(() {
      firstOperand = display;
      operator = op;
      shouldResetDisplay = true;
    });
  }

  // Calculate result
  void calculateResult() {
    if (firstOperand.isEmpty || operator.isEmpty) return;

    double num1 = double.parse(firstOperand);
    double num2 = double.parse(display);
    double result = 0;

    // Perform calculation based on operator
    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        // Handle division by zero
        if (num2 == 0) {
          setState(() {
            display = 'Error';
            firstOperand = '';
            operator = '';
          });
          return;
        }
        result = num1 / num2;
        break;
    }

    setState(() {
      // Remove decimal point if result is whole number
      display = result % 1 == 0 ? result.toInt().toString() : result.toString();
      firstOperand = '';
      operator = '';
      shouldResetDisplay = true;
    });
  }

  // Clear calculator
  void clear() {
    setState(() {
      display = '0';
      firstOperand = '';
      operator = '';
      shouldResetDisplay = false;
    });
  }

  // Build calculator button
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(24),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          // Display area
          Container(
            padding: EdgeInsets.all(24),
            alignment: Alignment.centerRight,
            child: Text(
              display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          // Calculator buttons
          Expanded(
            child: Column(
              children: [
                // Row 1: 7, 8, 9, /
                Expanded(
                  child: Row(
                    children: [
                      buildButton('7', Colors.grey[700]!, () => onNumberPressed('7')),
                      buildButton('8', Colors.grey[700]!, () => onNumberPressed('8')),
                      buildButton('9', Colors.grey[700]!, () => onNumberPressed('9')),
                      buildButton('/', Colors.orange, () => onOperatorPressed('/')),
                    ],
                  ),
                ),
                // Row 2: 4, 5, 6, *
                Expanded(
                  child: Row(
                    children: [
                      buildButton('4', Colors.grey[700]!, () => onNumberPressed('4')),
                      buildButton('5', Colors.grey[700]!, () => onNumberPressed('5')),
                      buildButton('6', Colors.grey[700]!, () => onNumberPressed('6')),
                      buildButton('*', Colors.orange, () => onOperatorPressed('*')),
                    ],
                  ),
                ),
                // Row 3: 1, 2, 3, -
                Expanded(
                  child: Row(
                    children: [
                      buildButton('1', Colors.grey[700]!, () => onNumberPressed('1')),
                      buildButton('2', Colors.grey[700]!, () => onNumberPressed('2')),
                      buildButton('3', Colors.grey[700]!, () => onNumberPressed('3')),
                      buildButton('-', Colors.orange, () => onOperatorPressed('-')),
                    ],
                  ),
                ),
                // Row 4: C, 0, =, +
                Expanded(
                  child: Row(
                    children: [
                      buildButton('C', Colors.red, clear),
                      buildButton('0', Colors.grey[700]!, () => onNumberPressed('0')),
                      buildButton('=', Colors.green, calculateResult),
                      buildButton('+', Colors.orange, () => onOperatorPressed('+')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}