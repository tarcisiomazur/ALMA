import 'package:alma/models/cow.dart';
import 'package:flutter/material.dart';

class EditCowPage extends StatefulWidget {
  const EditCowPage({Key? key, required this.cow}) : super(key: key);

  final Cow cow;

  @override
  State<EditCowPage> createState() => _EditCowPageState();
}

class _EditCowPageState extends State<EditCowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar informações do animal'),
      ),
      body: Text("Editando vaca..${widget.cow.tag}"),
    );
  }
}
