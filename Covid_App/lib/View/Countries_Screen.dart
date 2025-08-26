import 'package:covid_app/models/Countries_model.dart';
import 'package:covid_app/services/utilities/state_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart'; // For animations

import 'detail_screen.dart';

class Country_Screen extends StatefulWidget {
  const Country_Screen({super.key});

  @override
  State<Country_Screen> createState() => _Country_ScreenState();
}

class _Country_ScreenState extends State<Country_Screen> {
  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    state_services state_service = state_services();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🌍 Country Selection',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.2, 0.8, 1.0],
              colors: [
                Color(0xFF000000),
                Color(0xFF0F2027),
                Color(0xFF031833),
              ],
            ),
          ),
          child: Column(
            children: [
              // 🔍 Search Box with better UI
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: searchcontroller,
                  onChanged: (value) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search country...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.tealAccent, width: 1.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🌍 Country List
              Expanded(
                child: FutureBuilder<List<CountriesModel>>(
                  future: state_service.getCountryApi(),
                  builder: (context, AsyncSnapshot<List<CountriesModel>> snapshot) {
                    if (!snapshot.hasData) {
                      // ⚡ Shimmer Loading Effect
                      return ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.white10,
                            highlightColor: Colors.white30,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white24,
                                radius: 25,
                              ),
                              title: Container(height: 15, color: Colors.white),
                              subtitle: Container(height: 10, color: Colors.white),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      final countries = snapshot.data!;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          String name = countries[index].country.toString();

                          // 🔍 Filter
                          if (searchcontroller.text.isNotEmpty &&
                              !name.toLowerCase().contains(searchcontroller.text.toLowerCase())) {
                            return Container();
                          }
                          return FadeInUp( // ✨ Smooth Animation
                            duration: Duration(milliseconds: 200 + (index * 30)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      image: countries[index].countryInfo!.flag.toString(),
                                      name: countries[index].country.toString(),
                                      totalCases: countries[index].cases!.toInt(),
                                      totalRecovered: countries[index].recovered!.toInt(),
                                      totalDeaths: countries[index].deaths!.toInt(),
                                      active: countries[index].active!.toInt(),
                                      test: countries[index].tests!.toInt(),
                                      todayRecovered: countries[index].todayRecovered!.toInt(),
                                      critical: countries[index].critical!.toInt(),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                                color: Colors.white.withOpacity(0.05),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                    NetworkImage(countries[index].countryInfo!.flag.toString()),
                                  ),
                                  title: Text(
                                    countries[index].country.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "Cases: ${countries[index].cases}",
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 18, color: Colors.white70),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
