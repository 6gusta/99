import 'package:flutter/material.dart';
import 'status_test_page.dart';

class PreferenciasTela extends StatefulWidget {
  const PreferenciasTela({super.key});

  @override
  State<PreferenciasTela> createState() => _PreferenciasTelaState();
}

class _PreferenciasTelaState extends State<PreferenciasTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Fundo levemente cinza do app
      appBar: AppBar(
        backgroundColor: const Color(0xFF21222A), // Cor escura idêntica à original
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preferências de solicitações',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEÇÃO 1: FERRAMENTAS DE ACEITAÇÃO ---
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
              child: Text(
                'Ferramentas de aceitação',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
  leading: Image.asset(
    'imagens/preferencias/sorriso2.png',
    width: 28,
    height: 34,
      fit: BoxFit.contain,
    
  ),
  title: const Text(
    'Definir meu destino',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
  ),
  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
  onTap: () {},
),
                  const Divider(height: 1, indent: 56, color: Color(0xFFEAEAEA)),
                 ListTile(
  leading: Image.asset(
    'imagens/preferencias/triangulo2.png', // 👈 caminho do seu PNG
    width: 24,
    height: 24,
    fit: BoxFit.contain, // remova se a imagem for colorida
  ),
  title: const Text('Preferências de serviços', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
  trailing: SizedBox(
    width: 30,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.redAccent, // Bolinha vermelha de notificação
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
      ],
    ),
  ),
  onTap: () {},
),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // --- SEÇÃO 2: STATUS DA SOLICITAÇÃO ---
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
              child: Text(
                'Status da solicitação',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Column(
                children: [
  ListTile(
    leading: Image.asset(
      'imagens/preferencias/velocimetro.png', // caminho do seu PNG
      width: 24,
      height: 24,
      fit: BoxFit.cover,// tinge de preto (só p/ PNG preto + fundo transparente)
    ),
    title: const Text(
      'Teste de status',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StatusTestPage(),
        ),
      );
    },
  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFEAEAEA)),
                  ListTile(
  leading: Image.asset(
    'imagens/preferencias/grafico2.png', // caminho do seu PNG
    width: 24,
    height: 24,
    fit: BoxFit.contain, // tinge de preto (só p/ PNG preto + fundo transparente)
  ),
  title: const Text(
    'Eventos futuros',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
  ),
  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black38),
  onTap: () {},
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}