import 'package:flutter/material.dart';
import 'package:flutter_animated_app/3d_cards/model/city_model.dart';
import 'package:flutter_animated_app/3d_cards/styles.dart';
import 'package:flutter_animated_app/3d_cards/travel_card_list.dart';

class TravelCardDemo extends StatefulWidget {
  @override
  _TravelCardDemoState createState() => _TravelCardDemoState();
}

class _TravelCardDemoState extends State<TravelCardDemo> {
  late List<City> _cityList;
  late City _currentCity;

  @override
  void initState() {
    super.initState();
    var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: _buildAppBar(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding),
              child: Text(
                'Let\'s explore places to visit!!',
                overflow: TextOverflow.ellipsis,
                style: Styles.appHeader,
                maxLines: 2,
              ),
            ),
            TravelCardList(
              cities: _cityList,
              onCityChange: _handleCityChange,
            ),
          ],
        ),
      ),
      // bottomSheet: SlideUpBar(),
    );
  }

  void _handleCityChange(City city) {
    setState(() {
      this._currentCity = city;
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      leading: Icon(Icons.menu, color: Colors.black),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding),
          child: Icon(Icons.search, color: Colors.black),
        )
      ],
    );
  }
}
