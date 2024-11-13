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
          Obx(
            () => DropdownButton<DeliFeeModel>(
              hint: Text("Select Region"),
              value: controller.selectedFee.value,
              isExpanded: true,
              items: controller.deliFees.map((DeliFeeModel fee) {
                return DropdownMenuItem<DeliFeeModel>(
                  value: fee,
                  child: Text(fee.region.name),
                );
              }).toList(),
              onChanged: (DeliFeeModel? newValue) {
                controller.selectedFee.value = newValue!;
              },
            ),
          ),
          const SizedBox(height: 10),
          Text('shipping_address'.tr,
              style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 8),
          CustomTextField(
            controller: addressController,
            icon: Icons.home_outlined,
            hintText: 'Address Detail',
          ),
        ],
      ),
    );
  }
}
