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
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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

 //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display area
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.centerRight,
            child: Text(
              display,
              style: TextStyle(
                fontSize: 52, 
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // Calculator buttons
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Row 1: 7, 8, 9, /
                  Expanded(
                    child: Row(
                    children: [
                      buildButton('7', Colors.indigo[400]!, () => onNumberPressed('7')),
                      buildButton('8', Colors.indigo[400]!, () => onNumberPressed('8')),
                      buildButton('9', Colors.indigo[400]!, () => onNumberPressed('9')),
                      buildButton('/', Colors.teal[600]!, () => onOperatorPressed('/')),
                    ],
                  ),
                ),
                // Row 2: 4, 5, 6, *
                Expanded(
                  child: Row(
                    children: [
                      buildButton('4', Colors.indigo[400]!, () => onNumberPressed('4')),
                      buildButton('5', Colors.indigo[400]!, () => onNumberPressed('5')),
                      buildButton('6', Colors.indigo[400]!, () => onNumberPressed('6')),
                      buildButton('*', Colors.teal[600]!, () => onOperatorPressed('*')),
                    ],
                  ),
                ),
                // Row 3: 1, 2, 3, -
                Expanded(
                  child: Row(
                    children: [
                      buildButton('1', Colors.indigo[400]!, () => onNumberPressed('1')),
                      buildButton('2', Colors.indigo[400]!, () => onNumberPressed('2')),
                      buildButton('3', Colors.indigo[400]!, () => onNumberPressed('3')),
                      buildButton('-', Colors.teal[600]!, () => onOperatorPressed('-')),
                    ],
                  ),
                ),
                // Row 4: C, 0, =, +
                Expanded(
                  child: Row(
                    children: [
                      buildButton('C', Colors.deepOrange[400]!, clear),
                      buildButton('0', Colors.indigo[400]!, () => onNumberPressed('0')),
                      buildButton('=', Colors.amber[700]!, calculateResult),
                      buildButton('+', Colors.teal[600]!, () => onOperatorPressed('+')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}