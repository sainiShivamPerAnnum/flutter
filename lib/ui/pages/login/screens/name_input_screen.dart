import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameInputScreen extends StatefulWidget {
  static const int index = 2;

  NameInputScreen({Key key}) : super(key: key); //pager index

  @override
  State<StatefulWidget> createState() => NameInputScreenState();
}

class NameInputScreenState extends State<NameInputScreen> {
  Log log = new Log("NameInputScreen");
  String _name;
  String _email;
  bool _isInitialized = false;
  bool _validate = true;
  TextEditingController _nameFieldController;
  TextEditingController _emailFieldController;
  static BaseUtil authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      authProvider = Provider.of<BaseUtil>(context);
      _nameFieldController =
          (authProvider.myUser != null && authProvider.myUser.name != null)
              ? new TextEditingController(text: authProvider.myUser.name)
              : new TextEditingController();
      _emailFieldController =
          (authProvider.myUser != null && authProvider.myUser.email != null)
              ? new TextEditingController(text: authProvider.myUser.email)
              : new TextEditingController();
    }
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child: TextFormField(
                controller: _nameFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Please enter your name';
                },
                onFieldSubmitted: (v) {
                  FocusScope.of(context).nextFocus();
                },
//                        onChanged: (value) {
//                          //this._name = value;
//                          if (!_validate) setState(() {
//                            _validate = true;
//                          });
//                        },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
              child: TextFormField(
                controller: _emailFieldController,
                decoration: InputDecoration(
                  //hintText: 'Email(optional)',
                  //errorText: _validate ? null : "Invalid!",
                  labelText: 'Email (optional)',
                  prefixIcon: Icon(Icons.email),
                ),
//                        onChanged: (value) {
                //this._email = value;
//                    if(!_validate) setState(() {
//                      _validate = true;
//                    });
//                        },
              ),
            ),
          ],
        )
        //    )
        //)
        );
  }

  setError() {
    setState(() {
      _validate = false;
    });
  }

  String get email => _emailFieldController.text;

  set email(String value) {
    _emailFieldController.text = value;
    //_email = value;
  }

  String get name => _nameFieldController.text;

  set name(String value) {
    //_name = value;
    _nameFieldController.text = value;
  }

  get formKey => _formKey;
}
