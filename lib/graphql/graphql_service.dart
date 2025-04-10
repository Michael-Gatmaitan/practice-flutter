import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  // static final HttpLink httpLink = HttpLink("http://localhost:4000/graphql");
  static final HttpLink httpLink = HttpLink(
    // "http://192.168.100.9:4000/graphql",
    // "http://192.168.1.82:4000/graphql",
    "http://192.168.100.9:4000/graphql",
  );
  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(link: httpLink, cache: GraphQLCache()),
  );

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
}
