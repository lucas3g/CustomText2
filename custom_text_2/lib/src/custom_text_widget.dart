import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final List<String> tags;

  static const _separator = " ";

  const CustomText({Key? key, required this.text, required this.tags})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = splitJoin();

    return Text.rich(TextSpan(
        children: parts
            .map(
              (e) => TextSpan(
                text: e.text,
                style: TextStyle(
                  fontWeight: e.isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )
            .toList()));
  }

  // Splits text using separator, tag ones to be bold using regex
  // and rejoin equal parts back when possible
  List<TextPart> splitJoin() {
    final tmp = <TextPart>[];

    final parts = text.split(_separator);
    late int index = 0;
    // Bold it
    for (final p in parts) {
      for (var i = 0; i < tags.length; i++) {
        if (tags[i].contains(p)) {
          index = i;
        }
      }
      tmp.add(TextPart(p + _separator, p.contains(tags[index])));
    }

    final result = <TextPart>[tmp[0]];
    // Fold it
    if (tmp.length > 1) {
      int resultIdx = 0;
      for (int i = 1; i < tmp.length; i++) {
        if (tmp[i - 1].isBold != tmp[i].isBold) {
          result.add(tmp[i]);
          resultIdx++;
        } else {
          result[resultIdx].text = result[resultIdx].text + tmp[i].text;
        }
      }
    }

    return result;
  }
}

class TextPart {
  String text;
  bool isBold;

  TextPart(this.text, this.isBold);
}
