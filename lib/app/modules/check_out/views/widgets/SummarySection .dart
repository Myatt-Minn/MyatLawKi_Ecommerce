import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';
import 'package:myat_ecommerence/app/modules/check_out/controllers/check_out_controller.dart';

class SummarySection extends StatelessWidget {
  final CartController cartController;
  final CheckOutController checkOutController;

  const SummarySection({
    super.key,
    required this.cartController,
    required this.checkOutController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Obx(() {
          final fee = checkOutController.selectedFee.value;
          return Column(
            children: [
              _summaryRow(
                  'subtotal'.tr, '${cartController.totalAmount.value} MMK'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    fee.isNotEmpty
                        ? Text(
                            "$fee MMK",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        : Text("0 MMK",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ],
                ),
              ),
              _summaryRow(
                  'total_price'.tr, '${checkOutController.finaltotalcost} MMK'),
            ],
          );
        }),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              return checkOutController.isLoading.value
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: _buildPaymentButton(
                        label: 'cash_on_deli'.tr,
                        color: Colors.grey,
                        onPressed: () {
                          // checkOutController.setOrder()
                          //     ? checkOutController.confirmPayment()
                          //     : Get.snackbar(
                          //         "Empty TextBox", "fill_all_information".tr,
                          //         backgroundColor: Colors.red);
                        },
                      ),
                    );
            }),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPaymentButton(
                label: 'online_pay'.tr,
                color: ConstsConfig.secondarycolor,
                onPressed: () {
                  checkOutController.setOrder()
                      ? Get.toNamed('/payment', arguments: {
                          "name": checkOutController.nameController.text,
                          "phoneNumber":
                              checkOutController.phoneNumberController.text,
                          "address": checkOutController.addressController.text,
                          "totalCost": checkOutController.finaltotalcost
                        })
                      : Get.snackbar("Empty TextBox", "fill_all_information".tr,
                          backgroundColor: Colors.red);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Custom Payment Button
  Widget _buildPaymentButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
