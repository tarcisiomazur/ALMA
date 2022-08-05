import 'package:alma/models/cow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditCowPage extends StatefulWidget {
  const EditCowPage({Key? key, required this.cow}) : super(key: key);

  final Cow cow;

  @override
  State<EditCowPage> createState() => _EditCowPageState();
}

class _EditCowPageState extends State<EditCowPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _brincoController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cow.id == 0 ? 'Editar Informações do Animal' : 'Cadastrar Novo Animal'),
        actions: <Widget>[
          Container(
            width: 80,
            child: IconButton(
              icon: Text(
                'Salvar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                print("saved");
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Expanded(
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _brincoController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(45),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Brinco',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _ageController,
                                decoration: const InputDecoration(
                                  labelText: 'Peso',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Digite o peso';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Data de Nascimento'),
                              InputDatePickerFormField(
                                firstDate: DateTime(DateTime
                                    .now()
                                    .year - 120),
                                lastDate: DateTime.now(),
                                fieldLabelText: "Data de Nascimento",

                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!
                                          .validate()) {
                                        _formKey.currentState!.save();
                                        //SendTo api
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!
                                          .validate()) {
                                        _formKey.currentState!.save();
                                        //SendTo api
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Save',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            ),
          ),
        ),
      ),
    );
  }
}
