import 'package:flutter/material.dart';

class AdDetails extends StatefulWidget {
  final String? ad_id;
  const AdDetails({required this.ad_id});

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body: Text("${widget.ad_id}"),
    );
  }
}