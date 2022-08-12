import 'package:alma/models/cow.dart';
import 'package:alma/utils/format.dart';
import 'package:flutter/material.dart';

class CowInfoCard extends StatelessWidget {
  const CowInfoCard({required this.cow, Key? key}) : super(key: key);
  final Cow cow;

  @override
  Widget build(BuildContext context) {
    String idade = Format.DateTimeToAge(cow.birthDate);
    final cardTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    final bcsColor = cow.bcs == 1 || cow.bcs == 5 ? Color(0xFFDD0000):
        cow.bcs == 2 || cow.bcs == 4 ? Color(0xFFC5AF19)
        : Theme.of(context).primaryColor;

    final medicationCardContent = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 5.0),
                    Text("Brinco",
                      style: cardTextStyle,
                    ),
                    Container(height: 5.0),
                    Text(cow.tag.toString()),
                    Container(height: 5.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 5.0),
                    Text("Identificação",
                      style: cardTextStyle,
                    ),
                    Container(height: 5.0),
                    Text(cow.identification.toString()),
                    Container(height: 5.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Escore', style: cardTextStyle),
                    Container(height: 5.0),
                    Text(cow.bcs.toString(),
                      style: cardTextStyle.copyWith(
                          color: bcsColor
                      )
                    ),
                    Container(height: 5.0),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 5.0),
                    Text("Produção Média",
                      style: cardTextStyle,
                    ),
                    Container(height: 5.0),
                    Text(cow.meanProduction.toString()),
                    Container(height: 5.0),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Estado', style: cardTextStyle),
                    Container(height: 5.0),

                    Text(cow.state.name,
                      style: cow.state == CowState.Death
                          ? cardTextStyle.copyWith(
                          color: Color(0xFFDD0000)
                      ) : null,
                    ),
                    Container(height: 5.0),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 5.0),
                    Text("Idade",
                      style: cardTextStyle,
                    ),
                    Container(height: 5.0),
                    Text(idade),
                    Container(height: 5.0),
                  ],
                ),
              ],
            ),
          ],
        ),
    );

    final medicationCard = Container(
      child: Column(
          children: [
            medicationCardContent,
          ],
        ),
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
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          medicationCard,
        ],
      ),
    );
  }
}
