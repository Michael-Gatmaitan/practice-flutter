class GraphQLHelper {
  static List<T> fromGraphQLResult<T>(
    Map<String, dynamic>? result,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return (result?[key] as List<dynamic>?)
            ?.map((json) => fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];
  }
}

class Item {
  final int productID;
  final int itemNumber;
  final String itemName;
  final double discount;
  final int stock;
  final int unitPrice;
  final String imageURL;

  Item({
    required this.productID,
    required this.itemNumber,
    required this.itemName,
    required this.discount,
    required this.stock,
    required this.unitPrice,
    required this.imageURL,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productID: json["productID"] as int,
      itemNumber: json["itemNumber"] as int,
      itemName: json["itemName"] as String,
      discount: (json["discount"] as num).toDouble(),
      stock: json["stock"] as int,
      unitPrice: json["unitPrice"] as int,
      imageURL: json["imageURL"] as String,
    );
  }
}

class Customer {
  final int customerID;
  final String fullName;
  final String email;
  final int mobile;
  final int phone2;
  final String address;
  final String address2;
  final String city;
  final String district;
  final String status;
  final String createdOn;

  Customer({
    required this.customerID,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.phone2,
    required this.address,
    required this.address2,
    required this.city,
    required this.district,
    required this.status,
    required this.createdOn,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json["customerID"] as int,
      fullName: json["fullName"] as String,
      email: json["email"] as String,
      mobile: json["mobile"] as int,
      phone2: json["phone2"] as int,
      address: json["address"] as String,
      address2: json["address2"] as String,
      city: json["city"] as String,
      district: json["district"] as String,
      status: json["status"] as String,
      createdOn: json["createdOn"] as String,
    );
  }
}

class Purchase {
  final int purchaseID;
  final int itemNumber;
  final String purchaseDate;
  final String itemName;
  final int unitPrice;
  final int quantity;
  final String vendorName;
  final int vendorID;

  Purchase({
    required this.purchaseID,
    required this.itemNumber,
    required this.purchaseDate,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
    required this.vendorName,
    required this.vendorID,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      purchaseID: json["purchaseID"] as int,
      itemNumber: json["itemNumber"] as int,
      purchaseDate: json["purchaseDate"] as String,
      itemName: json["itemName"] as String,
      unitPrice: json["unitPrice"] as int,
      quantity: json["quantity"] as int,
      vendorName: json["vendorName"] as String,
      vendorID: json["vendorID"] as int,
    );
  }

  List<Object> ensureTypes(dynamic result, String key) {
    return (result.data?[key] as List<dynamic>?)
            ?.map((json) => Purchase.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];
  }
}
