import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PrayerTimesApp());

class PrayerTimesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Times',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: PrayerTimesScreen(),
    );
  }
}

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  TextEditingController _cityController = TextEditingController();
  String _prayerTimes = '';

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void fetchPrayerTimes(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity?city=$city&country=Indonesia'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final timings = data['data']['timings'];

      setState(() {
        _prayerTimes = '';
        timings.forEach((key, value) {
          _prayerTimes += '$key: $value\n';
        });
      });
    } else {
      setState(() {
        _prayerTimes = 'Gagal mengambil jadwal sholat. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Sholat'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Kota',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text(
                        'Tampilkan Jadwal Sholat',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        fetchPrayerTimes(_cityController.text);
                      },
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          _prayerTimes,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}