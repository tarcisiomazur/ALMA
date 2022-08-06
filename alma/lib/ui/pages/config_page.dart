import 'package:alma/models/cow.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/services/web_socket.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  static const String route = '/config';

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late ServerApi _serverApi;
  late Future _cowsFuture;
  late List<Cow> _cows;
  final sink = ApiWebSocket.getInstance().sink;

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
        sink.add("CONFIG PAGE 36${_cows.length}");
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
      child: getListView(),
    );
  }

  @override
  void initState() {
    _serverApi = ServerApi.getInstance();
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
              Icons.filter_list,
            ),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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

  ListView getListView() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return Text(index.toString());
      },
    );
  }
}
