import 'package:flutter/material.dart';
import 'package:tvapixa/tvholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final navigatorKey = GlobalKey<NavigatorState>();

class TvLink {
  String nome;
  String link;

  TvLink(this.nome, this.link);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List<TvLink> _elements = [];

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initList();
    super.initState();
  }

  Widget listView;
  final ScrollController _scrollController = ScrollController();

  Future<void> initList() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/ricardo-rodrigues143/TvApp/main/App/tvLinks.json?token=AGDOBQKY2CODJTOO3V2A7V3BMHIQ2'));

    Iterable l = json.decode(response.body);
    for (var item in l) {
      _elements.add(new TvLink(item['nome'], item['link']));
    }

    listView = ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: _elements.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TvHolder(
                              tvLink: _elements[index],
                            )));
              },
              child: Material(
                elevation: 1,
                color: Color.fromRGBO(66, 66, 66, 1),
                child: Container(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10.0),
                    title: Text(
                      _elements[index].nome,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ));
        });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: Text("TV DO APIXA"),
        ),
        body: listView == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(child: listView),
        backgroundColor: Color.fromRGBO(16, 16, 16, 1),
      ),
    );
  }
}
