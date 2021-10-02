import 'package:flutter/material.dart';
import 'package:myapp/tvholder.dart';
import 'package:flutter/services.dart';

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

List<TvLink> _elements = [
  TvLink("Sport Tv 1", "https://es-cdn.com/stream/clappr.html?c=stv1"),
  TvLink("Sport Tv 1", "https://es-cdn.com/stream/clappr.html?c=stv1"),
];

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initList();
    super.initState();
  }

  Widget listView;
  final ScrollController _scrollController = ScrollController();

  void initList() {
    SystemChrome.setEnabledSystemUIOverlays([]);
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
        body: Scrollbar(child: listView),
        backgroundColor: Color.fromRGBO(16, 16, 16, 1),
      ),
    );
  }
}
