  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';

  class AuthProvider with ChangeNotifier {

    bool _isLoggedIn = false;
    int? _userId; // User ID variable
    String? _userName; // User name
    String? _userPhone; // User phone number

    // Add getters for user name and phone number
    String? get userName => _userName;
    String? get userPhone => _userPhone;

    // Getter to access the login status
    bool get isLoggedIn => _isLoggedIn;

    // Getter to access the user ID
    int? get userId => _userId;
    void _storeUserData(Map<String, dynamic> userData) {
      _userId = userData['id'];
      _userName = userData['name'];
      _userPhone = userData['phone'];
    }

    // Simulate a login process
    Future<void> login(String email, String password) async {
      final apiUrl = 'https://evxservices.com/22D92D50C1FFE2697C24336CDCDapi/login/';

      final requestBody = jsonEncode({
        "email": email,
        "password": password,
      });

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);

          if (userData['id'] != null) {
            // Successful login
            _isLoggedIn = true;
            _storeUserData(userData); // Call _storeUserData to parse and store data
          } else {
            // Invalid credentials or other error
            _isLoggedIn = false;
            print('Login failed: Invalid credentials or other error');
          }
        } else {
          // Server error or network issue
          _isLoggedIn = false;
          print('Login failed: Status code ${response.statusCode}');
        }
      } catch (e) {
        // Exception handling for unexpected errors
        _isLoggedIn = false;
        print('Error during login: $e');
      }

      notifyListeners(); // Notify listeners when the login status changes
    }

    // Logout the user
    void logout() {
      _isLoggedIn = false;
      _userId = null; // Clear the user ID
      notifyListeners(); // Notify listeners when the login status changes
    }
  }

  Future<void> createOrder({
    required int productId,
    required DateTime selectedDate,
    required String location,
    required String time,
  }) async {
    try {
      final url = Uri.parse('https://evxservices.com/22D92D50C1FFE2697C24336CDCDapi/order/');

      final authProvider = AuthProvider(); // Create an instance of AuthProvider
      // You may need to initialize this instance with the user's data.

      final requestBody = jsonEncode({
        "customer": authProvider.userId, // Use the user's ID here
        "product": productId,
        "date": selectedDate.toIso8601String(),
        "name": authProvider.userName, // Use the user's name here
        "phone": authProvider.userPhone, // Use the user's phone number here
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
        print('Request Body: ${requestBody}');
        print('Failed to create order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }
