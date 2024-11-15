import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage

part of 'pages.dart';

class DetailDepositoUserPage extends StatelessWidget {
  const DetailDepositoUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDepositoData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final depositoDetail = snapshot.data as Map<String, String>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Deposito User'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/deposito', (route) => false);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card for Deposit details
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  color: const Color(0xFFF5ECED),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Deposit ID', depositoDetail['deposit_id'] ?? ''),
                        _buildDetailRow('Account ID', depositoDetail['account_id'] ?? ''),
                        _buildDetailRow('Deposit Name', depositoDetail['deposit_name'] ?? ''),
                        _buildDetailRow('Amount', 'Rp ${depositoDetail['amount']}'),
                        _buildDetailRow('Min. Amount', 'Rp ${depositoDetail['min_amount']}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Delete button
              ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context, depositoDetail);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Menggunakan backgroundColor untuk warna merah
                minimumSize: const Size(double.infinity, 50), // Full width button
              ),
              child: const Text('Delete Deposito', style: TextStyle(fontSize: 18)),
            )

              ],
            ),
          ),
        );
      },
    );
  }

  // Method to build row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Function to load deposito data from storage
  Future<Map<String, String>> _loadDepositoData() async {
    final _storage = GetStorage();
    return {
      'deposit_id': 'D001', // Example static value
      'account_id': 'A001', // Example static value
      'deposit_name': _storage.read('deposit_name') ?? '',
      'amount': _storage.read('amount') ?? '',
      'min_amount': _storage.read('min_amount') ?? '',
    };
  }

  // Function to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, Map<String, String> depositoDetail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data deposito ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Handle delete action
              _deleteDeposito(depositoDetail, context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Function to delete deposito data (you can add logic to delete data from storage or API)
  void _deleteDeposito(Map<String, String> depositoDetail, BuildContext context) {
    final _storage = GetStorage();
    _storage.remove('deposit_name');
    _storage.remove('amount');
    _storage.remove('min_amount');
    
    // Optionally: Remove the deposito data from a list or database
    // Example: _depositoData.remove(depositoDetail);

    Navigator.pop(context); // Close the detail page after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data Deposito berhasil dihapus!')),
    );
  }
}
