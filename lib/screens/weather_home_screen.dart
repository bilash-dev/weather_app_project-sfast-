import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/utils/helper_function.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({Key? key}) : super(key: key);
  static const routeName ='/home';

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset('images/sunset.jpg', width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
          Center(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 80,),
                Column(
                  children: [
                    Text(getFormattedDate(DateTime.now().millisecondsSinceEpoch, 'EEE MMM, YYYY'), style: TextStyle(fontSize: 16),),
                    Text('Dhaka, BD', style:  TextStyle(fontSize: 22),),
                    Text('25\u00B0',style:  TextStyle(fontSize: 80),),
                    Text('feels like 30\u00B0', style: TextStyle(fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network('https://st.depositphotos.com/1000148/2512/v/950/depositphotos_25122475-stock-illustration-vector-illustration-of-sunrise-sun.jpg', width: 50, height: 50, fit: BoxFit.cover,),
                        Text('Sunny')
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 40,
                    itemBuilder: (context, i){
                      return Card(
                        elevation: 10,
                        margin: EdgeInsets.all(4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Sun 9AM'),
                              Image.network('https://st.depositphotos.com/1000148/2512/v/950/depositphotos_25122475-stock-illustration-vector-illustration-of-sunrise-sun.jpg', width: 50, height: 50, fit: BoxFit.cover,),
                              Text('31/21\u00B0')
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
