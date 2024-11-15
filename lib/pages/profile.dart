
part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  String _id = '';
  String _name = '';
  String _email = '';
  String _noInduk = '';
  String _ibuKandung = '';
  String _jenisKelamin = '';
  String _tanggalLahir = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    goUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6582AE),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xFFF5ECED),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6582AE)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _email,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildProfileText('ID: $_id'),
                    _buildProfileText('No Induk: $_noInduk'),
                    _buildProfileText('Nama Ibu Kandung: $_ibuKandung'),
                    _buildProfileText('Jenis Kelamin: $_jenisKelamin'),
                    _buildProfileText('Tanggal Lahir: $_tanggalLahir'),
                    const SizedBox(height: 30),

                    // Tombol Edit Profil
                    _buildActionButton('Edit Profile', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMemberPage(
                            member: Member(
                              id: int.tryParse(_id) ?? 0,
                              nomorInduk: int.tryParse(_noInduk) ?? 0,
                              name: _name,
                              alamat: _ibuKandung,
                              telepon: '',
                              tanggalLahir: _tanggalLahir,
                              statusAktif: 1,
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Tombol Edit Password
                    _buildActionButton('Edit Password', () {
                      Navigator.pushNamed(context, '/editpassword');
                    }),

                    const SizedBox(height: 20),

                    // Tombol Logout
                    _buildActionButton('Logout', () {
                      goLogout(context);
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Color(0xFF6582AE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void goUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/user',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        Map<String, dynamic> userData = responseData['data']['user'];

        setState(() {
          _id = userData['id']?.toString() ?? 'Unknown';
          _name = userData['name'] ?? 'No Name Provided';
          _email = userData['email'] ?? 'No Email Provided';
          _noInduk = userData['no_induk'] ?? 'No Induk Not Available';
          _ibuKandung = userData['ibu_kandung'] ?? 'Mother\'s name not provided';
          _jenisKelamin = userData['jenis_kelamin'] ?? 'Unknown';
          _tanggalLahir = userData['tanggal_lahir'] ?? 'Date of Birth not provided';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token expired. Please login again')),
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void goLogout(BuildContext context) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      await _storage.remove('token');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on DioException catch (e) {
      await _storage.remove('token');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
}
