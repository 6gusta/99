import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'preferencias_tela.dart';
import 'facial_recognition_page.dart';
import 'dart:typed_data';// Necessário para os bytes da imagem no Web

import 'package:image_picker/image_picker.dart';

enum StatusConexao {
  conectar,
  carregando,
  buscando,
}
class UserData {
  String name;
  String phone;
  String email;
  String city;
  Uint8List? image;
  String tipoVeiculo;

  UserData({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
      this.image,
      this.tipoVeiculo = 'MOTO',
  });
}

  UserData currentUser = UserData(
  name: "MARCOS",
  phone: "91984215974",
  email: "maxcontas1829@gmail.com",
  city: "Fortaleza",
  image: null,
  tipoVeiculo: 'MOTO',
);



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '99 Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'SFPro',
            dividerColor: Colors.grey[300],
            // Cores personalizadas para o texto no modo claro
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              bodyMedium: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          
          
      home: const SplashScreen(),
    );
  }
}

  

// ==========================================
// 1. TELA DE ABERTURA FIEL (SPLASH SCREEN)
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mantém a tela travada por 3 segundos antes de redirecionar
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo idêntica ao fundo da imagem para não dar "recorte" nas bordas
      backgroundColor: const Color(0xFFF49302), 
      body: Center(
        child: Image.asset(
          'assets/imagens/99.jpeg', // <-- Caminho da sua imagem salva nos assets
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover, // Faz a imagem preencher a tela inteira igual ao print
        ),
      ),
    );
  }
}

// ==========================================
// 2. TELA PRINCIPAL (MAPA ATUALIZADO - image_8e2768.jpg)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  
   StatusConexao status = StatusConexao.conectar;
  bool mostrarCorrida = false;
  String nomeDrawer = "MARCOS";

@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: Container(
      width: MediaQuery.of(context).size.width * 0.85,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// 🔥 FOTO DO PERFIL (AGORA SINCRONIZADA)
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ).then((_) {
                    setState(() {}); // força atualizar quando voltar
                  });
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: currentUser.image != null
                      ? ClipOval(
                          child: Image.memory(
                            currentUser.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔥 NOME SINCRONIZADO COM currentUser
            Center(
              child: GestureDetector(
                onTap: () {
                  final controller = TextEditingController(
                    text: currentUser.name,
                  );

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Editar nome"),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Digite seu nome",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentUser.name = controller.text;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Salvar"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${currentUser.name} • 5",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.star_rounded,
                      color: Color.fromARGB(255, 30, 30, 29),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

       GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleScreen(),
                ),
              ).then((_) {
                // Quando você voltar da VehicleScreen, atualiza a tela na hora!
                setState(() {});
              });
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2344),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentUser.tipoVeiculo.trim().toUpperCase() == 'CARRO' 
                          ? "Rota 99 Carro" 
                          : "Rota 99 Moto",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              "0%",
              "Taxa de\nAceitação",
              Colors.black,
            ),
            _buildStatItem(
              "0%",
              "Taxa de\nFinalização",
              Colors.red,
            ),
          ],
        ),

        const SizedBox(height: 25),
        const Divider(height: 1),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            children: [
              _buildMenuOption('Ganhos', onTap: () {}),
              _buildMenuOption('Recompensas', onTap: () {}),
              _buildMenuOption('Indique um amigo', onTap: () {}),
              _buildMenuOption('Central de Ajuda', onTap: () {}),
              _buildMenuOption('Notificações', onTap: () {}),
              _buildMenuOption(
                'Central de Educação',
                hasNotification: true,
                onTap: () {},
              ),
              _buildMenuOption('Loja 99', onTap: () {}),
              _buildMenuOption(
                'Veículo',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehicleScreen(),
                    ),
                  );
                },
              ),
               _buildMenuOption('Preferências', onTap: () {}),
            ],
          ),
        ),
      ],
    ),
  ),
),
      body: Stack(
        children: [
          // 1. MAPA DE FUNDO
       Positioned(
  top: 0,
  left: 0,
  right: 0,
  bottom: 200, // <- altura do painel branco
  child: Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/imagens/mapa03.3.png'),
        fit: BoxFit.cover,
      ),
    ),
  ),
),

 


          // 2. BOTÃO DO MENU LATERAL (HAMBÚRGUER)
       Positioned(
  top: 50,
  left: 16,
  child: Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Botão principal
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/imagens/hamburguer.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Bolinha vermelha
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),

          // 3. BALÃO DE SALDO NO TOPO (image_8e2768.jpg)
       // 3. BALÃO DE SALDO NO TOPO (image_8e2768.jpg)
