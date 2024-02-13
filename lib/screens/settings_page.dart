import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/utils/helper_function.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/setting';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late WeatherProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<WeatherProvider>(context);
    getTempStatus().then((value) {
      _provider.setStatus(value);
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: _provider.status,
            onChanged: (value) async{
              _provider.setStatus(value);
              _provider.getData();
              await setTempStatus(value);
            },
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('Default is Celsius'),
          )
        ],
      ),
    );
  }
}
