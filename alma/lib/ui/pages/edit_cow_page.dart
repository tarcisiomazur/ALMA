import 'package:alma/models/cow.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/pages/cows_page.dart';
import 'package:alma/utils/global_functions.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditCowPage extends StatefulWidget {
  const EditCowPage({Key? key, required this.cow}) : super(key: key);

  static const String route = "/editCow";

  final Cow cow;

  @override
  State<EditCowPage> createState() => _EditCowPageState();
}

class _EditCowPageState extends State<EditCowPage> {
  static final format = DateFormat("dd/MM/yyyy");
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  final _identificationController = TextEditingController();
  final _noteController = TextEditingController();
  final _bcsController = TextEditingController();
  late String state;
  late CowState _state;
  late DateTime? _birthDate;
  late DateTime? _lastInsemination;
  late DateTime? _lastCalving;
  late bool _isNew;

  @override
  void initState() {
    Cow cow = widget.cow;
    _isNew = cow.id == 0;
    state = cow.state.name;
    _state = cow.state;
    _birthDate = cow.birthDate;
    _lastInsemination = cow.lastInsemination;
    _lastCalving = cow.lastCalving;
    _noteController.text = cow.note;
    _tagController.text = cow.tag;
    _bcsController.text = cow.bcs.toString();
    _identificationController.text = cow.identification;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var edges = const EdgeInsets.fromLTRB(5, 0, 0, 10);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew
            ? 'Cadastrar Novo Animal'
            : 'Editar Informações'),
        actions: <Widget>[
          Container(
            width: 80,
            child: IconButton(
              icon: Text(
                'Salvar',
                style: theme.textTheme.headline6!.copyWith(
                    color: theme.colorScheme.surface),
              ),
              onPressed: Save,
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: edges,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _tagController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(45),
                              ],
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
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
                        margin: edges,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _identificationController,
                              decoration: const InputDecoration(
                                labelText: 'Identificação',
                              ),
                              keyboardType: TextInputType.text,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      BuildDate(_birthDate, (value) => _birthDate = value,
                          'Data de Nascimento'),
                      Container(
                        margin: edges,
                        child: Column(children: <Widget>[
                          DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: "Estado"
                              ),
                              items: <CowState>[...CowState.values].map((
                                  CowState value) {
                                return DropdownMenuItem<CowState>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                              value: _state,
                              onChanged: (value) {
                                if (value != null) {
                                  _state = value as CowState;
                                }
                              }
                          )
                        ],
                        ),
                      ),
                      Container(
                        margin: edges,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _bcsController,
                              decoration: const InputDecoration(
                                labelText: 'Escore',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: const TextInputType
                                  .numberWithOptions(
                                  decimal: false, signed: false),
                              validator: (string) {
                                var value = int.tryParse(string ?? "");
                                return (value == null || value < 1 || value > 5)
                                    ? 'O valor deve estar entre 1 e 5'
                                    : null;
                              },
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                            ),
                          ],
                        ),
                      ),
                      BuildDate(_lastCalving, (value) => _lastCalving = value,
                          'Data do Último Parto'),
                      BuildDate(_lastInsemination, (value) =>
                      _lastInsemination = value, 'Data da Última Inseminação'),
                      Container(
                        margin: edges,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _noteController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelText: 'Anotações',
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(
                                      10.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: edges,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: Save,
                                child: const Text('Salvar',
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                            ),
                            if(!_isNew) ...[
                              const SizedBox(width: 50),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: Excluir,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                  ),
                                  child: const Text('Excluir',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<CowState>> getEstados() {
    return CowState.values.map((CowState state){
      return DropdownMenuItem<CowState> (
        value: state,
        child: Text(state.name),
      );
    }).toList();
  }

  Widget BuildDate(DateTime? value, Function(DateTime? value) onChanged, String label) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1970),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime.now(),
            errorInvalidText: 'Data Inválida',
          );
        },
        initialValue: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  void Save() async {
    var formState = _formKey.currentState;
    if (formState != null && _formKey.currentState!.validate()) {
      widget.cow.tag = _tagController.text;
      widget.cow.identification = _identificationController.text;
      widget.cow.birthDate = _birthDate;
      widget.cow.state = _state;
      widget.cow.bcs = int.parse(_bcsController.text);
      widget.cow.lastCalving = _lastCalving;
      widget.cow.lastInsemination = _lastInsemination;
      widget.cow.note = _noteController.text;
      showDbDialog();

      var result = _isNew
          ? await ServerApi.getInstance().newCow(widget.cow)
          : await ServerApi.getInstance().updateCow(widget.cow);
      if (!mounted) return;
      Navigator.popUntil(context, ModalRoute.withName(
        result.data == true
            ? CowsPage.route
            : EditCowPage.route,
      ));
      if(result.error) {
        showErrorDialog(context,"Erro ao Salvar\nResposta do servidor: "
            "${result.errorCode}: ${result.errorMessage}");
      }
    }
  }

  void Excluir() async {
    showDbDialog();
    var result = await ServerApi.getInstance().deleteCow(widget.cow.id);
    if (!mounted) return;
    Navigator.popUntil(context, ModalRoute.withName(
      result.data == true
          ? CowsPage.route
          : EditCowPage.route,
    ));
    if(result.error) {
      showErrorDialog(context, "Erro ao Excluir\nResposta do servidor: "
          "${result.errorCode}: ${result.errorMessage}");
    }

  }

  void showDbDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: const Center(
              child: const CircularProgressIndicator(),
            )
        );
      },
    );
  }
}