// import 'dart:math';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'package:newflutter/components/_forms.dart';
import 'package:newflutter/models/graphql_models.dart';

class ItemInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        // backgroundColor: Colors.black,
        title: Text(
          textAlign: TextAlign.center,
          "Item-IN",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat",
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 55, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CreateItemForm()],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 12),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         flex: 1,
      //         child: ElevatedButton(
      //           onPressed: () {},
      //           style: btnStyle("sec"),
      //           child: Text("Show items"),
      //         ),
      //       ),
      //       SizedBox(width: 12),
      //       Expanded(
      //         flex: 1,
      //         child: ElevatedButton(
      //           onPressed: () {
      //             _showModalBottomSheet(context);
      //           },
      //           style: btnStyle("pri"),
      //           child: Text("Proceed"),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.purple,
      //   child: Icon(Icons.chevron_right, color: Colors.white),
      // ),
    );
  }
}

class CreateItemForm extends StatefulWidget {
  const CreateItemForm({super.key});

  @override
  State<CreateItemForm> createState() => _CreateItemFormState();
}

class _CreateItemFormState extends State<CreateItemForm> {
  List<Map<String, dynamic>> itemsMap = [];

  void addItemToMap(Map<String, dynamic> item) {
    setState(() {
      itemsMap.add(item);
    });
  }

  void deleteItemToMap(int index) {
    setState(() {
      itemsMap.removeAt(index);
    });
  }

  void resetForm() {
    _formKey.currentState?.reset();
    itemNumberController.clear();
    itemNameController.clear();
    discountController.clear();
    stockController.clear();
    unitPriceController.clear();
    imageURLController.clear();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final itemNumberController = TextEditingController();
  final itemNameController = TextEditingController();
  final discountController = TextEditingController();
  final stockController = TextEditingController();
  final unitPriceController = TextEditingController();
  final imageURLController = TextEditingController();
  final descriptionController = TextEditingController();

  // itemNumber: Int!
  // itemName: String!
  // discount: Float!
  // stock: Int!
  // unitPrice: Int!
  // imageURL: String!

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Make the content scrollable
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemsMap.isEmpty
                      ? 'No items in queue'
                      : 'Large Modal Content',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap:
                      true, // Important for embedding in a Column/ScrollView
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling of the ListView
                  itemCount: itemsMap.length, // Example number of items
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        color: Colors.black,
                        width: 50,
                        height: 50,
                        child: Image.network(
                          itemsMap[index]["imageURL"],
                          fit: BoxFit.cover,
                        ),
                        // child: Image.asset(
                        //   "assets/tina.jpg",
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      title: Text("${itemsMap[index]["itemName"]}"),
                      // Add more item details here
                    );
                  },
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    style: btnStyle("pri"),
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisSize: MainAxisSize.min, // Adjust column size to its children
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          // Container(color: Colors.red, height: 100),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildTextField(
                  isNumber: true,
                  controller: itemNumberController,
                  label: "Item number",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: buildTextField(
                  controller: itemNameController,
                  label: "Item name",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildTextField(
                  isNumber: true,
                  controller: discountController,
                  label: "Discount",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: buildTextField(
                  isNumber: true,
                  controller: stockController,
                  label: "Stock",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: buildTextField(
                  isNumber: true,
                  controller: unitPriceController,
                  label: "Unit price",
                ),
              ),
            ],
          ),
          buildTextField(
            controller: imageURLController,
            label: "Item image URL",
          ),

          buildTextField(
            controller: descriptionController,
            label: "Item description",
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (int.tryParse(itemNumberController.text) == null ||
                      double.tryParse(discountController.text) == null ||
                      int.tryParse(stockController.text) == null ||
                      int.tryParse(unitPriceController.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Can't convert type of String into int or double",
                        ),
                      ),
                    );

                    return;
                  }

                  Map<String, dynamic> newItem = {
                    "itemNumber": int.parse(itemNumberController.text),
                    "itemName": itemNameController.text,
                    "discount": double.parse(discountController.text),
                    "stock": int.parse(stockController.text),
                    "unitPrice": int.parse(unitPriceController.text),
                    "imageURL": imageURLController.text,
                    "description": descriptionController.text,
                  };

                  print(newItem);
                  addItemToMap(newItem);

                  resetForm();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item added in queue.")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill the fields!")),
                  );
                }
              },
              style: btnStyle("pri"),
              child: Text("${itemsMap.length} Add"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              style: btnStyle("pri"),
              child: Text("Show queue"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  itemsMap.isEmpty
                      ? null
                      : () {
                        // _showModalBottomSheet(context);
                        Navigator.pushNamed(
                          context,
                          "/generateqr",
                          arguments: {"data": itemsMap, "type": "in"},
                        );
                      },
              style: btnStyle("pri"),
              child: Text("Proceed"),
            ),
          ),
        ],
      ),
    );
  }
}
