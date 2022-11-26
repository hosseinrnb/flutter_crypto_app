import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_api/data/model/crypto.dart';

class CryptoListScreen extends StatefulWidget {
  CryptoListScreen({Key? key, this.cryptoList}) : super(key: key);

  final List<Crypto>? cryptoList;

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<Crypto>? cryptoList;
  bool searchLoadingVisible = false;

  bool _isDark = false;
  final ThemeData _light = ThemeData.light().copyWith(
    primaryColor: Colors.green,
  );
  final ThemeData _dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
  );

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: _dark,
      theme: _light,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'کریپتو بازار',
            style: TextStyle(
              fontSize: 23,
              fontFamily: 'mr',
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 1,
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDark = !_isDark;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: _getAppBarIcon(_isDark),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    style:
                        TextStyle(color: _isDark ? Colors.black : Colors.white),
                    onChanged: (value) {
                      _filterList(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'رمزارز موردنظر را سرچ کنید..',
                      hintStyle: TextStyle(
                        fontFamily: 'mr',
                        color: _isDark ? Colors.black : Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: _isDark
                          ? Colors.white
                          : Color.fromARGB(255, 21, 21, 21),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: searchLoadingVisible,
                child: Text(
                  '..در حال  آپدیت لیست',
                  style: TextStyle(
                    fontFamily: 'mr',
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: _isDark ? Colors.white : Colors.black,
                  color: _isDark ? Colors.black : Colors.white,
                  onRefresh: () async {
                    List<Crypto> freshData = await _getData();
                    setState(() {
                      cryptoList = freshData;
                    });
                  },
                  child: ListView.builder(
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _getListTileItem(cryptoList![index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> crypto = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapjson(jsonMapObject))
        .toList();
    return crypto;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              crypto.priceUsd.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25.0,
                  child: Center(
                    child: _getIcon(crypto.changePer24hr),
                  ),
                ),
                Text(
                  crypto.changePer24hr.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _getColor(crypto.changePer24hr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIcon(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: Colors.red,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: Colors.green,
          );
  }

  Widget _getAppBarIcon(bool isDark) {
    return isDark
        ? Icon(
            Icons.light_mode,
            size: 25,
            color: Colors.white,
          )
        : Icon(
            Icons.dark_mode,
            size: 25,
            color: Colors.black,
          );
  }

  Color _getColor(double percentChange) {
    return percentChange <= 0 ? Colors.red : Colors.green;
  }

  Future<void> _filterList(String enterKeyword) async {
    List<Crypto> cryptoResultList = [];

    if (enterKeyword.isEmpty) {
      setState(() {
        searchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        searchLoadingVisible = false;
      });
      return;
    }

    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enterKeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
