import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';

import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4B1E16), // Dark brown background color
      appBar: AppBar(
        backgroundColor: Color(0xFF4B1E16),
        title: Text(
          'ဝန်ဆောင်မှုဆိုင်ရာ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png', // Replace with your logo image path
              height: 120,
            ),
            const SizedBox(height: 20),
            _buildExpansionTile('မေးလေ့ရှိသောမေးခွန်းများ'),
            const SizedBox(height: 10),
            _buildExpansionTile('မေးလေ့ရှိသောအခြားမေးခွန်းများ'),
            const SizedBox(height: 10),
            _buildExpansionTile('အထူးစျေးနှုန်းဆိုင်ရာအကြောင်းအရာများ'),
            const SizedBox(height: 20),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title) {
    return ExpansionTileCard(
      baseColor: Color(0xFF6A3A2E), // Lighter brown for the card
      expandedColor: Color(0xFF6A3A2E),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Icon(Icons.keyboard_arrow_down, color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'ဤအကြောင်းအရာတွင် အထောက်အကူပေးသည့်အချက်အလက်များပါဝင်သည်', // Example description text
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF6A3A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone, color: Colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Phone: ${ConstsConfig.phoneNumber}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: Colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Email: ${ConstsConfig.companyEmail}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.yellow),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Address: ${ConstsConfig.address}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
