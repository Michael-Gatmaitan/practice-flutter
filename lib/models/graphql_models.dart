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
}

class Sale {
  final int saleID;
  final String itemNumber;
  final int customerID;
  final String customerName;
  final String itemName;
  final String saleDate;
  final double discount;
  final int quantity;
  final double unitPrice;

  Sale({
    required this.saleID,
    required this.itemNumber,
    required this.customerID,
    required this.customerName,
    required this.itemName,
    required this.saleDate,
    required this.discount,
    required this.quantity,
    required this.unitPrice,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      saleID: json["saleID"] as int,
      itemNumber: json["itemNumber"] as String,
      customerID: json["customerID"] as int,
      customerName: json["customerName"] as String,
      itemName: json["itemName"] as String,
      saleDate: json["saleDate"] as String,
      discount: json["discount"] as double,
      quantity: json["quantity"] as int,
      unitPrice: json["unitPrice"] as double,
    );
  }
}

class User {
  final int userID;
  final String fullName;
  final String username;
  final String password;
  final String status;

  User({
    required this.userID,
    required this.fullName,
    required this.username,
    required this.password,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json["userID"] as int,
      fullName: json["fullName"] as String,
      username: json["username"] as String,
      password: json["password"] as String,
      status: json["status"] as String,
    );
  }
}

class Vendor {
  final int vendorID;
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

  Vendor({
    required this.vendorID,
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

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorID: json['vendorID'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as int,
      phone2: json['phone2'] as int,
      address: json['address'] as String,
      address2: json['address2'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      status: json['status'] as String,
      createdOn: json['createdOn'] as String,
    );
  }
}
