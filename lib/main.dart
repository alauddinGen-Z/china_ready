import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/journey_provider.dart';
import 'screens/journey_map_screen.dart';

void main() {
  runApp(const ChinaReadyApp());
}

class ChinaReadyApp extends StatelessWidget {
  const ChinaReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JourneyProvider()),
      ],
      child: MaterialApp(
        title: 'ChinaReady',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE60012)), // China Red
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: const JourneyMapScreen(),
      ),
    );
  }
}
