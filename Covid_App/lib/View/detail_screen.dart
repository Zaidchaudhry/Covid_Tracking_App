import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;

  const DetailScreen({
    super.key,
    required this.image,
    required this.name,
    required this.totalCases,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.active,
    required this.critical,
    required this.todayRecovered,
    required this.test,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.2,0.8,1.0],
            colors: [
              Color(0xFF000000), // Pure Black
              Color(0xFF0F2027), // Dark Greyish Cyan
              Color(0xFF031833), // Emerald Teal
            ],
              begin: FractionalOffset(0.0,0.0 ),
          end: FractionalOffset(1.0, 1.0),
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Flag Avatar
                Hero(
                  tag: widget.image,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(widget.image),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Glass Card
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      _buildStatCard("Total Cases", widget.totalCases.toString(),
                          Icons.coronavirus, Colors.orangeAccent.shade700),
                      _buildStatCard("Recovered",
                          widget.totalRecovered.toString(), Icons.healing,
                          Colors.greenAccent.shade700),
                      _buildStatCard("Deaths", widget.totalDeaths.toString(),
                          Icons.close, Colors.redAccent.shade700),
                      _buildStatCard("Critical", widget.critical.toString(),
                          Icons.warning_amber_rounded, Colors.purpleAccent.shade700),
                      _buildStatCard("Today Recovered",
                          widget.todayRecovered.toString(),
                          Icons.local_hospital_rounded,
                          Colors.lightGreenAccent.shade700),
                      _buildStatCard("Total Tests", widget.test.toString(),
                          Icons.science, Colors.blueAccent.shade700),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color glowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: glowColor, size: 30),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: glowColor,
          ),
        ),
      ),
    );
  }
}
