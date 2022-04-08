
import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/redux/actions.dart';

import '../models/product.dart';
import '../models/user.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    products: productsReducer(state.products, action),
  );
}

User userReducer(user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  }
  return user;
}

productsReducer(products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}