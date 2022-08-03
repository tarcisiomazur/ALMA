import 'package:alma/models/cow.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/cow_info_card.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class CowsPage extends StatefulWidget {
  const CowsPage({Key? key}) : super(key: key);

  @override
  State<CowsPage> createState() => _CowsPageState();
}

class _CowsPageState extends State<CowsPage> {
  late ServerApi serverApi;
  late Future _cowsFuture;
  late List<Cow> cows;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    serverApi = ServerApi.getInstance();
    _cowsFuture = getCows();
    super.initState();
  }

  Future getCows() async {
    while (true) {
      var result = await serverApi.getCows();
      if (result.error) {
        if (result.errorCode == 401) {
          return;
        }
        Future.delayed(Duration(seconds: 1));
        continue;
      }
      setState(() {
        cows = result.data!;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }

  Widget bodyApp() {
    return DraggableScrollbar.arrows(
      alwaysVisibleScrollThumb: false,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        controller: scrollController,
        child: ListView.builder(
            controller: scrollController,
            itemCount: cows.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child:CowInfoCard(cow: cows[index]),
                onTap: () => Navigator.pushNamed(context, "/editCow", arguments: cows[index]),
              );
            })
    );
  }
}
