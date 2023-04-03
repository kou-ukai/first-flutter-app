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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent)),
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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// _始まりのクラスはprivateクラスを表す
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  // Widgetの状況が変化するたびに呼び出される
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        SafeArea(
            child: NavigationRail(
          // アイコンの隣にテキストを表示するかの判定
          extended: false,
          destinations: [
            // ナビゲーション　線路　行先
            NavigationRailDestination(
                icon: Icon(Icons.home), label: Text('Home')),
            NavigationRailDestination(
                icon: Icon(Icons.favorite), label: Text('Favorites')),
          ],
          // 選択した行先
          selectedIndex: selectedIndex,
          // 行先を選択イベント処理
          onDestinationSelected: (value) {
            // notifyListenersと同等
            setState(() {
              selectedIndex = value;
            });
          },
        )),
        // 余っている領域合わせて広がる領域
        Expanded(
            child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: GeneratorPage(),
        ))
      ]),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like')),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'))
            ],
          )
        ],
      ),
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
    // アプリのテーマを取得
    final theme = Theme.of(context);
    // アプリテーマのテキストデザインから色だけ指定して複製
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      // カードにアプリのプライマリカラーを適用
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          // 読み上げ用
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
