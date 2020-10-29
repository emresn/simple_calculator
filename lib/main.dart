import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        // fontFamily: 'Orbiton',
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Calculator'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List operators = ["+", "-", "x", "/", "%"];
  List memoryList = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: Text(widget.title),
        ),
        body: Container(
          color: Color(0xff959B7F),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFormField(
                      enabled: false,
                      maxLines: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 4
                          : 2,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 30
                            : 25,
                        fontFamily: 'Orbiton',
                        letterSpacing: 2.0,
                      ),
                      controller: _controller,
                    ),
                  ],
                ),
              ),
              Table(
                // textDirection: TextDirection.rtl,

                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(width: 1, color: Colors.grey.shade900),

                children: [
                  TableRow(children: [
                    _buildButton("+/-"),
                    _buildButton("%"),
                    _buildButton("<--"),
                    _buildButton("AC"),
                  ]),
                  TableRow(children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("/"),
                  ]),
                  TableRow(children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("x"),
                  ]),
                  TableRow(children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("-"),
                  ]),
                  TableRow(children: [
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("="),
                    _buildButton("+"),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  calcAllSameOperations(String op) {
    List sameOperationList = [];
    memoryList.forEach((k) {
      if (k == op) {
        sameOperationList.add(k);
      }
    });
    sameOperationList.forEach((c) {
      calculate(op);
    });
  }

  calculate(op) {
    var range = new List<int>.generate(memoryList.length, (j) => j);
    for (var i in range) {
      try {
        if (memoryList[i] == op) {
          setState(() {
            var a = memoryList[i - 1].toString().startsWith("(-)")
                ? memoryList[i - 1] = "-" +
                    memoryList[i - 1]
                        .toString()
                        .substring(3, memoryList[i - 1].toString().length)
                : memoryList[i - 1];
            var b = memoryList[i + 1].toString().startsWith("(-)")
                ? memoryList[i + 1] = "-" +
                    memoryList[i + 1]
                        .toString()
                        .substring(3, memoryList[i + 1].toString().length)
                : memoryList[i + 1];
            print(memoryList);

            op == "%"
                ? memoryList[i] =
                    (double.parse(a) * double.parse(b) / 100).toString()
                : op == "x"
                    ? memoryList[i] =
                        (double.parse(a) * double.parse(b)).toString()
                    : op == "/"
                        ? memoryList[i] =
                            (double.parse(a) / double.parse(b)).toString()
                        : op == "+"
                            ? memoryList[i] =
                                (double.parse(a) + double.parse(b)).toString()
                            : op == "-"
                                ? memoryList[i] =
                                    (double.parse(a) - double.parse(b))
                                        .toString()
                                : memoryList[i].toString();

            memoryList[i - 1] = "";
            memoryList[i + 1] = "";
            memoryList.removeWhere((k) => k == "");
            print(memoryList);
          });
        }
      } catch (e) {}
    }
  }

  updateController() {
    _controller.text = "";
    setState(() {
      memoryList.forEach((element) {
        _controller.text = _controller.text + element;
      });
    });
  }

  _plotScreen(String button) {
    if (button == "<--") {
      if (operators.contains(memoryList.last) || memoryList.last == "") {
        memoryList.removeLast();
      } else {
        memoryList.last = memoryList.last
            .toString()
            .substring(0, memoryList.last.toString().length - 1);
      }
    } else if (button == "AC") {
      setState(() {
        memoryList = [];

        _controller.text = "";
      });
    } else if (button == "=") {
      calcAllSameOperations("%");
      calcAllSameOperations("x");
      calcAllSameOperations("/");
      calcAllSameOperations("+");
      calcAllSameOperations("-");
      if (memoryList.length == 1 && memoryList.last.toString().endsWith(".0")) {
        setState(() {
          memoryList.last = memoryList.last
              .toString()
              .substring(0, memoryList.last.toString().length - 2);
        });
      }
    } else if (numbers.contains(button)) {
      if (memoryList.isEmpty) {
        memoryList.add(button);
      } else if (memoryList.last.toString().startsWith("(-)")) {
        memoryList.last = memoryList.last + button;
      } else if (operators.contains(memoryList.last)) {
        memoryList.add(button);
      } else {
        memoryList.last = memoryList.last + button;
      }
    } else if (operators.contains(button)) {
      if (memoryList.isEmpty) {
        return null;
      } else if (memoryList.last.toString().startsWith("-")) {
        memoryList.last = memoryList.last + button;
      } else if (operators.contains(memoryList.last)) {
        memoryList.last = button;
      } else {
        memoryList.add(button);
      }
    } else if (button == "+/-") {
      if (memoryList.isEmpty) {
        memoryList.add("(-)");
      } else if (memoryList.last.toString().startsWith("(-)")) {
        memoryList.last = memoryList.last
            .toString()
            .substring(3, memoryList.last.toString().length);
      } else if (operators.contains(memoryList.last)) {
        memoryList.add("(-)");
      } else {
        memoryList.last = "(-)" + memoryList.last;
      }
    } else if (button == ".") {
      if (numbers.contains(memoryList.last)) {
        memoryList.last = memoryList.last.toString() + ".";
      }
    } else {
      setState(() {
        memoryList.add(button);
      });
    }
    updateController();
  }

  Widget _buildButton(String string) {
    return GestureDetector(
      onTap: () => _plotScreen(string),
      child: Container(
        color: Colors.grey.shade300,
        child: Center(
          child: Padding(
            padding: MediaQuery.of(context).orientation == Orientation.portrait
                ? const EdgeInsets.symmetric(vertical: 25)
                : const EdgeInsets.symmetric(vertical: 10),
            child: Text(string,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                )),
          ),
        ),
      ),
    );
  }
}
