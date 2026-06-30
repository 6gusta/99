import 'package:flutter/material.dart';

class StatusTestPage extends StatefulWidget {
  const StatusTestPage({super.key});

  @override
  State<StatusTestPage> createState() => _StatusTestPageState();
}

class _StatusTestPageState extends State<StatusTestPage> {
  // cor verde do print
  static const Color verde = Color(0xFF1BC47D);

  final List<String> itens = [
    "Status de internet",
    "Localização",
    "Status do perfil",
    "Análise de documentos",
    "Status da solicitação",
    "Configurações da solicitação",
  ];

  int progresso = 0;
  bool executando = false;

  @override
  void initState() {
    super.initState();
    iniciarTeste();
  }

  Future<void> iniciarTeste() async {
    if (executando) return;
    executando = true;

    for (int i = 0; i < itens.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        progresso++;
      });
    }

    executando = false;
  }

  @override
  Widget build(BuildContext context) {
    final porcentagem = progresso / itens.length;
    final concluido = progresso == itens.length;

    return Scaffold(
      // 🔥 fundo em degradê azul claro igual ao original
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDDEBEA), Color(0xFFF8FBFB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 topo com seta e título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Teste de status",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⭕ círculo de progresso
              Center(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: porcentagem,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round, // 🔥 pontas arredondadas
                          backgroundColor: Colors.white,
                          color: verde,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            concluido ? "Perfeito" : "$progresso/${itens.length}",
                            style: TextStyle(
                              fontSize: concluido ? 40 : 58,
                              fontWeight: FontWeight.bold,
                              color: concluido ? verde : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            concluido ? "Melhor status!" : "Testando",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 📋 lista de itens (sem card, direto no fundo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: List.generate(itens.length, (index) {
                    // define o estado do item
                    final bool feito = index < progresso;
                    final bool atual = index == progresso;

                    // cor do texto conforme o estado
                    Color corTexto;
                    FontWeight peso;
                    if (feito) {
                      corTexto = verde;
                      peso = FontWeight.w500;
                    } else if (atual) {
                      corTexto = Colors.black;
                      peso = FontWeight.bold;
                    } else {
                      corTexto = Colors.grey;
                      peso = FontWeight.w500;
                    }

                    // ícone da direita conforme o estado
                    Widget icone;
                    if (feito) {
                      icone = Icon(Icons.check_circle_outline,
                          color: verde, size: 26);
                    } else if (atual) {
                      icone = const Icon(Icons.power_settings_new,
                          color: Colors.black, size: 26);
                    } else {
                      icone = const Icon(Icons.access_time,
                          color: Colors.grey, size: 26);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itens[index],
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: peso,
                                color: corTexto,
                              ),
                            ),
                          ),
                          icone,
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}