Positioned(
  top: 50,
  left: 0,
  right: 0,
  child: Center(
    child: Container(
      // 🔥 Ajustado: vertical de 8 para 5 deixa o balão achatado e elegante igual ao original
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF24253D), // Tom grafite azulado perfeito
        borderRadius: BorderRadius.circular(14), // 🔥 Aumentado de 15 para 18 para suavizar os cantos no padrão iOS
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Sombra fina e realista
            blurRadius: 4, 
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔥 Valor alterado para R$13,40 para bater com o primeiro print (mude para R$0,00 se preferir)
          const Text(
            'R\$00,0', 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 21, // 🔥 Ajustado para 19: presença ideal sem estourar o limite vertical
              fontWeight: FontWeight.w700, // Bold premium nativo
              letterSpacing: -0.3, // 🔥 Aproxima levemente os números como no app real
            ),
          ),
          
          const SizedBox(width: 4), // Pequeno recuo antes da seta
          
          // 🔥 Alinhamento fino para a seta do dropdown não ficar desalinhada verticalmente
          const Padding(
            padding: EdgeInsets.only(top: 1), 
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 16, // 🔥 Reduzido para 16 para ficar um triângulo minúsculo e idêntico
            ),
          ),
        ],
      ),
    ),
  ),
),
         //bannner 
       
  
  

          // 5. BARRA DE TRÊS BOTÕES INFERIOR
       Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: Container(
    // Espaçamento interno calibrado: menos espaço no topo para aproximar a linha de arrastar
    padding: const EdgeInsets.only(top: 10, bottom: 20, left: 16, right: 16),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32), // Curvatura bem acentuada do topo do card original
        topRight: Radius.circular(32),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, -3), // Sombra leve subindo para o mapa
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔥 1. A BARRA DE ARRASTAR (Faltava no seu e é idêntica ao app)
        Container(
          width: 38,
          height: 4.5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 16),

        // Banner promocional/Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 100,
            width: double.infinity,
            child: Image.asset(
              'assets/imagens/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16), 

        // 🔥 LINHA DOS TRÊS BOTÕES (Simetria Perfeita)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // 🔥 BOTÃO ESQUERDO: Fone de Ouvido de Suporte (Não é mais o Filtro redondo!)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferenciasTela(),
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16), // Formato Squircle idêntico
                     
                    ),
                    child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/imagens/filtro99.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
                  // Bolinha Vermelha de Notificação no local exato do print
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 10), // Espaçamento fixo entre os elementos
            
            // 🔥 BOTÃO CENTRAL: Conectar
           // 🔥 BOTÃO CENTRAL: Conectar (Calibrado Estilo iPhone/Nativo 99)
Expanded(
  child: GestureDetector(
    onTap: () async {
      if (status != StatusConexao.conectar) return;

      setState(() {
        status = StatusConexao.carregando;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FacialRecognitionPage(),
        ),
      );

      if (!mounted) return;
      setState(() {
        status = StatusConexao.buscando;
      });
    },
    child: Container(
      height: 52, // 🔥 Aumentado de 46 para 48 para dar mais presença vertical à letra maior
      decoration: BoxDecoration(
        color: const Color(0xFFFCDD06),// 🔥 Amarelo ultraluminoso calibrado das telas do iPhone
        borderRadius: BorderRadius.circular(21), // 🔥 Curvatura "squircle" mais suave típica do iOS da 99, em vez de pílula total redonda
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06), // Sombra super sutil de interface limpa
            blurRadius: 4,
            offset: const Offset(0,2),
          ),
        ],
      ),
      child: Center(
        child: status == StatusConexao.carregando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000000)),
                ),
              )
            : const Text(
                "Conectar",
               style: TextStyle(
        fontFamily: 'SFPro', // 🔥 AQUI: O mesmo nome de 'family' que você colocou no pubspec.yaml
        fontWeight: FontWeight.w700, // 🔥 AQUI: O Flutter vai buscar automaticamente o seu arquivo Bold.otf
        color: const Color(0xFF1E2124), // O grafite escuro da letra
        fontSize: 24, // Altura calibrada
        letterSpacing: -0.6, // Deixa as letras juntinhas igual ao print
      ),
              ),
      ),
    ),
  ),
),

            const SizedBox(width: 10), // Espaçamento fixo entre os elementos
            
            // 🔥 BOTÃO DIREITO: Prancheta de Histórico
            // 🔥 BOTÃO DIREITO: Prancheta de Histórico
