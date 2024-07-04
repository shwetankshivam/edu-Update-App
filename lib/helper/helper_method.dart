//return a formatted date as a  string

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

//year
  String year = dateTime.year.toString();

//month
  String month = dateTime.month.toString();
//day
  String day = dateTime.day.toString();

//hour

  String hour = dateTime.hour.toString();

  //minute

  String minute = dateTime.minute.toString();
// final format

  String formattedData = "$hour:$minute - $day/$month/$year";
  return formattedData;
}
