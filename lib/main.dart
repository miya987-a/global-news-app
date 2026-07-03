import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Global News',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // নিচের লাইনে আপনার ওয়েবসাইটের আসল লিংকটি দিন
      ..loadRequest(Uri.parse('https://আপনার-ওয়েবসাইটের-লিংক.onrender.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global News'),
        toolbarHeight: 0, // এটি ওপরের বার লুকিয়ে রাখবে যাতে পুরো স্ক্রিন জুড়ে ওয়েবসাইট দেখা যায়
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}

