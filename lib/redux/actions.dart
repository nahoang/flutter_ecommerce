
import 'dart:convert';

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

/* User action */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String? storedUser = prefs.getString('user');

  final user = storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user!));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}

ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  var url = Uri.parse('http://localhost:1337/products');

  http.Response response = await http.get(url);
  final responseData =  json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((productData) {
    print(productData);
    final Product product = Product.fromJson(productData);
    products.add(product);
  });

  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {

  final List<Product> _products;

  List<Product> get products => this._products;

  GetProductsAction(this._products);
}