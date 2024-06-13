// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/MedicineComponents/Pembayaran.dart';
import 'package:project/components/PaymentMethod.dart';

class DetailPembayaran extends StatefulWidget {
  final String product;
  final String price;

  const DetailPembayaran({
    super.key,
    required this.product,
    required this.price,
  });

  @override
  _DetailPembayaranState createState() => _DetailPembayaranState();
}

class _DetailPembayaranState extends State<DetailPembayaran> {
  final TextEditingController addressController = TextEditingController();
  String? selectedPaymentMethod;
  String? selectedPaymentImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Amount: 1 Strip (10 Tablet)',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Text('27 July 2023, 11:00 WIB',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment ID',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'IDKNSLN123456789',
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Payment',
                                style: TextStyle(fontSize: 17)),
                            Text(
                              widget.price,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shipping Address',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: TextField(
                            controller: addressController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              if (selectedPaymentMethod != null && selectedPaymentImage != null)
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Payment Method',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                selectedPaymentImage!,
                                width: 60,
                                height: 60,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                selectedPaymentMethod!,
                                style: const TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethod(
                        price: widget.price,
                        onPaymentMethodSelected:
                            (String paymentMethod, String paymentImage) {
                          setState(() {
                            selectedPaymentMethod = paymentMethod;
                            selectedPaymentImage = paymentImage;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromRGBO(143, 174, 222, 1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.wallet,
                            size: 17,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Choose Payment Method',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (addressController.text.isEmpty) {
                    showErrorPopup(context, 'fill the shipping address');
                  } else if (selectedPaymentMethod == null &&
                      selectedPaymentImage == null) {
                    showErrorPopup(context, 'select the payment method');
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pembayaran(price: widget.price, choosenMethod: selectedPaymentMethod!,)
                        ));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Kadwa',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorPopup(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
