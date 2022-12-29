import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_api/data/model/crypto.dart';
import 'package:flutter_application_api/screens/crypto_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = 'Loading';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitPouringHourGlassRefined(
                color: Colors.black,
                size: 80.0,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapjson(jsonMapObject))
        .toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CryptoListScreen(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
