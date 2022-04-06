import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  void initState() {
    super.initState();

    _getUser();

  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');

    print(json.decode(storedUser!));
  }

  @override
  Widget build(BuildContext context) {
    return Text('Products Page');
  }
}
