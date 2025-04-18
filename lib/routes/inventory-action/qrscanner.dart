import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:newflutter/graphql/graphql_config.dart';
import '../../graphql/graphql_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isScanning = true;
  final MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    cameraController.start();
  }

  @override
  void dispose() async {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                isScanning = !isScanning;
              });
              if (isScanning) {
                cameraController.start();
              } else {
                cameraController.stop();
              }
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (!isScanning) return;
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            print("Barcode found! ${barcode.rawValue}");

            try {
              final Map<String, dynamic> decodedData = jsonDecode(
                barcode.rawValue!,
              );

              if (decodedData.containsKey("data") &&
                  decodedData.containsKey("revent") &&
                  decodedData.containsKey("type")) {
                // _showDialog(
                //   "QR Code Data",
                //   "Valid JSON with 'data' field found!",
                // );

                setState(() {
                  isScanning = false;
                });
                cameraController.stop();

                final client = getGraphQLClient(null);
                final data = decodedData["data"];

                void processQR(Map<String, dynamic> qrdata) async {
                  final result = await client.mutate(
                    MutationOptions(
                      document: gql(GraphQLService.createItemMutation),
                      variables: {
                        "itemNumber": qrdata["itemNumber"],
                        "itemName": qrdata["itemName"],
                        "discount": qrdata["discount"],
                        "stock": qrdata["stock"],
                        "unitPrice": qrdata["unitPrice"],
                        "imageURL": qrdata["imageURL"],
                        "description": qrdata["description"],
                      },
                    ),
                  );
                }

                for (int i = 0; i < data.length; i++) {
                  Map<String, dynamic> val = data[i];
                  processQR(val);
                }

                _showDialog(
                  "New items created",
                  "${data.length} items successfully created.",
                );
                return;
              } else {
                // print("The qr code is not valid");
                _showDialog(
                  "Invalid QR Code",
                  "QR code does not contain any useful information.",
                );

                setState(() {
                  isScanning = false;
                });
                cameraController.stop();
                return;
              }
            } catch (err) {
              _showDialog(
                "Error has occured",
                "This may happen depends on qrcode's data.",
              );
              // print("AAAAAAAAEEEEEEEEEEEEEEERRRRROROROOROROROROR $err");
              setState(() {
                isScanning = false;
              });
              cameraController.stop();
              return;
            }
          }
        },
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (!isScanning) {
                  setState(() {
                    isScanning = true;
                  });
                  cameraController
                      .start(); // Restart scanning after closing dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}
