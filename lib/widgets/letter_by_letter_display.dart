import 'package:flutter/material.dart';

class LetterByLetterDisplay extends StatelessWidget {
  final String word;
  final String password;

  const LetterByLetterDisplay({
    super.key,
    required this.word,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    List<String> displayedWord = List<String>.from(word.split(''));
    int difference = password.length - displayedWord.length;

    if (difference > 0) {
      displayedWord.insertAll(0, List<String>.filled(difference, ''));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(password.length, (index) {
        String displayedLetter =
            displayedWord.isNotEmpty ? displayedWord.removeAt(0) : '';
        Color color;

        if (displayedLetter == password[index]) {
          color = Colors.green;
        } else if (displayedLetter.isNotEmpty && password[index].isNotEmpty) {
          color = Colors.red;
        } else {
          color = Colors.grey;
        }

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: color,
            child: Text(
              displayedLetter,
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors
                      .white), // Customize o tamanho da fonte conforme necessário
            ),
          ),
        );
      }),
    );
  }
}
