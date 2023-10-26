import 'package:intl/intl.dart';

extension IntOperations on int {
  String toCurrency({bool useName = false}) => NumberFormat.currency(
        locale: 'en_BD',
        symbol: useName ? null : '৳',
        name: useName ? 'BDT ' : null,
        decimalDigits: 0,
        customPattern: '${useName ? 'BDT ' : '৳'} ##,##,##,##,###',
      ).format(this);
}

extension DateTimeFormat on DateTime {
  String formatDate([String pattern = 'dd-MM-yyyy']) =>
      DateFormat(pattern).format(this);
}

extension StringEx on String {
  int get asInt {
    final replaced = replaceAll(RegExp('[^0-9]'), '');
    return replaced.isEmpty ? 0 : int.parse(replaced);
  }

  double get asDouble => isEmpty ? 0.0 : double.parse(this);

  String showUntil(int end, [int start = 0]) =>
      length >= end ? '${substring(start, end)}...' : this;

  String get toTitleCase {
    List<String> words = split(' ');

    String capitalizedText = ' ';

    for (int i = 0; i < words.length; i++) {
      capitalizedText += words[i][0].toUpperCase() + words[i].substring(1);
      if (i < words.length - 1) {
        capitalizedText += ' ';
      }
    }
    return capitalizedText.trim();
  }

  String ifEmpty([String? emptyText = 'Empty']) =>
      isEmpty ? '$emptyText' : this;

  bool get isValidURL {
    final reg = RegExp(
      r'^(http(s):\/\/.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$',
    );
    return reg.hasMatch(this);
  }

  bool get isValidEmail {
    final reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return reg.hasMatch(this);
  }

  bool get isValidPhone {
    final reg = RegExp(r'(\+8801\d{9})|(01\d{9})');
    return reg.hasMatch(this);
  }

  bool get isWebFile => startsWith('blob:');
}
