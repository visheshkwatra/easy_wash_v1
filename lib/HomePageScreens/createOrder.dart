import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_wash_v1/HomePageScreens/HomePageMap.dart';
import 'package:easy_wash_v1/HomePageScreens/appointment_creation.dart';
Future<void> createOrder({
  required int productId,
  required DateTime selectedDate,
  required String location,
  required String time,
}) async {
  try {
    final url = Uri.parse('https://evxservices.com/22D92D50C1FFE2697C24336CDCDapi/order/');

    final requestBody = jsonEncode({
      "customer": 1,
      "product": productId,
      "date": selectedDate.toIso8601String(),
      "name": "Vishesh",
      "phone": "7011397281",
      "address": location.toString(),
      "city": "New Delhi",
      "state": "Delhi",
      "zip": "0",
      "orderdate": DateTime.now().toIso8601String(),
    });

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // Order successfully created
      print(requestBody);
      print('Order created successfully');
    } else {
      // Failed to create the order, handle the error
      // Failed to create the order, handle the error
      print('Request Body: ${requestBody}');
      print('Failed to create order. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error creating order: $e');
  }
}
