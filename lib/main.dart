import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
    checkForUpdate();
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'LanguageChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // ওয়েবসাইট থেকে ভাষা পরিবর্তনের মেসেজ এখানে আসবে
          debugPrint("Language changed to: ${message.message}");
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            // পেজ লোড হওয়ার পর ল্যাঙ্গুয়েজ সিঙ্ক করা
            controller.runJavaScript("localStorage.setItem('lang', 'bn');");
          },
        ),
      )
      ..loadRequest(Uri.parse('https://global-news-zq4r.onrender.com/'));
  }

  Future<void> checkForUpdate() async {
    try {
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/miya987-a/global-news-app/main/version.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data['version'];
        String currentVersion = "1.0.0";

        if (latestVersion != currentVersion) {
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("নতুন আপডেট এসেছে!"),
              content: Text("অ্যাপটি লেটেস্ট ভার্সনে আপডেট করতে ডাউনলোড করুন।"),
              actions: [
                TextButton(
                  onPressed: () => launchUrl(Uri.parse(data['apk_url']), mode: LaunchMode.externalApplication),
                  child: Text("আপডেট করুন"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(),
        ),
        body: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
