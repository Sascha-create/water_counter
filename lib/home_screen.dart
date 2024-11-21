import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_counter/database_repository.dart';
import 'package:water_counter/mock_database.dart';
import 'package:water_counter/water_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final DatabaseRepository repository = MockDatabase();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _saveDate();
    _checkDate();
    _loadCounter();
  }

  void _saveDate() async {
    DateTime actualDate = DateTime.now();
    await prefs.setInt("year", actualDate.year);
    await prefs.setInt("month", actualDate.month);
    await prefs.setInt("day", actualDate.day);
  }

  void _checkDate() async {
    DateTime actualDate = DateTime.now();
    int savedYear = await prefs.getInt("year") ?? 0;
    int savedMonth = await prefs.getInt("month") ?? 0;
    int savedDay = await prefs.getInt("day") ?? 0;
    if (actualDate.year != savedYear) {
      if (actualDate.month != savedMonth) {
        if (actualDate.day != savedDay) {
          setState(() {
            _counter = 0;
          });
        }
      }
    }
  }

  void _loadCounter() async {
    final rememberedCounter = await prefs.getInt("counter") ?? 0;
    setState(() {
      _counter = rememberedCounter;
    });
  }

  void _saveCounter() async {
    await prefs.setInt("counter", _counter);
  }

  void _incrementCounter() async {
    _saveDate();
    await widget.repository.incrementCounter();
    final updatedCounter = await widget.repository.getCounter();
    setState(() {
      _counter = updatedCounter;
    });
    //await prefs.setInt("counter", _counter);
    _saveCounter();
  }

  // TODO: This should be implemented.
  // ignore: unused_element
  void _decrementCounter() async {
    _saveDate();
    setState(() {
      _counter > 0 ? _counter-- : null;
    });
    //await prefs.setInt("counter", _counter);
    _saveCounter();
  }

  void _resetCounter() async {
    setState(() {
      _counter = 0;
    });

    //await prefs.setInt("counter", _counter);
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8.0,
          title: const Text("WaterCounter"),
        ),
        body: WaterScreen(
          counter: _counter,
          incrementCounter: _incrementCounter,
          decrementCounter: _decrementCounter,
          resetCounter: _resetCounter,
        ));
  }
}
