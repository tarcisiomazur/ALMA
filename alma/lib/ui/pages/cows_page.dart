import 'package:alma/models/cow.dart';
import 'package:alma/models/user.dart';
import 'package:alma/services/preferences.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/cow_info_card.dart';
import 'package:alma/ui/my_drawer.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class CowsPage extends StatefulWidget {
  const CowsPage({Key? key}) : super(key: key);

  static const String route = '/cows';

  @override
  State<CowsPage> createState() => _CowsPageState();
}

class _CowsPageState extends State<CowsPage> {
  late ServerApi _serverApi;
  late Future _cowsFuture;
  late List<Cow> _cows;
  User? _user;
  final ScrollController _scrollController = ScrollController();

  Future getCows() async {
    while (true) {
      var result = await _serverApi.getCows();
      if (result.error) {
        if (result.errorCode == 401) {
          return;
        }
        Future.delayed(Duration(seconds: 1));
        continue;
      }
      setState(() {
        _cows = result.data!;
      });
      return;
    }
  }

  void updateCows() {
    _cowsFuture = getCows();
  }

  Widget bodyApp() {
    return DraggableScrollbar.arrows(
      alwaysVisibleScrollThumb: false,
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      controller: _scrollController,
      child: getListView(_cows),
    );
  }

  @override
  void initState() {
    _serverApi = ServerApi.getInstance();
    _user = _serverApi.user;
    updateCows();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rebanho'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () async {
              var result = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  allCows: _cows,
                  buildResultsWidget: getListView,
                ),
              );
              print(result);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
              context, "/editCow", arguments: Cow(farmId: _user?.farm.id ?? 0));
          setState(() => updateCows());
        },
        tooltip: 'Novo',
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _cowsFuture,
        builder: (BuildContext c, AsyncSnapshot s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (s.hasData) {
            return Text(s.data);
          }
          return bodyApp();
        },
      ),
    );
  }

  ListView getListView(List<Cow> cows) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: cows.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: CowInfoCard(cow: cows[index]),
          onTap: () async {
            await Navigator.pushNamedAndRemoveUntil(
                context, "/editCow",
                ModalRoute.withName('/cows'),
                arguments: cows[index]
            );
            setState(() => updateCows());
          },
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  late List<String> suggestion;

  final List<Cow> allCows;
  List<Cow> searchResult = <Cow>[];
  final Widget Function(List<Cow> element) buildResultsWidget;

  CustomSearchDelegate({
    required this.buildResultsWidget,
    required this.allCows,
  }){
    var stringList = Preferences.getInstance().getStringList('Cows.History');
    suggestion = stringList?? <String>[];
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(suggestion.length > 10){
      suggestion.removeAt(0);
    }
    suggestion.add(query);
    Preferences.getInstance().setStringList("Cows.History", suggestion);
    return buildResultsWidget(searchResult);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      searchResult =  allCows.where((cow) => suggestion.any((suggestion) => cow.identification.startsWith(suggestion) || cow.identification.startsWith(suggestion))).toList();
    }

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if (query.isEmpty) {
            query = suggestion[index];
          }
          showResults(context);
        },
        leading: Icon(query.isEmpty ? Icons.history : Icons.search),
        title: RichText(
            text: TextSpan(
                text: searchResult[index].identification,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
        ),
      ),
      itemCount: searchResult.length,
    );
  }
}