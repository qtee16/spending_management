import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatefulWidget {
  String updateLink;

  UpdateScreen({required this.updateLink, Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/zyro-image.png',
                width: 100,
              ),
              const SizedBox(height: 20,),
              Text(
                'Đã có phiên bản mới\n Vui lòng cập nhật để sử dụng!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  String url = widget.updateLink;
                  if (!await launchUrl(Uri.parse(url))) {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('Tải bản cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
