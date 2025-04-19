import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRScreen extends StatelessWidget {
  const GenerateQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map;
    final Map<String, dynamic> itemsData = {
      "data": args["data"],
      "revent": true,
      "type": args["type"],
    };
    // itemsData[itemsData.length] = {"revent": true};

    // bool isLightMode = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(title: Text("Generating qr code ${args["type"]}")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            QrImageView(
              embeddedImage: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/icons/app_icon.png"
                    : "assets/icons/app_icon_dark.png",
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              data: json.encode(itemsData),
            ),
          ],
        ),
      ),
    );
  }
}
