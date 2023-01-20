
## Features

Date input widget with dd/mm/yyyy hint

release items:
* -- DD/MM/YYYY hint maintaining based on the input
* -- minor (18 years old validation)
* -- error call backs and indications
* -- right calendar opening icon press handling

## Getting started

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart

import 'package:custom_date_widget/custom_date_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomDateField(
          errorCallback: (v) {
            print('errorCallback: $v');
          },
          currentValue: (c) {
            print('currentValue: $c');
          },
          onPressRightIcon: () {
            print('onPressRightIcon: ');
          },
          rightIconSvg: Icon(Icons.call_to_action), isMinor: 'false',),
      ),
    );
  }
}

```

## Additional information
 Widget in progress release
 connect me on:
 @mhdsafvankp@gmail.com
 