import 'package:bruteforce/widgets/letter_by_letter_display.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BruteForceApp());
}

class BruteForceApp extends StatelessWidget {
  const BruteForceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brute Force',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BruteForceScreen(title: 'Brute Force Simulator'),
    );
  }
}

class BruteForceScreen extends StatefulWidget {
  const BruteForceScreen({super.key, required this.title});
  final String title;

  @override
  State<BruteForceScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BruteForceScreen> {
  bool bruteForcing = false;
  bool letterByLetter = false;
  TextEditingController passwordController = TextEditingController();
  String password = '';
  String currentAttempt = '';
  String digits = "abcdefghijklmnopqrstuvwxyz ";
  late DateTime start, end;

  void toggleBruteForcing() {
    setState(() {
      bruteForcing = !bruteForcing;
      currentAttempt = "";
    });
  }

  void setLetterByLetter(bool newStatus) {
    setState(() {
      letterByLetter = newStatus;
    });
  }

  void bruteForceLetterByLetter(String target) async {
    start = DateTime.now();
    String correctPart = '';
    for (int index = target.length - 1; index >= 0; index--) {
      bool found = false;
      for (int i = 0; i < digits.length; i++) {
        String attempt = digits[i] + correctPart;
        setState(() {
          currentAttempt = attempt;
        });
        await Future.delayed(const Duration(milliseconds: 1));
        if (attempt ==
            target.substring(target.length - correctPart.length - 1)) {
          correctPart = attempt;
          found = true;
          end = DateTime.now();
          break;
        }
        if (!bruteForcing) {
          break;
        }
      }
      end = DateTime.now();
      if (!found) {
        break;
      }
    }
  }

  void bruteForceWholeWord(String target) async {
    start = DateTime.now();
    for (int length = 1; length <= target.length; length++) {
      for (var attempt in _generateCombinations(digits, length)) {
        await Future.delayed(const Duration(milliseconds: 1));
        final attemptStr = attempt.join();
        setState(() {
          currentAttempt = attemptStr;
        });
        if (attemptStr == target) {
          end = DateTime.now();
          return;
        }
        if (!bruteForcing) {
          break;
        }
      }
    }
    end = DateTime.now();
  }

  Iterable<List<String>> _generateCombinations(
      String digits, int length) sync* {
    if (length == 0) {
      yield [];
      return;
    }
    for (var char in digits.split('')) {
      for (var combination in _generateCombinations(digits, length - 1)) {
        yield [char, ...combination];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: bruteForcing
          ? FloatingActionButton(
              onPressed: toggleBruteForcing,
              child: const Icon(Icons.cancel),
            )
          : null,
      body: Center(
        child: bruteForcing
            ? SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LetterByLetterDisplay(
                      word: password,
                      password: password,
                    ),
                    LetterByLetterDisplay(
                      word: currentAttempt,
                      password: password,
                    ),
                    const SizedBox(height: 10),
                    Text(
                        currentAttempt == password
                            ? "The password can be ${letterByLetter ? "letter by letter" : "fully"} bruteforced in ${end.difference(start).inSeconds} second${end.difference(start).inSeconds != 1 ? "s" : ""}!"
                            : "Bruteforcing...",
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              )
            : SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Insert the password to try bruteforcing:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffix: IconButton(
                            onPressed: () {
                              password = passwordController.text;
                              passwordController.clear();
                              toggleBruteForcing();
                              letterByLetter
                                  ? bruteForceLetterByLetter(password)
                                  : bruteForceWholeWord(password);
                            },
                            icon: const Icon(Icons.start)),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Bruteforce Mode: "),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => setLetterByLetter(false),
                              child: Row(
                                children: [
                                  Radio(
                                    value: false,
                                    groupValue: letterByLetter,
                                    onChanged: (_) => setLetterByLetter(false),
                                  ),
                                  Text(
                                    "Whole Word",
                                    style: TextStyle(
                                      color: letterByLetter
                                          ? Theme.of(context).colorScheme.shadow
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => setLetterByLetter(true),
                              child: Row(
                                children: [
                                  Radio(
                                    value: true,
                                    groupValue: letterByLetter,
                                    onChanged: (_) => setLetterByLetter(true),
                                  ),
                                  Text(
                                    "Letter by Letter",
                                    style: TextStyle(
                                      color: letterByLetter
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
