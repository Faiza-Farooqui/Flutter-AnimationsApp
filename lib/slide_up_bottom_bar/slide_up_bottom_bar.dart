import 'package:flutter/services.dart';
import 'package:flutter_animated_app/3d_cards/model/city_model.dart';
import 'package:flutter_animated_app/3d_cards/styles.dart';
import 'package:flutter_animated_app/3d_cards/travel_card_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'custom_design/curver_design.dart';

class SlideUpBar extends StatefulWidget {

  String text;
  final Widget sliderPanelBody, mainBody;


  SlideUpBar({this.text : "",
    this.sliderPanelBody: const SizedBox(),
    this.mainBody: const SizedBox(),
  });

  @override
  _SlideUpBarState createState() => _SlideUpBarState();
}

class _SlideUpBarState extends State<SlideUpBar> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 57.0;
  bool isUp = false;
  PanelController _panelController = new PanelController();
  String _scanBarcode = 'Unknown';

  late List<City> _cityList;
  late City _currentCity;

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;

    var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList[1];
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .95;
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        // parallaxEnabled: true,
        parallaxOffset: .5,
         body: Container(
           color: Colors.white,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               _buildAppBar(),
               SizedBox(height: 15,),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding),
                 child: Text(
                   'Where are you going next?',
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
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0)),
        onPanelSlide: (double pos) => setState(() {
          if(pos == 1.0) isUp = true;
          else isUp = false;
        }),
        // panelBuilder: (sc) => _descriptionPanel(sc),  // this is description and scrollable widgte
        panelBuilder: (sc) => _barCodePanel(), // this panel used to scan BarCode and QR Code
      ),
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

  Widget _barCodePanel(){
    final height = MediaQuery.of(context).size.height;
    return MediaQuery.removePadding(
      context: context,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 155.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        shadowColor: Colors.green[300],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.qr_code,
                            size: 28,
                            color: Colors.green,
                          ),
                        )),
                    onTap: () {
                      scanQR();
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      // margin: const EdgeInsets.only(top: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        shadowColor: Colors.blue[300],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/barcode_icon.png',
                            width: 30,height: 28,fit: BoxFit.cover,
                            color: Colors.blue,
                          ),
                        )),
                    onTap: () {
                      scanBarcode();
                    },
                  ),
                ],),
              SizedBox(height: 17.0,),
              Image.asset(
                _scanBarcode == '8964000103791'?
                'assets/images/wavy_chips.jpg' : 'assets/images/cam.png', width: 150,height: 210,fit: BoxFit.cover,),
              Center(child: Text(_scanBarcode == '8964000103791'? '\n\nPrice: RS 30': '\n\nName: $_scanBarcode',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF777777),)),),
              Container(
                margin: const EdgeInsets.only(left: 90, right: 90.0,top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3.0,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_shopping_cart_rounded,size: 17,color: Colors.blue,),
                      Image.asset("assets/images/substract.png", height: 24.0, width: 24.0, fit: BoxFit.scaleDown,),
                      Text("Add to Cart", textAlign: TextAlign.center, style: new TextStyle(fontSize: 20.0, color: Colors.redAccent,),),
                    ],
                  ),
                  onPressed: (){
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: isUp,
            child: Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
          ),
          Positioned(
            top: 10,
            left: MediaQuery.of(context).size.width /2.4,
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width /2.6,
            child: Text(
              isUp? 'Scan Here':
              "Slide Up to Scan",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: isUp?20.0:12.0,
                  color: Colors.grey
              ),
            ),
          ),
          Visibility(
            visible: isUp,
            child: GestureDetector(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Icon(Icons.clear, size: 25,color: Colors.green,)),
              ),
              onTap: (){
                print('========================== working');
                _panelController.close();
                setState(() {
                  _scanBarcode = 'Unknown';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget _descriptionPanel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
                Visibility(
                  visible: isUp,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          margin: const EdgeInsets.only(right: 15.0, top: 5.0),
                          child: Icon(Icons.clear, size: 25,color: Colors.grey,)),
                    ),
                    onTap: (){
                      _panelController.close();
                    },
                  ),
                )
              ],),
            SizedBox(
              height: isUp? 0.0: 10.0,
            ),
            Center(
              child: Text(
                isUp? 'Explore':
                "Slide Up to Explore",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: isUp?20.0:12.0,
                    color: Colors.grey
                ),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _button("Popular", Icons.favorite, Colors.blue),
                _button("Food", Icons.restaurant, Colors.red),
                _button("Events", Icons.event, Colors.amber),
                _button("More", Icons.more_horiz, Colors.green),
              ],
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Images",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.network(
                        "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                      Image.network(
                        "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("About",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms generating \$20.7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
                  """,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(label),
      ],
    );
  }
}