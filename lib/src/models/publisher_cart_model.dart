import 'package:flutter/material.dart';

class PublisherCart with ChangeNotifier {
  String id;
  String cartName;
  String publisher;
  DateTime initialDate;
  DateTime finalDate;
  String observations;

  PublisherCart({
    required this.id,
    required this.cartName,
    required this.publisher,
    required this.initialDate,
    required this.finalDate,
    required this.observations,
  });

  void onSaved() {
    notifyListeners();
  }
}
