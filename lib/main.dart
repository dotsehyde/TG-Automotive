import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TG Automotive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final oilLubData = [
    DataModel(title: "Oil Change", price: 36.00, isChecked: false),
    DataModel(title: "Lube Job", price: 28.00, isChecked: false),
  ];
  final radTransData = [
    DataModel(title: "Radiator Flush", price: 50.00, isChecked: false),
    DataModel(title: "Transmission Flush", price: 120.00, isChecked: false),
  ];
  final miscData = [
    DataModel(title: "Inspection", price: 15.00, isChecked: false),
    DataModel(title: "Replace Muffler", price: 200.00, isChecked: false),
    DataModel(title: "Tire Rotation", price: 20.00, isChecked: false),
  ];
  final _partController = TextEditingController();
  final _laborController = TextEditingController();
  double total = 0;
  double serviceTotal = 0;
  double tax = 2.70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TG Automotive'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const SizedBox(height: 20),
            //Oil and Lubrication
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Colors.blue,
                child: const Text(
                  "Oil and Lubrication",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                )),
            ...oilLubData.map((e) => checkBox(
                value: e.isChecked,
                price: e.price.toStringAsFixed(2),
                title: e.title,
                onChanged: (val) {
                  setState(() {
                    e.isChecked = val!;
                  });
                })),
            //Radiators and Transmission
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Colors.blue,
                child: const Text(
                  "Radiator and Transmission",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                )),
            ...radTransData.map((e) => checkBox(
                value: e.isChecked,
                price: e.price.toStringAsFixed(2),
                title: e.title,
                onChanged: (val) {
                  setState(() {
                    e.isChecked = val!;
                  });
                })),
            //Miscellaneous
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Colors.blue,
                child: const Text(
                  "Miscellaneous",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                )),
            ...miscData.map((e) => checkBox(
                value: e.isChecked,
                price: e.price.toStringAsFixed(2),
                title: e.title,
                onChanged: (val) {
                  setState(() {
                    e.isChecked = val!;
                  });
                })),
            //Parts and Labor
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Colors.blue,
                child: const Text(
                  "Parts and Labor",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text("Parts:", style: TextStyle(fontSize: 18)),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      controller: _partController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Parts price',
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text("Dollars", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Labor:", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      controller: _laborController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Labor time',
                      ),
                    ),
                  ),
                  const Text("minutes", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            //Action Buttons
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 10)),
                onPressed: () {
                  //Calculation summary
                  if (!validateInputs()) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text("Error"),
                            content: const Text(
                                "Please enter a valid number for parts and labor"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              )
                            ],
                          );
                        });
                    return;
                  }
                  serviceTotal = calcFlushCharges() +
                      calcMiscCharges() +
                      calcOilLubeCharges() +
                      double.parse(_laborController.text);
                  total = calcFlushCharges() +
                      calcMiscCharges() +
                      calcOilLubeCharges() +
                      double.parse(_partController.text) +
                      double.parse(_laborController.text) +
                      tax;
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text("Summary of Charges"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const Text("Service and Labor:",
                                          style: TextStyle(fontSize: 18)),
                                      const Spacer(),
                                      Text(
                                          "\$${serviceTotal.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text("Tax(on parts):",
                                        style: TextStyle(fontSize: 18)),
                                    const Spacer(),
                                    Text("\$${tax.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const Text("Parts:",
                                          style: TextStyle(fontSize: 18)),
                                      const Spacer(),
                                      Text("\$${_partController.text}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text("Total Fees:",
                                        style: TextStyle(fontSize: 18)),
                                    const Spacer(),
                                    Text("\$${total.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              )
                            ],
                          ));
                },
                child: const Text(
                  "Calculate",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 10)),
                onPressed: () {
                  _partController.clear();
                  _laborController.clear();
                  for (var e in oilLubData) {
                    e.isChecked = false;
                  }
                  for (var e in radTransData) {
                    e.isChecked = false;
                  }
                  for (var e in miscData) {
                    e.isChecked = false;
                  }
                  setState(() {});
                },
                child: const Text(
                  "Clear",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 10)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text("Exit application"),
                          content: const Text(
                              "Are you sure you want to exit the application?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                exit(0);
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            )
                          ],
                        );
                      });
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Validation Function
  bool validateInputs() {
    if (_partController.text.isEmpty ||
        double.parse(_partController.text) <= 0) {
      return false;
    }
    if (_laborController.text.isEmpty ||
        double.parse(_partController.text) <= 0) {
      return false;
    }
    return true;
  }

//Oil and Lubrication Function
  double calcOilLubeCharges() {
    double total = 0;
    for (var element in oilLubData) {
      if (element.isChecked) {
        total += element.price;
      }
    }
    return total;
  }

  //Flushes Function
  double calcFlushCharges() {
    double total = 0;
    for (var element in radTransData) {
      if (element.isChecked) {
        total += element.price;
      }
    }
    return total;
  }

  //Miscellaneous Function
  double calcMiscCharges() {
    double total = 0;
    for (var element in miscData) {
      if (element.isChecked) {
        total += element.price;
      }
    }
    return total;
  }
}

//CheckBox Custom Widget
Widget checkBox({
  required bool value,
  required String title,
  price,
  required Function(bool?) onChanged,
}) {
  return CheckboxListTile(
    value: value,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        Text("\$ $price", style: const TextStyle(fontSize: 18)),
      ],
    ),
    controlAffinity: ListTileControlAffinity.leading,
    onChanged: onChanged,
  );
}

//Data Model
class DataModel {
  final String title;
  final double price;
  bool isChecked;

  DataModel(
      {required this.title, required this.price, required this.isChecked});
}