Container(
  width: 74,
  height: 44,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
   
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16), // mesmo raio do Container
    child: Image.asset(
      'assets/imagens/prancheta.png',
      fit: BoxFit.cover,
    ),
  ),
), // <-- fecha o Container

],
), // <-- fecha o Row

],
), // <-- fecha o Column

), // <-- fecha o Container branco

), // <-- fecha o Po
        ],
      ),
    );
  }
}

  Widget _buildStatItem(String percentage, String label, Color color) {
    return Column(
      children: [
        Text(percentage, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color, height: 1.2)),
      ],
    );
  }

 Widget _buildMenuOption(String title, {bool hasNotification = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            if (hasNotification) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }


// ==========================================
// 3. TELA DE PERFIL 
// ==========================================

// 3. TELA DE PERFIL 
// ==========================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData user = currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    user.tipoVeiculo = currentUser.tipoVeiculo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(user: user),
                ),
              ).then((updatedUser) {
                if (updatedUser != null) {
                  setState(() {
                    user = updatedUser;
                  });
                }
              });
            },
            child: const Text(
              'Configurações',
              style: TextStyle(
                color: Colors.black38, // Cinza suave do botão superior
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Foto de Perfil
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFFE0E0E0), // Fundo cinza suave do círculo
                backgroundImage: user.image != null ? MemoryImage(user.image!) : null,
                child: user.image == null
                    ? const Icon(Icons.person, size: 65, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // Nome do usuário sempre em caixa alta (uppercase) para imitar a imagem
            Text(
              user.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 16),

            // Botão Ver Perfil Público
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Ver perfil público',
                style: TextStyle(
                  color: Colors.black87, // Mudado para preto nítido
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // Contadores de Corridas e Dias
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCounter('0', 'Corridas'),
                _buildInfoCounter('1', 'Dia'),
              ],
            ),

            const SizedBox(height: 50),

            // Seção de Estrelas e Boas-Vindas da Conta Nova
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // As 5 estrelas horizontais
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Texto de Avaliação
                  const Text(
                    'Avaliação 5.00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 14),
                  
                  // Mensagem de incentivo da conta nova
                  const Text(
                    'Comece sua jornada! Cada solicitação é um passo em direção às 5 estrelas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87, // Cinza bem escuro e legível
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget dos contadores ajustado com as cores corretas e nítidas
  Widget _buildInfoCounter(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 28, // Números ligeiramente maiores
            fontWeight: FontWeight.bold, 
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45, // Cor cinza correta da primeira imagem
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
// ==========================================
// 4. TELA: CONFIGURAÇÕES
// ==========================================
class SettingsScreen extends StatelessWidget {
  final UserData user;

  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    void abrirEdicao() async {
      final updatedUser = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(user: user),
        ),
      );

      if (updatedUser != null) {
        Navigator.pop(context, updatedUser);
      }
    }
    Widget itemConfig({required Widget child}) {
      return Material(
        color: Colors.white,
        child: child,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          // --- SEÇÃO 1: INFORMAÇÕES PESSOAIS ---
           const Padding(
      padding: EdgeInsets.only(left: 16.0, top: 24.0, bottom: 12.0),
      child: Text(
        'Informações pessoais',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
      Material(
      color: Colors.white,
      child: Column(
        children: [

          ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
  radius: 20,
  backgroundColor: Colors.grey[300],
  backgroundImage: user.image != null
      ? MemoryImage(user.image!)
      : null,
  child: user.image == null
      ? const Icon(Icons.person, size: 20, color: Colors.white)
      : null,
),
            title: const Text('Foto de perfil'),
            trailing: const Icon(Icons.chevron_right, color: Colors.black26),
            onTap: abrirEdicao,
          ),
               const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFEEEEEE)),

                // Número de Telefone
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: Colors.black54),
                  title: Row(
                    children: [
                      const Text('Número de telefone ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                      const Text(
                        '(Confirmar Numero)',
                        style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Text(user.phone, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: abrirEdicao,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // E-mail
                ListTile(
                  leading: const Icon(Icons.mail_rounded, color: Colors.black54),
                  title: const Text('E-mail', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(user.email, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: abrirEdicao,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Cidade
                ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Colors.black54),
                  title: const Text('Cidade', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(user.city, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: abrirEdicao,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Senha
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.black54),
                  title: const Text('Senha', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // --- SEÇÃO 2: GERENCIAMENTO DE PERFIL ---
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0, bottom: 12.0),
            child: Text(
              'Gerenciamento de perfil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.assignment_outlined, color: Colors.black54),
                  title: const Text('Documentos pendentes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                ListTile(
                  leading: const Icon(Icons.important_devices_outlined, color: Colors.black54),
                  title: const Text('Gestão de dispositivo', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ==========================================
// TELA: EDITAR PERFIL (AGORA COM ADICIONAR FOTO)
// ==========================================
class EditProfileScreen extends StatefulWidget {
  final UserData user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController cityCtrl;
Uint8List? webImage;
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.name);
    phoneCtrl = TextEditingController(text: widget.user.phone);
    emailCtrl = TextEditingController(text: widget.user.email);
    cityCtrl = TextEditingController(text: widget.user.city);
  }

    Future<void> selecionarFoto() async {
    final ImagePicker picker = ImagePicker();
    
    // Abre a janela do computador para escolher o arquivo
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Lê os bytes da imagem (método correto para Flutter Web)
      var f = await image.readAsBytes();
      setState(() {
        webImage = f; // Salva os bytes na variável para atualizar a tela
      });
    }
  }

  @override
  Widget build(BuildContext context) {
            return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // 👇 BOTÃO INTERATIVO DE EDITAR FOTO (Igual apps profissionais)
            GestureDetector(
              onTap: selecionarFoto,
              child: Stack(
                children: [
                  // 👇 REMOVIDO o "const" daqui de antes do CircleAvatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey, 
                    // 👇 SE tiver imagem escolhida, mostra ela. SENÃO, mostra um ícone padrão.
                    backgroundImage: webImage != null 
                        ? MemoryImage(webImage!) 
                        : null,
                    child: webImage == null 
                        ? const Icon(Icons.person, size: 50, color: Colors.grey) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nome")),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Telefone")),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 12),
            TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: "Cidade")),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  currentUser = UserData(
                    name: nameCtrl.text,
                    phone: phoneCtrl.text,
                    email: emailCtrl.text,
                    city: cityCtrl.text,
                    image: webImage,
                  );

                  Navigator.pop(context, currentUser);
                },
                child: const Text("Salvar", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// ==========================================
// 5. TELA: VEÍCULO ESTATICA



// ==========================================
// 5. TELA: VEÍCULO ESTATICA (COM EDIÇÃO COMPLETA)
// ==========================================
class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}
class _VehicleScreenState extends State<VehicleScreen> {
  late String tipoVeiculo; 
  late String placa;
  late String modelo;

  @override
  void initState() {
    super.initState();
    // Busca os dados iniciais direto da sua variável global
    tipoVeiculo = currentUser.tipoVeiculo; 
    placa = 'SZJ-IA40';
    modelo = 'HONDA-CG 160 START (PRETA)';
  }

  void _editarVeiculo() {
    final tipoController = TextEditingController(text: tipoVeiculo);
    final placaController = TextEditingController(text: placa);
    final modeloController = TextEditingController(text: modelo);
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar veículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo do Veículo (MOTO / CARRO)',
                  hintText: 'MOTO ou CARRO',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            // BOTÃO SALVAR DE VOLTA PARA FAZER A MÁGICA!
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tipoVeiculo = tipoController.text.trim().toUpperCase();
                  placa = placaController.text;
                  modelo = modeloController.text;
                });
                // Sincroniza com a variável global para atualizar o perfil
                currentUser.tipoVeiculo = tipoVeiculo;
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Veículo',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // 📜 1. Camada de Rolagem com o Card Branco
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: _editarVeiculo,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEBF0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tipoVeiculo,
                              style: const TextStyle(
                                color: Color(0xFF8E8E93),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Text(
                            'Aprovado',
                            style: TextStyle(
                              color: Color(0xFF27AE60),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            placa,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2C2C2E),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modelo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
                      const SizedBox(height: 22),
                      
                      // 🟢 Tag "Veículo ativo"
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Veículo ativo',
                                  style: TextStyle(
                                    color: Color(0xFF137333),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🟡 2. Camada do Botão Fixo (Filho direto da Stack)
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD100),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Adicionar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ], // Fecha os children da Stack
      ), // Fecha o Stack
    ); // Fecha o Scaffold
  } // Fecha o método build
} // Fecha a classe State