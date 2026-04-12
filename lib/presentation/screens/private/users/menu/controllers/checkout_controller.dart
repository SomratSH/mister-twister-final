// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CheckoutController extends GetxController {
//   // Delivery address
//   final Rx<String> deliveryAddress = 'Tap to select location'.obs;
//   final Rx<double?> latitude = Rx<double?>(null);
//   final Rx<double?> longitude = Rx<double?>(null);

//   // Contact information
//   final Rx<String> fullName = 'John Doe'.obs;
//   final Rx<String> phoneNumber = '+1 (555) 000-0000'.obs;
//   final Rx<String> email = 'john@example.com'.obs;

//   // Delivery instructions (optional)
//   final Rx<String> deliveryInstructions = ''.obs;

//   // Order notes (optional)
//   final Rx<String> orderNotes = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // TODO: Load user profile data when available
//   }

//   // Update delivery address with coordinates
//   void updateDeliveryLocation(String address, double lat, double lng) {
//     deliveryAddress.value = address;
//     latitude.value = lat;
//     longitude.value = lng;
//   }

//   // Update contact information
//   void updateContactInfo({
//     required String name,
//     required String phone,
//     required String emailAddress,
//   }) {
//     fullName.value = name;
//     phoneNumber.value = phone;
//     email.value = emailAddress;
//   }

//   // Update delivery instructions
//   void updateDeliveryInstructions(String instructions) {
//     deliveryInstructions.value = instructions;
//   }

//   // Update order notes
//   void updateOrderNotes(String notes) {
//     orderNotes.value = notes;
//   }

//   // Validate checkout form
//   bool validateCheckout() {
//     if (deliveryAddress.value == 'Tap to select location') {
//       Get.snackbar(
//         'Error',
//         'Please select a delivery location',
//         backgroundColor: const Color(0xFFFF6B9D),
//         colorText: const Color(0xFFFFFFFF),
//       );
//       return false;
//     }
//     if (fullName.value.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter your name',
//         backgroundColor: const Color(0xFFFF6B9D),
//         colorText: const Color(0xFFFFFFFF),
//       );
//       return false;
//     }
//     if (phoneNumber.value.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter your phone number',
//         backgroundColor: const Color(0xFFFF6B9D),
//         colorText: const Color(0xFFFFFFFF),
//       );
//       return false;
//     }
//     return true;
//   }
// }
