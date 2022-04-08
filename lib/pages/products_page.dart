import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/product_item.dart';


final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [0.1, 0.3, 0.5, 0.7, 0.9],
    colors: [
      Colors.deepOrange[300]!,
      Colors.deepOrange[400]!,
      Colors.deepOrange[500]!,
      Colors.deepOrange[600]!,
      Colors.deepOrange[700]!,
    ]
  ),
);

class ProductsPage extends StatefulWidget {
  final void Function() onInit;

  ProductsPage({required this.onInit});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  void initState() {
    super.initState();

    widget.onInit();
  }

  _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');
  }

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return AppBar(
            centerTitle: true,
            title: SizedBox(
              child: state.user != null ? Text(state.user.username) : Text(''),
            ),
            leading: Icon(Icons.store),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: state.user != null
                      ? IconButton(
                          onPressed: () {
                            print('pressed');
                          },
                          icon: Icon(Icons.exit_to_app))
                      : Text(''))
            ],
          );
        },
      ));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar, body:
          Container(
              decoration: gradientBackground,
              child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(
                    children: [
                      Expanded(
                          child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                              itemCount: state.products.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2
                              ),
                              itemBuilder: (context, i) => ProductItem(item: state.products[i]),
                            )
                          )
                      )
                    ],
                  );
                },
              )
          ));
  }
}
