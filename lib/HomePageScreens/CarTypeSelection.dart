import 'package:easy_wash_v1/HomePageScreens/HomePageMap.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}
int carTypeSelected=0;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarSelectionScreen(),
    );
  }
}

class CarSelectionScreen extends StatelessWidget {
  String CarType='';
  final List<CarModel> cars = [
    CarModel(name: 'Hatchback', images: "03.png", carSelectedType: 1),
    CarModel(name: 'Sedan', images: "04.png", carSelectedType: 2),
    CarModel(name: 'SUV', images: "02.png", carSelectedType: 3),
    CarModel(name: 'MPV', images: "01.png", carSelectedType: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boxWidth = screenSize.width / 3; // Two boxes in a row
    final boxHeight = screenSize.height / 3; // Two boxes in a column

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Selection'),
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(), // Disable GridView's scroll
          shrinkWrap: true, // Allow GridView to occupy its content
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            childAspectRatio: boxWidth / boxHeight, // Maintain aspect ratio
          ),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return GestureDetector(
              onTap: () {
                final selectedCar = car.name;
                carTypeSelected=car.carSelectedType;
                CarType=car.name;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected Car Type: $selectedCar'),
                  ),
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePageMap(isBikeSelected: false,selectedCarType: carTypeSelected ,);
                    },
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'IMAGES/${car.images}',
                      width: boxWidth, // Set width to boxWidth
                      height: boxHeight, // Set height to boxHeight
                    ),
                    const SizedBox(height: 8),
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CarModel {
  final String name;
  final String images;
  final int carSelectedType;

  CarModel({required this.name, required this.images,required this.carSelectedType});
}
