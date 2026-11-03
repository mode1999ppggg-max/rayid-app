import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const RayidApp());
}

class RayidApp extends StatelessWidget {
  const RayidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق رايد',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Cairo',
      ),
      home: const MainContainerScreen(),
    );
  }
}

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  _MainContainerScreenState createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  bool _isLoggedIn = false;
  String _phone = "";
  String _name = "";
  int _points = 0;
  int _balanceIqd = 0;

  // رابط سيرفرك الآمن على الكولاب
  final String serverUrl = "https://dark-vans-exist.loca.lt";

  void loginSuccess(String phone, String name, int points, int balance) {
    setState(() {
      _isLoggedIn = true;
      _phone = phone;
      _name = name;
      _points = points;
      _balanceIqd = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return RegisterScreen(onSuccess: loginSuccess, serverUrl: serverUrl);
    } else {
      return DashboardScreen(
        phone: _phone,
        name: _name,
        points: _points,
        balanceIqd: _balanceIqd,
        serverUrl: serverUrl,
        onLogout: () => setState(() => _isLoggedIn = false),
      );
    }
  }
}

class RegisterScreen extends StatefulWidget {
  final Function(String, String, int, int) onSuccess;
  final String serverUrl;

  const RegisterScreen({Key? key, required this.onSuccess, required this.serverUrl}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String _responseMessage = "";

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
      _responseMessage = "";
    });

    try
