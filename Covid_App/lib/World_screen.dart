import 'dart:convert';

import 'package:covid_app/View/Countries_Screen.dart';
import 'package:covid_app/models/All_model.dart';
import 'package:covid_app/models/Countries_model.dart';
import 'package:covid_app/services/utilities/state_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});
  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat();
  @override
  Widget build(BuildContext context) {
    state_services state_service = state_services();
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset(0.0,0.0 ),
                  end: FractionalOffset(1.0, 1.0),
                  stops: [0.2,0.8,1.0],
                  colors: [
                    Color(0xFF000000), // Pure Black
                    Color(0xFF0F2027), // Dark Greyish Cyan
                    Color(0xFF031833), // Emerald Teal
                  ]
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(future: state_service.getworldApi(),
                builder: (context,AsyncSnapshot<AllApi> snapshot) {
                  if(!snapshot.hasData){
                    return Center(
                      child: Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          duration: Duration(seconds: 3),
                          size: 60,
                          controller: _controller,
                        ),
                      ),
                    );
                  }else{
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: PieChart(
                            animationDuration: Duration(milliseconds: 2000),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            chartType: ChartType.ring,
                            legendOptions: LegendOptions(
                              legendPosition: LegendPosition.left,
                            ),
                            colorList: [
                              Color(0xff042959),
                              Color(0xff086108),
                              Color(0xffbf0a0f),
                            ],
                            dataMap: {
                              'Total': snapshot.data!.cases!.toDouble(),
                              'Recovered': snapshot.data!.recovered!.toDouble(),
                              'Deaths': snapshot.data!.deaths!.toDouble()},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Card(
                            child: Column(
                              children: [
                                reuseableRow(Title: 'Population', Value: snapshot.data!.population.toString()),
                                reuseableRow(Title: 'Cases', Value: snapshot.data!.cases.toString()),
                                reuseableRow(Title: 'Deaths', Value: snapshot.data!.deaths.toString()),
                                reuseableRow(Title: 'Recovered', Value: snapshot.data!.recovered.toString()),
                                reuseableRow(Title: 'Affected Countries', Value: snapshot.data!.affectedCountries.toString()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Country_Screen(),));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff086108),
                          ),
                          child: Text('Tracking Countries'),
                        ),
                      ],
                    );
                  }
                },),
              // Padding(
              //   padding: const EdgeInsets.all(40),
              //   child: PieChart(
              //     animationDuration: Duration(milliseconds: 2000),
              //     chartType: ChartType.ring,
              //     legendOptions: LegendOptions(
              //       legendPosition: LegendPosition.left,
              //     ),
              //     colorList: [
              //       Color(0xff042959),
              //       Color(0xff086108),
              //       Color(0xffbf0a0f),
              //     ],
              //     dataMap: {'Total': 200, 'Recovered': 50, 'Deaths': 10},
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(15),
              //   child: Card(
              //     child: Column(
              //       children: [
              //         //CountryApi(Ttile: , Value: )
              //          reuseableRow(Ttile: 'Total', Value: '200'),
              //          reuseableRow(Ttile: 'Total', Value: '200'),
              //          reuseableRow(Ttile: 'Total', Value: '200'),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Color(0xff086108),
              //   ),
              //   child: Text('Tracking Countries'),
              // ),
            ],
          ),
        )
      ),
    );
  }
}

class reuseableRow extends StatelessWidget {
  String Title, Value;
  reuseableRow({super.key, required this.Title, required this.Value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Title,style: TextStyle(fontStyle: FontStyle.italic),),
              Text(Value)],
          ),
          SizedBox(height: 10),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}

