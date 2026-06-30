import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FacialRecognitionPage extends StatefulWidget {
  const FacialRecognitionPage({super.key});

  @override
  State<FacialRecognitionPage> createState() => _FacialRecognitionPageState();
}

class _FacialRecognitionPageState extends State<FacialRecognitionPage>
    with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  
  // Nova animação para controlar o preenchimento da barra azul ao redor do rosto
  late AnimationController _progressController;

  CameraController? _controller;
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();

    // Controlador para a linha de scanner azul subindo e descendo
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(
      begin: -110,
      end: 110,
    ).animate(
      CurvedAnimation(
        parent: _scannerController,
        curve: Curves.easeInOut,
      ),
    );

    // Controlador do progresso da barra azul (vai de 0.0 a 1.0 em 12 segundos)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    iniciarCamera();
    ejecutarReconhecimento();
  }

  Future<void> iniciarCamera() async {
    final cameras = await availableCameras();
    
    // Buscando especificamente a câmera frontal para bater com o caso de uso
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (!mounted) return;

    setState(() {
      _cameraReady = true;
    });
  }

  Future<void> ejecutarReconhecimento() async {
    // Inicia a animação da barra azul ao redor do círculo
    _progressController.forward();

    // Espera os mesmos 12 segundos do preenchimento
    await Future.delayed(const Duration(seconds: 12));

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _progressController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo completamente branco para bater com o print original
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Reconhecimento facial",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // O container do círculo e animações
            AnimatedBuilder(
              animation: Listenable.merge([
                _scannerController,
                _progressController,
              ]),
              builder: (context, child) {
                return SizedBox(
                  width: 270,
                  height: 270,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      // 1. Câmera cortada em Círculo Perfeito
                      ClipOval(
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: _cameraReady && _controller != null
                              ? CameraPreview(_controller!)
                              : Container(
                                  color: Colors.grey.shade300,
                                ),
                        ),
                      ),

                      // 2. Barra de progresso azul fixa/crescente ao redor (Substitui o anel giratório antigo)
                      CustomPaint(
                        size: const Size(256, 256),
                        painter: ProgressCirclePainter(
                          progress: _progressController.value,
                        ),
                      ),

                      // 3. Scanner de Linha Azul Horizontal (efeito laser)
                      ClipOval(
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 120 + _scannerAnimation.value,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.withOpacity(0.0),
                                        Colors.blue.withOpacity(0.8),
                                        Colors.blue.withOpacity(0.8),
                                        Colors.blue.withOpacity(0.0),
                                      ],
                                      stops: const [0.0, 0.4, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Título Principal
            const Text(
              "Olhe diretamente para a câmera",
              style: TextStyle(
                color: Color(0xFF111625),
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Subtítulo em itálico rosa/magenta
            const Text(
              "Olhe diretamente para a câmera",
              style: TextStyle(
                color: Color(0xFFD65B88), // Tom de rosa idêntico ao do print
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 50),

            // Loading circular inferior mais suave
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NOVO PAINTER: Desenha o fundo cinza claro e o arco azul que carrega por cima
class ProgressCirclePainter extends CustomPainter {
  final double progress;

  ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Desenha o fundo cinza bem fininho que aparece no print original
    final basePaint = Paint()
      ..color = const Color(0xFFE5E9F0)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, basePaint);

    // 2. Desenha o progresso azul por cima
    final progressPaint = Paint()
      ..color = const Color(0xFF2B66FF) // Azul vivo do print
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Pontas arredondadas igual na imagem

    // -math.pi / 2 faz o carregamento começar exatamente no topo (12 horas)
    double startAngle = -math.pi / 2;
    double sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}