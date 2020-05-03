import 'package:flutter/material.dart';

class WeekReport {
  String wB;
  double rating;
  List<String> report;

  WeekReport({this.wB, this.rating, this.report});

  Color getColor(double rating) {
    if (rating >= 0 && rating < 0.4) {
      return Colors.green[100];
    }
    if (rating >= 0.4 && rating < 0.8) {
      return Colors.amber[100];
    } else {
      return Colors.red[100];
    }
  }

  List<String> getAdvice(double rating) {
    //Need to seek expert opinion but these are the examples we currently have
    //Should also have option to edit tasks
    if (rating >= 0 && rating < 0.4) {
      return [
        'Well done for maintaining a healthy state of mind!',
        'Exercise at least 3 times this week',
        'Take a break to connect with others daily',
        'Challenge yourself to develop a new skill this week'
      ];
    }
    if (rating >= 0.4 && rating < 0.8) {
      return [
        'Improving your mental health should be your priority this week.',
        'Develop a routine and practice mindfulness during these activities',
        'Exercise regularly and follow a healthy diet to improve your overall health',
        'Connect with others daily and ask for help with developing your gratitutde and self-esteem'
      ];
    } else {
      return [
        'Your results indicate that you are experiencing symptoms of depression.',
        'Talk to someone, either a health professional or trusted contact',
        'Improve your physical health with a healthy diet and exercise routine',
        'Focus on your favourite activities and seek ways of increasing your mindfulness'
      ];
    }
  }
}
