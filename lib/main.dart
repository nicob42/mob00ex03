import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

final List<String> buttons = [
  '7',
  '8',
  '9',
  'C',
  'AC',
  '4',
  '5',
  '6',
  '+',
  '-',
  '1',
  '2',
  '3',
  '*',
  '/',
  '0',
  '.',
  '00',
  '=',
];

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String command = ''; // La commande entrée par l'utilisateur
  String result = '0'; // Le résultat du calcul
  String operand = ''; // L'opérande en cours
  double num1 = 0.0; // Premier nombre pour le calcul
  double num2 = 0.0; // Deuxième nombre pour le calcul
  String operation = ''; // Opération à effectuer

  // Méthode pour gérer les actions des boutons
  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        command = command.substring(0, command.length - 1);
        if (command.isEmpty) {
          result = '0';
        }
      } else if (buttonText == 'C') {
        command = '';
        result = '0';
        num1 = 0.0;
        num2 = 0.0;
        operand = '';
        operation = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '/') {
        if (operand == '' && result == '0' && buttonText == '-') {
          // Handle negative numbers
          result = buttonText;
          command += buttonText;
        } else {
          num1 = double.parse(result);
          operand = buttonText;
          operation = buttonText;
          command += buttonText;
          result = '0';
        }
      } else if (buttonText == '=') {
        num2 = double.parse(result);
        if (operation == '+') {
          result = (num1 + num2).toString();
        } else if (operation == '-') {
          result = (num1 - num2).toString();
        } else if (operation == '*') {
          result = (num1 * num2).toString();
        } else if (operation == '/') {
          if (num2 != 0) {
            result = (num1 / num2).toString();
          } else {
            result = 'Error';
          }
        }
        num1 = 0.0;
        num2 = 0.0;
        operand = '';
        operation = '';
      } else {
        if (buttonText == '.' && result.contains('.')) {
          return; // Ne pas ajouter un deuxième point décimal
        }
        if (result == '0' && buttonText != '.') {
          result = buttonText;
        } else {
          result += buttonText;
        }
        command += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 98, 98, 126),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w,
            height: h / 4,
            color: Color.fromARGB(255, 127, 127, 162),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  command,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 98, 98, 126),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 5;
                  int rowCount = (buttons.length / crossAxisCount).ceil();
                  double availableHeight = constraints.maxHeight;
                  double buttonWidth = w / crossAxisCount;
                  double buttonHeight = availableHeight / rowCount;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: buttonWidth / buttonHeight,
                    ),
                    itemCount: buttons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            buttonPressed(buttons[index]);
                          },
                          child: Text(buttons[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
