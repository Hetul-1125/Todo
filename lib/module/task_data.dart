import 'package:flutter/material.dart';
import 'package:todo/module/task.dart';
class taskdata extends ChangeNotifier
{
  List<Task> task = [
    Task(name: 'gym'),
    Task(name: 'Reading'),
    Task(name: 'watch movie')
  ];

  void deltetask( task)
  {
    task.remove(task);


  }
}
