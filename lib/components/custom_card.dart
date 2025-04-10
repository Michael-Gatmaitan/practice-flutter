import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String headerText;
  final String hightlightText;
  final Widget bottomRightWidget;

  const CustomCard({
    super.key,
    required this.headerText,
    required this.hightlightText,
    required this.bottomRightWidget,
  });

  @override
  Widget build(BuildContext build) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // color: Colors.purple[50],
      ),
      padding: EdgeInsets.only(top: 12, right: 12, bottom: 24, left: 24),
      // width: MediaQuery.of(build).size.width,
      child: Column(
        spacing: 50,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headerText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Montserrat",
                  letterSpacing: -1,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(build, "/items");
                  // Navigator.push(
                  //   build,
                  //   MaterialPageRoute<void>(
                  //     builder: (BuildContext context) {
                  //       return Scaffold(
                  //         appBar: AppBar(title: Text("Sample route")),
                  //         body: Center(
                  //           child: Text(
                  //             "TRhis is a centered texct in another page",
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(70, 70),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Icon(Icons.arrow_outward, size: 24, color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hightlightText,
                style: TextStyle(
                  fontSize: 65,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Montserrat",
                ),
              ),
              bottomRightWidget,
            ],
          ),
        ],
      ),
    );
  }
}
