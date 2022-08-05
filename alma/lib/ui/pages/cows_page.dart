import 'package:alma/models/cow.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/cow_info_card.dart';
import 'package:alma/ui/my_drawer.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class CowsPage  extends StatefulWidget {
  CowsPage({Key? key}) : super(key: key);

  @override
  String pageName = "Rebanho";

  @override
  State<CowsPage> createState() => _CowsPageState();
}

class _CowsPageState extends State<CowsPage> {
  late ServerApi _serverApi;
  late Future _cowsFuture;
  late List<Cow> _cows;
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
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _cows.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: CowInfoCard(cow: _cows[index]),
            onTap: () async {
              await Navigator.pushNamed(
                  context, "/editCow", arguments: _cows[index]);
              setState(() => updateCows());
            },
          );
        },
      ),
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
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
              context, "/editCow", arguments: Cow());
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

}
