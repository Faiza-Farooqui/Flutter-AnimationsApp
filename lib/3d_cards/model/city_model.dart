import 'package:flutter/material.dart';

class City {
  final String name;
  final String title;
  final String description;
  final Color color;

  City({
    required this.title,
    this.name: "",
    this.description: "",
    this.color: Colors.black,
  });
}

class DemoData {
  List<City> _cities = [
    City(
        name: 'Pisa',
        title: 'Pisa, Italy',
        description: 'Discover a beautiful city where ancient and modern meet',
        color: Color(0xffdee5cf),
       ),
    City(
        name: 'Budapest',
        title: 'Budapest, Hungary',
        description: 'Meet the city with rich history and indescribable culture',
        color: Color(0xffdaf3f7),
    ),
    City(
      name: 'London',
      title: 'London, England',
      description: 'A diverse and exciting city with the world’s best sights and attractions!',
      color: Color(0xfff9d9e2),
    ),];

  List<City> getCities() => _cities;
}
