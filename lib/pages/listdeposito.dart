part of 'pages.dart';

class ListDepositoPage extends StatelessWidget {
  const ListDepositoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendeklarasikan depositoList dalam build method
    final List<Map<String, dynamic>> depositoList = [
      {
        'id': 'D001',
        'name': 'Mini',
        'minAmount': 1000000,
        'maxAmount': 5000000,
        'bonus': '2%',
      },
      {
        'id': 'D002',
        'name': 'Maxi',
        'minAmount': 5000000,
        'maxAmount': 10000000,
        'bonus': '2.5%',
      },
      {
        'id': 'D003',
        'name': 'Great',
        'minAmount': 10000000,
        'maxAmount': 20000000,
        'bonus': '3%',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Deposito',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
             Navigator.pushNamed(context, '/deposito'); // Arahkan ke halaman AddBungaPage
          },
        ),
        // actions: [
        //   // Tombol untuk navigasi ke halaman AddBungaPage
        //   IconButton(
        //     icon: const Icon(Icons.add, color: Colors.white),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/addbunga'); // Arahkan ke halaman AddBungaPage
        //     },
        //   ),
        // ],
        backgroundColor: const Color(0xFF6582AE), // Warna AppBar #6582AE
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: depositoList.length,
                itemBuilder: (context, index) {
                  var deposito = depositoList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFFE2DAD7), // Warna Card #E2DAD7
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        deposito['name'] ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF6582AE), // Warna teks nama deposito #6582AE
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonus: ${deposito['bonus'] ?? 'N/A'}',
                            style: TextStyle(
                              color: const Color(0xFF7FA1C4), // Warna teks bonus #7FA1C4
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Min Amount: ${deposito['minAmount']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black, // Warna teks bold untuk jumlah minimum
                            ),
                          ),
                          Text(
                            'Max Amount: ${deposito['maxAmount']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black, // Warna teks bold untuk jumlah maksimum
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        'ID: ${deposito['id']}',
                        style: TextStyle(
                          color: const Color(0xFF7FA1C4), // Warna teks ID #7FA1C4
                        ),
                      ),
                      onTap: () {
                        // Navigasi ke halaman detail deposito
                        Navigator.pushNamed(
                          context,
                          '/detail-deposito',
                          arguments: deposito,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
