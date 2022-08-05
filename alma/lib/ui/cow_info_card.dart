import 'package:alma/models/cow.dart';
import 'package:alma/utils/format.dart';
import 'package:flutter/material.dart';

class CowInfoCard extends StatelessWidget {
  const CowInfoCard({required this.cow, Key? key}) : super(key: key);
  final Cow cow;

  @override
  Widget build(BuildContext context) {
    String idade = Format.DurationToAge(DateTime.now().difference(cow.birthDate!));
    final medicationCardContent = Container(
      margin: EdgeInsets.all(16.0),
      constraints: BoxConstraints.expand(),
      child: Container(
        height: 3.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 5.0),
                    Text("Id"),
                    Container(height: 5.0),
                    Text(cow.id.toString()),
                    Container(height: 5.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Peso:',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(height: 5.0),
                    Text(cow.weight.toString(),
                        overflow: TextOverflow.ellipsis),
                    Container(height: 5.0),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Idade: '),
                Text(idade),
              ],
            ),
          ],
        ),
      ),
    );

    final medicationCard = Container(
      child: medicationCardContent,
      height: 140.0,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
    );

    return Container(
      height: 140.0,
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          medicationCard,
        ],
      ),
    );
  }
}
