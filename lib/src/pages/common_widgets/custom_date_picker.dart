import 'package:flutter/material.dart';

customDatePicker(context) {
  DateTime dateToday = DateTime.now();
  while (dateToday.weekday != 6) {
    dateToday = dateToday.add(const Duration(days: 1));
  }
  showDatePicker(
    context: context,
    selectableDayPredicate: (DateTime val) => val.weekday != 6 ? false : true,
    initialDate: dateToday,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 90)),
  ).then((pickedDate) {
    if (pickedDate == null) {
      return pickedDate;
    }
  });
}
