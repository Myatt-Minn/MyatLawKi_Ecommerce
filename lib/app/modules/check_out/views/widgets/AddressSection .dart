import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/region_deli_model.dart';
import 'package:myat_ecommerence/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:myat_ecommerence/app/modules/check_out/views/widgets/customtextfield.dart';

class AddressSection extends StatelessWidget {
  final TextEditingController addressController;
  final CheckOutController controller;

  const AddressSection(
      {super.key, required this.addressController, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Obx(() => DropdownButton<RegionModel>(
                  hint: Text("Select Region"),
                  value: controller.selectedRegion.value,
                  isExpanded: true,
                  items: controller.regions.map((region) {
                    return DropdownMenuItem<RegionModel>(
                      value: region,
                      child: Text(region.name),
                    );
                  }).toList(),
                  onChanged: (newRegion) {
                    controller.onRegionSelected(newRegion!);
                  },
                )),
            const SizedBox(height: 10),
            Obx(() => DropdownButton<String>(
                  hint: Text("Select City"),
                  value: controller.selectedCity.value.isNotEmpty
                      ? controller.selectedCity.value
                      : null,
                  isExpanded: true,
                  items: controller.citiesForSelectedRegion.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (newCity) {
                    controller.onCitySelected(newCity!);
                  },
                )),
            const SizedBox(height: 10),
            Text('Shipping Address',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: addressController,
              icon: Icons.home_outlined,
              hintText: 'Address Detail',
            ),
          ],
        ));
  }
}
