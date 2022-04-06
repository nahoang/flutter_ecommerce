import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final _scalffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  bool _isSubmitting = false;


  String? _email, _password;

  Widget _showTitle() {
    return Text('Login', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !(val?.contains('@') ?? false) ? 'Invalid email' : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter valid email',
            icon: Icon(Icons.mail, color: Colors.grey)),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        obscureText: _obscureText,
        onSaved: (val) => _password = val,
        validator: (val) => (val?.length ?? 0) < 6 ? 'Password too short' : null,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off)
            ),
            border: OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Enter password, min length 6',
            icon: Icon(Icons.lock, color: Colors.grey)),
      ),
    );
  }

  Widget _showFormActions() {
    return  Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            _isSubmitting == true ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ) : RaisedButton(
                onPressed: () {
                  // print('submit');
                  _submit();
                },
                child: Text('Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.black)),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0))),
                color: Theme.of(context).primaryColor),
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text('New user?, Register'))
          ],
        ));
  }


  void _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    var url = Uri.parse('http://localhost:1337/auth/local');
    http.Response response = await http.post(url, body: {
      "identifier": _email,
      "password": _password
    });

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {

      setState(() {
        _isSubmitting = false;
      });

      _storeUserData(responseData);

      _showSuccessSnack();

      _redirectUser();
      print(responseData);
    } else {
      setState(() {
        _isSubmitting = false;
      });
      final String errorMsg = responseData['message'];
      _showErrorSnack(errorMsg);
    }

  }


  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
      content: Text(errorMsg, style: TextStyle(
          color: Colors.red
      )),
    );

    _scalffoldKey.currentState?.showSnackBar(snackbar);
    throw Exception('Error login: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/products');
    });

  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text('User login successfully!', style: TextStyle(
          color: Colors.green
      )),
    );

    _scalffoldKey.currentState?.showSnackBar(snackbar);

    _formKey.currentState?.reset();
  }


  void _submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      _registerUser();
    }
  }


  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];

    user.putIfAbsent('jwt', () => responseData['jwt']);

    prefs.setString('user', json.encode(user));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scalffoldKey,
        appBar: AppBar(title: Text('Login')),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _showTitle(),
                        _showEmailInput(),
                        _showPasswordInput(),
                        _showFormActions(),
                      ],
                    ))),
          ),
        ));
  }
}
