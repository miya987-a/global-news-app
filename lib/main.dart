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
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // এটি নিশ্চিত করবে যে যেকোনো লিংক ব্রাউজারে না গিয়ে অ্যাপের ভেতরেই ওপেন হবে
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://global-news-zq4r.onrender.com/'));
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope ব্যবহার করা হয়েছে যাতে ব্যাক বাটনে চাপলে অ্যাপ বন্ধ না হয়ে আগের খবরে যায়
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false; // অ্যাপ থেকে বের না হয়ে ওয়েবসাইটের আগের পেজে যাবে
        }
        return true; // আর কোনো পেজ না থাকলে অ্যাপ থেকে বের হয়ে যাবে
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
