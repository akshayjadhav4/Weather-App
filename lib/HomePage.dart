import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WeatherData.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  static String location;
  static String appid = "API_ID";
  var isLoading = true;
  WeatherData weatherData;

  Future<String> getjsondata(String location) async {
    String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$appid";
    var responce = await http.get(
      Uri.encodeFull(url),
    );
    // print(responce.body);
    setState(() {
      weatherData = new WeatherData.fromJson(jsonDecode(responce.body));
      isLoading = false;
      // print(weatherData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Weather",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: isLoading
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.location_searching),
                                labelText: "Location",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: RaisedButton.icon(
                            elevation: 3.0,
                            icon: Icon(
                              Icons.location_searching,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Search",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              setState(() {
                                location = myController.text;
                                // print(location);
                                if (location != "") {
                                  this.getjsondata(location);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text("Enter a Location"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              });
                            },
                          ),
                        ),
                        // CircularProgressIndicator()
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        Text(
                          "Weather in ${weatherData.name}",
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        Image(
                          image: NetworkImage(
                              'https://openweathermap.org/img/w/${weatherData.icon}.png'),
                        ),
                        Text(weatherData.main,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 24.0)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text('${weatherData.temp.toString()}°C',
                            style: new TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(new DateFormat.yMMMd().format(weatherData.date),
                            style: new TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(new DateFormat.Hm().format(weatherData.date),
                            style: new TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text("Speed: ${weatherData.speed} meter/sec",
                            style: new TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text("Deg: ${weatherData.deg} degrees",
                            style: new TextStyle(color: Colors.black)),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: RaisedButton.icon(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Close",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                myController.text = "";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
