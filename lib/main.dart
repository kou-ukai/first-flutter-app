import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  // Widgetの状況が変化するたびに呼び出される
  @override
  Widget build(BuildContext context) {
    // MyAppStateの状況の変化を監視
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    // buildメソッドはWidgetのサブクラスを戻り値に持ち、ルートWidgetはほとんどの場合Scaffoldを返す
    return Scaffold(
      body: Column(children: [
        Text('A random AWESOME idea:'),
        BigCard(pair: pair),
        ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'))
      ]),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}
