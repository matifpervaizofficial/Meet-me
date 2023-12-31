// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/Featiure/Authentication/login/login_bloc/login_bloc.dart';
import 'package:meetly/Featiure/home/ui/pages/homepage.dart';
import 'package:meetly/Featiure/welcome/UI/screens/welcome_screen.dart';
import 'package:meetly/member_chat_home.dart';
import 'package:meetly/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assesment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meetly',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
            fontFamily: GoogleFonts.poppins().fontFamily),
        home: FirebaseAuth.instance.currentUser != null
            ? HomePage()
            : WelcomeScreen(),
      ),
    );
  }
}
