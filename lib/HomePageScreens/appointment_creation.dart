import 'package:easy_wash_v1/HomePageScreens/CarTypeSelection.dart';
import 'package:easy_wash_v1/Initial%20Screens/InitialPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_wash_v1/userSetup/login_page.dart';
import 'package:provider/provider.dart';
import 'package:easy_wash_v1/userSetup/AuthProvider.dart';
import 'package:easy_wash_v1/Initial Screens/InitialPage.dart';

class Product {
  final int id;
  final String title;
  final double selling_price;
  final double discount_price;
  final String description;
  final double m_cat;
  final double cat;
  final String sc;
  final String product_image;
  final List<String> checklistItems;
  bool isSelected;

  Product({
    required this.id,
    required this.description,
    required this.title,
    required this.selling_price,
    required this.discount_price,
    required this.m_cat,
    required this.cat,
    required this.sc,
    required this.product_image,
    required this.checklistItems,
    this.isSelected = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final checklist = json["Checklist"];
    final checklistItems = (checklist is List)
        ? checklist.map((item) => item.toString()).toList()
        : <String>[];

    return Product(
      id: json["id"] as int,
      description: json["description"] as String,
      title: json["title"] as String,
      selling_price: (json["selling_price"] as num).toDouble(),
      discount_price: (json["discount_price"] as num).toDouble(),
      m_cat: (json["m_cat"] as num).toDouble(),
      cat: (json["cat"] as num).toDouble(),
      sc: (json["sc"] as String),
      product_image: json["product_image"] as String,
      checklistItems: checklistItems,
    );
  }
}

class AppointmentCreationScreen extends StatefulWidget {
  final LatLng? selectedLocation;
  final bool isBikeSelected;
  final int carTypeSelected;

  AppointmentCreationScreen({required this.selectedLocation,required this.isBikeSelected,required this.carTypeSelected});

  @override
  _AppointmentCreationScreenState createState() =>
      _AppointmentCreationScreenState();
}

class _AppointmentCreationScreenState extends State<AppointmentCreationScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _selectedLocation;
  List<Product> selectedProducts = [];
  List<Product> checklistItems = [];
  List<int> selectedProductIds = [];

  Future<void> fetchChecklistItems() async {
    try {
      final response = await http.get(
        Uri.parse('https://evxservices.com/22D92D50C1FFE2697C24336CDCDapi/product/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          bool _isBikeSelected;
          _isBikeSelected = widget.isBikeSelected;
          checklistItems = data.map((item) {
            final product = Product.fromJson(item);
            return product;
          }).where((product) =>
          (_isBikeSelected && product.m_cat == 2) || ((!_isBikeSelected && product.m_cat == 1)&&(!_isBikeSelected && product.cat==carTypeSelected ))
          ).toList();
        });
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching checklist items: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchChecklistItems();
    _selectedLocation = widget.selectedLocation;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _toggleProductSelection(Product product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
        product.isSelected = false;
        selectedProductIds.remove(product.id);
      } else {
        selectedProducts.add(product);
        product.isSelected = true;
        selectedProductIds.add(product.id);
      }
    });
  }

 void _navigateToLoginPage(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      if (_selectedDate != null && _selectedTime != null && _selectedLocation != null) {
        for (int productId in selectedProductIds) {
          createOrder(
            productId: productId,
            selectedDate: _selectedDate!,
            location: _selectedLocation.toString(),
            time: '${_selectedTime!.hour}:${_selectedTime!.minute}',
            authProvider: authProvider,
          );
        }

        _showSuccessDialog(context); // Show the success dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select date, time, and location.'),
          ),
        );
      }
    } else {
      final loggedIn = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!!'),
            content: Text('Your appointment has been created successfully'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitialPage(),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
  Future<void> createOrder({
    required int productId,
    required DateTime selectedDate,
    required String location,
    required String time,
    required AuthProvider authProvider,
  }) async {
    try {
      final url = Uri.parse(
          'https://evxservices.com/22D92D50C1FFE2697C24336CDCDapi/order/');

      final formattedSelectedDate =
      selectedDate.toLocal().toIso8601String().split('T')[0];
      final formattedAppointmentTime =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      final formattedOrderDate =
      DateTime.now().toLocal().toIso8601String().split('T')[0];

      final requestBody = jsonEncode({
        "customer": authProvider.userId,
        "product": productId,
        "date": formattedSelectedDate,
        "name": authProvider.userName,
        "phone": authProvider.userPhone,
        "address": location,
        "city": "Ghaziabad",
        "state": "Delhi NCR",
        "zip": "110094",
        "orderdate": formattedOrderDate,
        "time": formattedAppointmentTime,
      });

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Order created successfully');
      } else {
        print('Failed to create order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Appointment'),
        backgroundColor: Colors.blue, // Customize the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
          children: [
            ListTile(
              title: Text('Select Date'),
              subtitle: Text(_selectedDate == null
                  ? 'No date selected'
                  : _selectedDate!.toLocal().toLocal().toString().split(' ')[0]),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Select Time'),
              subtitle: Text(_selectedTime == null
                  ? 'No time selected'
                  : _selectedTime!.format(context)),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 16),
            Text(
              'Select Services:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Customize text color
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  final product = checklistItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.description),
                              Text(
                                'Discounted Price: \₹${product.discount_price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green, // Customize text color
                                ),
                              ),
                              Text(
                                'Selling Price: \₹${product.selling_price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green, // Customize text color
                                ),
                              ),
                            ],
                          ),
                          leading: Image.network(
                            product.product_image,
                            width: 80, // Set the image width
                            height: 80, // Set the image height
                          ),
                        ),
                        CheckboxListTile(
                          title: Text(
                            'Select this service',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Customize text color
                            ),
                          ),
                          subtitle: product.sc.isNotEmpty // Check if 'sc' is not an empty string
                              ? Text(
                            'Service includes: ${product.sc}', // Show 'sc' when it's not empty
                          )
                              : null,
                          value: product.isSelected,
                          onChanged: (newValue) {
                            _toggleProductSelection(product);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
      Center(
        child:ElevatedButton(
              onPressed: () {
                if (_selectedDate != null && _selectedTime != null) {
                  if (selectedProductIds.isNotEmpty) {
                    _navigateToLoginPage(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a service.'),
                        backgroundColor: Colors.blueGrey, // Customize the snack bar color
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select date and time.'),
                      backgroundColor: Colors.blueGrey, // Customize the snack bar color
                    ),
                  );
                }
              },
              child: Text(
                'Save Appointment',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: AppointmentCreationScreen(
    selectedLocation: LatLng(0.0, 0.0),
    isBikeSelected: false, carTypeSelected: 0,
  ),
));