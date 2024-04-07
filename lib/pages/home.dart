import 'package:flutter/material.dart';

import '../util/customizedUtil.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Image.network(
            'asset/logo2.jpg',
            // You need to replace 'URL_OF_YOUR_CIA_IMAGE' with the actual url of the image.
            fit: BoxFit.cover,
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Define what happens when the button is pressed
              },
              child: CustomizedText('Date'),
            ),
            ElevatedButton(
              onPressed: () {
                // Define what happens when the button is pressed
              },
              child: CustomizedText('Statistic'),
            ),
            ElevatedButton(
              onPressed: () {
                // Define what happens when the button is pressed
              },
              child: CustomizedText('Factor'),
            ),
            ElevatedButton(
              onPressed: () {
                // Define what happens when the button is pressed
              },
              child: CustomizedText('Location'),
            ),
          ],
        ),
      ],
    );
  }
}
