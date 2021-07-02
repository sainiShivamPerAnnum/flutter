import 'package:bezier_chart/bezier_chart.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class GoldRateGraph extends StatefulWidget {
  GoldRateGraph({Key key}) : super(key: key);

  @override
  _GoldRateGraphState createState() => _GoldRateGraphState();
}

class _GoldRateGraphState extends State<GoldRateGraph> {
  AugmontModel augmontProvider;
  List<GoldGraphPoint> _dataPoints;
  List<DataPoint<DateTime>> _bezierPoints = [];
  String _dataPointsState = "loading";
  int _selectedFrequency = 1;
  List<BezierChartScale> _scales = [BezierChartScale.WEEKLY, BezierChartScale.MONTHLY, BezierChartScale.YEARLY];

  @override
  Widget build(BuildContext context) {
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    if(_dataPointsState=="loading") {
      print('loading');
      _getDataPoints().then((value){
        if(value!=null) { 
          print(value.length);
          _dataPoints = value; 
          for(var v in _dataPoints) {
            _bezierPoints.add(DataPoint(value: v.rate, xAxis: v.timestamp));
          }
          print(_bezierPoints.toString());
        }
        (value==null) ? _dataPointsState = "error" : _dataPointsState = "done";
        setState(() {});
      });
    }
    double _height = MediaQuery.of(context).size.height;
    if(_dataPointsState=="loading") {
      return Container(
          margin: EdgeInsets.symmetric(
            horizontal: _height * 0.02,
          ),
          height: _height * 0.3,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  SpinKitThreeBounce(color: UiConstants.spinnerColor2,size: 18.0,)),
      );
    }
    switch(_dataPointsState) {
      case 'done' : {
        return Column(children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: _height * 0.02,
            ),
            height: _height * 0.35,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  BezierChart(
                bezierChartScale: _scales[_selectedFrequency],
                fromDate: _dataPoints[0].timestamp,
                toDate: _dataPoints[_dataPoints.length-1].timestamp,
                selectedDate: _dataPoints[_dataPoints.length-1].timestamp,
                series: [
                  BezierLine(data: _bezierPoints, label: 'Gold Rate', lineColor: UiConstants.primaryColor)
                ],
                config: BezierChartConfig(
                  showVerticalIndicator: true,
                  pinchZoom: false,
                  displayDataPointWhenNoValue: false,
                  verticalIndicatorColor: Colors.grey[400],
                  updatePositionOnTap: true,
                  snap: true,
                  footerHeight: 50,
                  xAxisTextStyle: TextStyle(color: Color(0xff484848))
                ),
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap : (){
                  setState(() {
                    _selectedFrequency = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: UiConstants.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: (_selectedFrequency==0)?UiConstants.primaryColor:Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Weekly',style: TextStyle(color: (_selectedFrequency==0)?Colors.white:Colors.black,),),
                  ),
                ),
              ),
              GestureDetector(
                onTap : (){
                  setState(() {
                    _selectedFrequency = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: UiConstants.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: (_selectedFrequency==1)?UiConstants.primaryColor:Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Monthly', style: TextStyle(color: (_selectedFrequency==1)?Colors.white:Colors.black,),),
                  ),
                ),
              ),
              GestureDetector(
                onTap : (){
                  setState(() {
                    _selectedFrequency = 2;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: UiConstants.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: (_selectedFrequency==2)?UiConstants.primaryColor:Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Yearly', style: TextStyle(color: (_selectedFrequency==2)?Colors.white:Colors.black,),),
                  ),
                ),
              ),
            ],
          )
        ],);
      }
      case 'error' : {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: _height * 0.02,
          ),
          height: _height * 0.3,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Center(child: Text('Something went wrong, cannot show gold rates graph right now.'),),
          ),
        );
      }
    }
  }

  Future<List<GoldGraphPoint>> _getDataPoints() async {
    List<GoldGraphPoint> _res;
    try {
       _res = await augmontProvider.getGoldRateChart(DateTime(2019,1,1), DateTime.now());
       final Map<DateTime, double> line1 = {
        DateTime.utc(2018, 03, 19): 3130,
        DateTime.utc(2018, 04, 29): 3199,
        DateTime.utc(2018, 05, 30): 3205,
        DateTime.utc(2018, 06, 10): 3152,
        DateTime.utc(2018, 07, 18): 3053,
        DateTime.utc(2018, 08, 03): 3118,
        DateTime.utc(2018, 09, 02): 3138,
        DateTime.utc(2018, 10, 04): 3281,
        DateTime.utc(2018, 12, 10): 3142,
        DateTime.utc(2019, 01, 25): 3223,
        DateTime.utc(2019, 02, 17): 3223,
        DateTime.utc(2019, 03, 12): 3443,
        DateTime.utc(2019, 04, 14): 3280,
        DateTime.utc(2019, 05, 18): 3279,
        DateTime.utc(2019, 06, 10): 3294,
        DateTime.utc(2019, 07, 18): 3466,
        DateTime.utc(2019, 08, 03): 3590,
        DateTime.utc(2019, 09, 02): 3994,
        DateTime.utc(2019, 10, 04): 3877,
        DateTime.utc(2019, 12, 10): 4008,
        DateTime.utc(2020, 01, 25): 3925,
        DateTime.utc(2020, 02, 17): 4026,
        DateTime.utc(2020, 03, 12): 4221,
        DateTime.utc(2020, 04, 14): 4347,
        DateTime.utc(2020, 05, 18): 4473,
        DateTime.utc(2020, 06, 10): 4650,
        DateTime.utc(2020, 07, 18): 4848,
        DateTime.utc(2020, 08, 03): 5050,
        DateTime.utc(2020, 09, 02): 5530,
        DateTime.utc(2020, 10, 04): 5340,
        DateTime.utc(2020, 12, 10): 5225,
        DateTime.utc(2021, 01, 25): 5141,
        DateTime.utc(2021, 02, 17): 4702,
      };
      _res.clear();
      line1.forEach((key, value) {
        _res.add(GoldGraphPoint(value, key));
      });
    } catch(err) {
      print(err);
    }
    return _res;
  }
}