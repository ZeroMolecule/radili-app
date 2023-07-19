import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ColorScheme useColorScheme(){
  final context = useContext();
  return Theme.of(context).colorScheme;
}