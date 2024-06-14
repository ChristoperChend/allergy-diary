// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project/allergiesComponents/CekAlergiSchedule.dart';

class DetailPaketPage extends StatefulWidget {
  final String hospitalName;
  const DetailPaketPage({super.key, required this.hospitalName});

  @override
  State<DetailPaketPage> createState() => _DetailPaketPageState();
}

class _DetailPaketPageState extends State<DetailPaketPage> {
  int _selectedPaket = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Paket',
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paket Pengecekan Alergi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Temukan paket yang paling sesuai dengan kebutuhanmu',
                style: TextStyle(color: Colors.grey),
              ),
              // const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPaket = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: _selectedPaket == index
                              ? Colors.blue[100]
                              : Colors.white,
                          border: Border.all(
                            color: _selectedPaket == index
                                ? Colors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paket ${String.fromCharCode(65 + index)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${_getPaketHarga(index)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _getPaketDetails(index),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CekAlergiSchedule(choosenPaket: 'Paket ${String.fromCharCode(65 + _selectedPaket)}', harga: _getPaketHarga(_selectedPaket), hospital: widget.hospitalName,)
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(71, 116, 186, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  String _getPaketHarga(int index) {
    switch (index) {
      case 0:
        return '1.500.000';
      case 1:
        return '1.000.000';
      case 2:
        return '700.000';
      default:
        return '';
    }
  }

  Widget _getPaketDetails(int index) {
    switch (index) {
      case 0:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 1x pengecekan lewat tes darah'),
            Text('• 1x pengecekan lewat tes kulit'),
          ],
        );
      case 1:
        return const Text('• 1x pengecekan lewat tes kulit');
      case 2:
        return const Text('• 1x pengecekan lewat tes darah');
      default:
        return Container();
    }
  }
}
