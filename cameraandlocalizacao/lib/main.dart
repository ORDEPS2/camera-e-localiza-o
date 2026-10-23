
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const DragonBallApp());
}

const Color azul = Color(0xFF1676C5);
const Color azulEscuro = Color(0xFF10477D);
const Color laranja = Color(0xFFFF8417);
const Color amarelo = Color(0xFFFFD83D);
const Color fundo = Color(0xFFFFF5D9);

class DragonBallApp extends StatelessWidget {
  const DragonBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dragon Ball Adventure',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: azul,
          primary: azul,
          secondary: laranja,
        ),
      ),
      home: const TelaPerfil(),
    );
  }
}

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  File? foto;

  final ImagePicker picker = ImagePicker();
  final TextEditingController nomeController =
      TextEditingController();

  String nome = 'Novo Aventureiro';
  String localizacao = 'Nenhuma localização encontrada';

  bool localizacaoObtida = false;
  bool buscandoLocalizacao = false;

  Future<void> escolherFoto(ImageSource origem) async {
    try {
      final imagem = await picker.pickImage(
        source: origem,
        imageQuality: 85,
      );

      if (imagem != null && mounted) {
        setState(() {
          foto = File(imagem.path);
        });
      }
    } catch (_) {
      if (!mounted) return;

      mensagem('Não foi possível abrir a imagem.');
    }
  }

  void salvarNome() {
    final novoNome = nomeController.text.trim();

    if (novoNome.isEmpty) {
      mensagem('Digite seu nome de aventureiro!');
      return;
    }

    setState(() {
      nome = novoNome;
    });

    FocusScope.of(context).unfocus();
    mensagem('Nome do aventureiro atualizado!');
  }

  void removerFoto() {
    setState(() {
      foto = null;
    });

    mensagem('Foto removida.');
  }

  Future<void> obterLocalizacao() async {
    setState(() {
      buscandoLocalizacao = true;
      localizacaoObtida = false;
      localizacao = 'Procurando sua posição...';
    });

    try {
      final servicoAtivo =
          await Geolocator.isLocationServiceEnabled();

      if (!servicoAtivo) {
        atualizarErro('Ative o GPS do dispositivo.');
        return;
      }

      LocationPermission permissao =
          await Geolocator.checkPermission();

      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied) {
        atualizarErro('Permissão de localização negada.');
        return;
      }

      if (permissao == LocationPermission.deniedForever) {
        atualizarErro(
          'Permissão bloqueada. Libere nas configurações.',
        );
        return;
      }

      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        localizacao =
            'Latitude: ${posicao.latitude.toStringAsFixed(4)}\n'
            'Longitude: ${posicao.longitude.toStringAsFixed(4)}';

        localizacaoObtida = true;
        buscandoLocalizacao = false;
      });
    } catch (_) {
      atualizarErro(
        'Não foi possível obter a localização.',
      );
    }
  }

  void atualizarErro(String mensagemErro) {
    if (!mounted) return;

    setState(() {
      localizacao = mensagemErro;
      localizacaoObtida = false;
      buscandoLocalizacao = false;
    });
  }

  void mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: azulEscuro,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8DD9FF),
              Color(0xFFFFF5D9),
              Color(0xFFFFD7A3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const SizedBox(height: 12),

                // Cabeçalho Dragon Ball
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: azul,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: azulEscuro,
                        offset: Offset(0, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.brightness_5,
                            color: amarelo,
                            size: 38,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'DRAGON BALL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: amarelo,
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(2, 3),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AVENTURA CLÁSSICA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'SUA JORNADA COMEÇA AQUI!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azulEscuro,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Monte sua ficha de aventureiro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azulEscuro,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 24),

                // Cartão do perfil
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: laranja,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x553D3018),
                        offset: Offset(0, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'FICHA DO AVENTUREIRO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: azulEscuro,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: amarelo,
                              border: Border.all(
                                color: laranja,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor:
                                  const Color(0xFFFFE8BE),
                              backgroundImage: foto != null
                                  ? FileImage(foto!)
                                  : null,
                              child: foto == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 75,
                                      color: azul,
                                    )
                                  : null,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: laranja,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        nome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: azulEscuro,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: amarelo,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'NÍVEL 1 • INICIANTE',
                          style: TextStyle(
                            color: azulEscuro,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: campoTitulo('Nome do aventureiro'),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: nomeController,
                        maxLength: 35,
                        decoration: InputDecoration(
                          hintText: 'Digite seu nome',
                          counterText: '',
                          filled: true,
                          fillColor: fundo,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: azul,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: azul,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => salvarNome(),
                      ),

                      const SizedBox(height: 12),

                      botao(
                        texto: 'SALVAR NOME',
                        icone: Icons.check_circle,
                        cor: azul,
                        acao: salvarNome,
                      ),

                      const SizedBox(height: 26),

                      divisor(),

                      const SizedBox(height: 20),

                      const Text(
                        'REGISTRE SUA AVENTURA',
                        style: TextStyle(
                          color: azulEscuro,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 16),

                      botao(
                        texto: 'TIRAR FOTO',
                        icone: Icons.camera_alt,
                        cor: laranja,
                        acao: () =>
                            escolherFoto(ImageSource.camera),
                      ),

                      const SizedBox(height: 12),

                      botao(
                        texto: 'ESCOLHER DA GALERIA',
                        icone: Icons.photo_library,
                        cor: azul,
                        acao: () =>
                            escolherFoto(ImageSource.gallery),
                      ),

                      const SizedBox(height: 12),

                      botao(
                        texto: 'REMOVER FOTO',
                        icone: Icons.delete_outline,
                        cor: azulEscuro,
                        acao: removerFoto,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Cartão da localização
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6A0),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: laranja,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x553D3018),
                        offset: Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.radar,
                            size: 34,
                            color: azulEscuro,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'RADAR DO DRAGÃO',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: azulEscuro,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Encontre sua posição no mapa da aventura.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: azulEscuro),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFB5E8A1),
                          border: Border.all(
                            color: azulEscuro,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          localizacaoObtida
                              ? Icons.location_on
                              : Icons.radar,
                          size: 66,
                          color: localizacaoObtida
                              ? Colors.green.shade800
                              : azulEscuro,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          localizacao,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: azulEscuro,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      botao(
                        texto: buscandoLocalizacao
                            ? 'PROCURANDO...'
                            : 'LOCALIZAR POSIÇÃO',
                        icone: buscandoLocalizacao
                            ? Icons.hourglass_top
                            : Icons.my_location,
                        cor: azul,
                        carregando: buscandoLocalizacao,
                        acao: obterLocalizacao,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        localizacaoObtida
                            ? 'POSIÇÃO ENCONTRADA!'
                            : 'RADAR AGUARDANDO SINAL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: localizacaoObtida
                              ? Colors.green.shade800
                              : azulEscuro,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // Esferas decorativas
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Esfera(estrelas: '★'),
                    SizedBox(width: 12),
                    Esfera(estrelas: '★★'),
                    SizedBox(width: 12),
                    Esfera(estrelas: '★★★'),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'UMA NOVA AVENTURA ESPERA POR VOCÊ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azulEscuro,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTitulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: azulEscuro,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Widget divisor() {
    return Container(
      height: 3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: amarelo,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget botao({
    required String texto,
    required IconData icone,
    required Color cor,
    required VoidCallback acao,
    bool carregando = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: carregando ? null : acao,
        icon: Icon(icone),
        label: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: azulEscuro,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class Esfera extends StatelessWidget {
  final String estrelas;

  const Esfera({
    super.key,
    required this.estrelas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 0.9,
          colors: [
            Color(0xFFFFF19B),
            Color(0xFFFFA522),
            Color(0xFFE95412),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFDA5A10),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x443D3018),
            offset: Offset(0, 3),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          estrelas,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
