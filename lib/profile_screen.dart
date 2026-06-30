import 'package:flutter/material.dart';
// Se a SettingsScreen estiver em outro arquivo, importe ela aqui:
// import 'settings_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text('Perfil', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            const Text('MARCOS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 15),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              onPressed: () {},
              child: const Text('Ver perfil público', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCounter('0', 'Corridas'),
                _buildInfoCounter('1', 'Dia'),
              ],
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text('Avaliação 0.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(width: 5),
                          Icon(Icons.star, color: Colors.amber, size: 22),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text('Como funciona', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                            Icon(Icons.chevron_right, color: Colors.grey[600], size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text('Média das 100 últimas avaliações de corridas', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 25),
                  _buildStarRow('5', 0.0),
                  _buildStarRow('4', 0.0),
                  _buildStarRow('3', 0.0),
                  _buildStarRow('2', 0.0),
                  _buildStarRow('1', 0.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCounter(String number, String label) {
    return Column(
      children: [
        Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildStarRow(String stars, double filling) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(stars, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(width: 8),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: filling,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Text('0', style: TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }
}

// Criado apenas para não dar erro de compilação no exemplo:
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Configurações')));
}