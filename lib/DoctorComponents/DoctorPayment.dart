import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/MedicineComponents/Pembayaran.dart';
import 'package:project/components/PaymentMethod.dart';

class DoctorPayment extends StatefulWidget {
  final String image;
  final String name;
  final String choosenDate;
  final String price;

  const DoctorPayment({
    Key? key,
    required this.image,
    required this.name,
    required this.choosenDate,
    required this.price,
  }) : super(key: key);

  @override
  State<DoctorPayment> createState() => _DoctorPaymentState();
}

class _DoctorPaymentState extends State<DoctorPayment> {
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
            icon: const Icon(Icons.chevron_left)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 149, 205, 251),
                      radius: 50,
                      child: Image.network(widget.image)),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontSize: 17)),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Online Consultation',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.choosenDate,
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment ID',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 17),
                        ),
                        const Text(
                          'IDKNSLN123456789',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Session Fee',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 17),
                        ),
                        const Text(
                          'Rp 35.000',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                  color: Color.fromRGBO(143, 174, 222, 1), thickness: 7),
              const SizedBox(
                height: 15,
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
                  if (selectedPaymentMethod == null &&
                      selectedPaymentImage == null) {
                    showErrorPopup(context, 'Payment Method not Selected', 'Please Select the Payment Method');
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

  void showErrorPopup(BuildContext context, String error, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error),
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
