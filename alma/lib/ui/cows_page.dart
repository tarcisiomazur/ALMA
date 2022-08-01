import 'package:alma/models/cow.dart';
import 'package:alma/services/server_api.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vacas'),
      ),
        body: FutureBuilder(
            future: _cowsFuture,
            builder: (BuildContext c, AsyncSnapshot s) {
              if (s.connectionState == ConnectionState.waiting) {
                return Center(child: SizedBox(
                    height: 50,
                    width: 50,
                    child:CircularProgressIndicator()));
              }
              if (s.hasData) {
                return Text(s.data);
              }
              return bodyApp();
            }
        )
    );
  }

  Widget bodyApp() {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(10),

          );
        });
  }

}
