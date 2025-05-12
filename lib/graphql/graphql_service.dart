import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  // Local?
  // static final baseUrl = "http://172.16.1.247";
  // Lab?
  // static final String baseUrl = "http://192.168.0.111";
  // Home
  // static final String baseUrl = "http://192.168.1.23";
  // static final String baseUrl = "http://192.168.1.112";
  static final String baseUrl = "http://172.16.1.198";
  // Omel
  // static final String baseUrl = "http://192.168.68.66";
  static final HttpLink httpLink = HttpLink("$baseUrl:4000/graphql");
  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(link: httpLink, cache: GraphQLCache()),
  );

  // asd

  //// ITEM QUERY ////
  static const String getItemsQuery = """
    query {
      items {
        productID
        itemNumber
        itemName
        discount
        stock
        unitPrice
        imageURL
      }
    }
  """;

  static const String getItemByProductIDQuery = """
    query GetItem(\$productID: Int!) {
      item(productID: \$productID) {
        productID
        itemNumber
        itemName
        discount
        stock
        unitPrice
        imageURL
      }
    }
  """;

  //// PURCHASE QUERY ////
  static const String getPurchasesQuery = """
    query {
      purchases {
          purchaseID
          itemNumber
          purchaseDate
          itemName
          unitPrice
          quantity
          vendorName
          vendorID
        }
    }
  """;

  static const String getPurchaseByPurchaseIDQuery = """
    query GetPurchase(\$purchaseID: Int!) {
      purchase(purchaseID: \$purchaseID) {
        purchaseID
        itemNumber
        purchaseDate
        itemName
        unitPrice
        quantity
        vendorName
        vendorID
      }
    }
  """;

  //// CUSTOMER QUERY ////
  static const String getCustomersQuery = """
    query {
      customers {
          customerID
          fullName
          email
          mobile
          phone2
          address
          address2
          city
          district
          status
          createdOn
        }
    }
  """;

  static const String getCustomerByCustomerIDQuery = """
    query GetCustomer(\$purchaseID: Int!) {
      customer(customerID: \$customerID) {
        customerID
        fullName
        email
        mobile
        phone2
        address
        address2
        city
        district
        status
        createdOn
      }
    }
  """;

  static const String meQuery = r"""
    query {
        me {
          fullName
          username
        }
      }
  """;

  //// USER MUTATION ////
  static const String signupMutation = r"""
    mutation Signup($fullname: String!, $username: String!, $password: String!) {
      signup(fullname: $fullname, username: $username, password: $password) {
        token
        error
      }
    }
  """;

  static const String loginMutation = r"""
    mutation Login($username: String!, $password: String!) {
        login(username: $username, password: $password) {
          token
          error
        }
      }
  """;

  //// ITEM MUTATION ////
  static const String createItemMutation = r"""
    mutation CreateItem($itemNumber: Int!, $itemName: String!, $discount: Float!, $stock: Int!, $unitPrice: Int!, $imageURL: String!, $description: String!) {
      createItem(itemNumber: $itemNumber, itemName: $itemName, discount: $discount, stock: $stock, unitPrice: $unitPrice, imageURL: $imageURL, description: $description) {
        message
        success
      }
    }
  """;

  // mutation DeductItem($productID: Int!, $quantity: Int!, $customerID: Int!, $itemNumber: String!, $itemName: String!, $discount: Float!, $unitPrice: Int!) {
  //   deductItem(productID: $productID, quantity: $quantity, customerID: $customerID, itemNumber: $itemNumber, itemName: $itemName, discount: $discount, unitPrice: $unitPrice) {
  //     message,
  //     success
  //   }
  // }

  static const String deductItemMutation = r"""
    mutation DeductItem($productID: Int!, $quantity: Int!, $customerID: Int!) {
      deductItem(productID: $productID, quantity: $quantity, customerID: $customerID) {
        message,
        success
      }
    }
  """;
}
