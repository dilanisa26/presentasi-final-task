part of 'pages.dart';

class EditMemberPage extends StatefulWidget {
  final Member member;

  const EditMemberPage({super.key, required this.member});

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  // Controller untuk field input
  late TextEditingController _nomorIndukController;
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;

  late int id;
  late int _selectedStatus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    id = widget.member.id;
    _nomorIndukController =
        TextEditingController(text: widget.member.nomorInduk.toString());
    _namaController = TextEditingController(text: widget.member.name);
    _alamatController = TextEditingController(text: widget.member.alamat);
    _teleponController = TextEditingController(text: widget.member.telepon);
    _selectedStatus = widget.member.statusAktif;
    _selectedDate = DateTime.tryParse(widget.member.tanggalLahir);
  }

  @override
  void dispose() {
    _nomorIndukController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void goEditMember() async {
    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/$id',
        data: {
          'nomor_induk': _nomorIndukController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _selectedDate != null ? _selectedDate!.toString() : '',
          'telepon': _teleponController.text,
          'status_aktif': _selectedStatus,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );

      Navigator.pushNamed(context, '/profile');
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Update failed. Please check your data or login again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Member',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6582AE),
      ),
      body: Container(
        color: Color(0xFFF5ECED),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField('Nomor Induk', _nomorIndukController),
                const SizedBox(height: 20.0),
                _buildTextField('Nama', _namaController, readOnly: true),
                const SizedBox(height: 20.0),
                _buildTextField('Nama Ibu', _alamatController),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                            : '',
                      ),
                      decoration: _buildInputDecoration('Tanggal Lahir'),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField('Telepon', _teleponController),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedStatus,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedStatus = value ?? _selectedStatus;
                        });
                      },
                    ),
                    const Text('Aktif'),
                    Radio(
                      value: 0,
                      groupValue: _selectedStatus,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedStatus = value ?? _selectedStatus;
                        });
                      },
                    ),
                    const Text('Non-Aktif'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('Cancel', Colors.red, () {
                      Navigator.pushNamed(context, '/profile');
                    }),
                    _buildButton('Update', Color(0xFF6582AE), goEditMember),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: _buildInputDecoration(label),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF6582AE)),
      filled: true,
      fillColor: Color(0xFFE2DAD7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF7FA1C4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF7FA1C4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF6582AE)),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(120, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
