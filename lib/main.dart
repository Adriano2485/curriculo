import 'package:flutter/material.dart';

void main() {
  runApp(const CurriculumApp());
}

class CurriculumApp extends StatelessWidget {
  const CurriculumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Curriculum Vitae',
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: const SplashOne(),
    );
  }
}

// ================= TRANSIÇÃO VIRAR PÁGINA =================
Route pageTurnRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final rotate = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );

      return AnimatedBuilder(
        animation: rotate,
        child: child,
        builder: (context, child) {
          final angle = rotate.value * 3.1416 / 2;

          return Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: child,
          );
        },
      );
    },
  );
}

// ================= SPLASH 1 =================
class SplashOne extends StatefulWidget {
  const SplashOne({super.key});

  @override
  State<SplashOne> createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> {
  late Future<void> _loadAssets;

  @override
  void initState() {
    super.initState();
    _loadAssets = _preload();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        pageTurnRoute(const SplashTwo()),
      );
    });
  }

  Future<void> _preload() async {
    await precacheImage(
      const AssetImage('assets/background.jpg'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAssets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const SplashLayout(text: 'Curriculum Vitae');
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ================= SPLASH 2 =================
class SplashTwo extends StatefulWidget {
  const SplashTwo({super.key});

  @override
  State<SplashTwo> createState() => _SplashTwoState();
}

class _SplashTwoState extends State<SplashTwo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        pageTurnRoute(const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashLayout(text: 'Por Adriano Pereira');
  }
}

// ================= SPLASH LAYOUT =================
class SplashLayout extends StatelessWidget {
  final String text;
  const SplashLayout({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.55),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= HOME =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: const [
            MenuTile(title: 'Dados Pessoais', screen: DadosPessoaisScreen()),
            MenuTile(title: 'Perfil Profissional', screen: PerfilScreen()),
            MenuTile(title: 'Formação Acadêmica', screen: FormacaoScreen()),
            MenuTile(
                title: 'Experiência Profissional', screen: ExperienciaScreen()),
            MenuTile(title: 'Competências', screen: CompetenciasScreen()),
            MenuTile(title: 'Contato', screen: ContatoScreen()),
          ],
        ),
      ),
    );
  }
}

// ================= MENU TILE =================
class MenuTile extends StatefulWidget {
  final String title;
  final Widget screen;

  const MenuTile({super.key, required this.title, required this.screen});

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered != value) {
      setState(() => _hovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _setHovered(true),
        onPointerMove: (_) => _setHovered(true),
        onPointerUp: (_) => _setHovered(false),
        onPointerCancel: (_) => _setHovered(false),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            pageTurnRoute(widget.screen),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _hovered
                  ? const Color(0xFFFF9800).withOpacity(0.9)
                  : const Color(0xFF999EA3).withOpacity(0.75),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _hovered ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= BACKGROUND =================
class BackgroundScaffold extends StatelessWidget {
  final Widget child;
  const BackgroundScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.45),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ================= INFO CARD =================
class InfoCard extends StatelessWidget {
  final Widget child;

  const InfoCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF999EA3).withOpacity(0.75),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
          topRight: Radius.circular(7),
          bottomLeft: Radius.circular(7),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ================= BASE SCREEN =================
class BaseScreen extends StatelessWidget {
  final String title;
  final String content;

  const BaseScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                '← Voltar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= TELAS =================
class DadosPessoaisScreen extends StatefulWidget {
  const DadosPessoaisScreen({super.key});

  @override
  State<DadosPessoaisScreen> createState() => _DadosPessoaisScreenState();
}

class _DadosPessoaisScreenState extends State<DadosPessoaisScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Stack(
        children: [
          // ---------------- CONTEÚDO NORMAL ----------------
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '← Voltar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Stack(
                  children: [
                    InfoCard(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 90),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Dados Pessoais',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '#NOME:\nAdriano Santos Pereira\n#ENDEREÇO:\nRua Eunice Weaver 200, apt 812, Carlos Chagas\n#IDADE: 40 anos\n#ESTADO CIVIL:\nSolteiro\nFilhos: 2',
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // FOTO PEQUENA NO CARD
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => setState(() => _expanded = true),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: AssetImage('assets/profile.jpg'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------- OVERLAY CENTRAL ----------------
          if (_expanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _expanded = false),
                child: Container(
                  color: Colors.black.withOpacity(0.65),
                  child: Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: 2.0, // DOBRO DO TAMANHO
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: const DecorationImage(
                            image: AssetImage('assets/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Perfil Profissional',
      content:
          'Atuação colaborativa em equipe, com foco na otimização dos processos e na eficiência da execução das rotinas. Capacidade de analisar o contexto de forma ampla, organizando atividades e responsabilidades diárias de maneira estratégica e alinhada aos objetivos da empresa. Comprometimento com o aprimoramento contínuo, buscando constante atualização frente a normas, boas práticas e mudanças de cenário, visando evolução profissional e melhoria dos resultados.',
    );
  }
}

class FormacaoScreen extends StatelessWidget {
  const FormacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Formação Acadêmica',
      content:
          '• Ensino Médio completo\n• Graduação em Análise e Desenvolvimentos de Sistemas em andamento, via EAD.',
    );
  }
}

class ExperienciaScreen extends StatelessWidget {
  const ExperienciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Experiência Profissional',
      content:
          'Atuação na área de panificação desde os 15 anos de idade, com experiência consolidada ao longo dos anos e registro CLT a partir de 2009, desenvolvendo competências técnicas, operacionais e de organização de produção.\n• PADARIA REGIANE:\nPeríodo: 02/02/2009 a 02/06/2010\nCargo: Padeiro\nRotina: Produção de massas pão francês e suas variedades, massas doces e confeitaria básica.\n•BOCA VIÇOSA:\nPeríodo: 05/08/2010 a 30/06/2012\nCargo: Padeiro\nRotina: Produção de massas pão francês e suas variedades, massas doces, massas folhadas, massas caseiras com receita própria, confeitaria fina.\n•PIZZARIA PAULISTANA:\nPeríodo: 14/02/2014 a 17/08/2014 e 18/02/2015 a 02/08/2015\nCargo: Pizzaiolo\nRotina: Produção de massas, recheios, montagem, forneamento, organização do setor, auxílio em pedidos e estocagem.\n•GULA MIX:\nPeríodo: 04/01/2016 a 15/03/2017\nCargo: Pizzaiolo\nRotina: Produção de massas, recheios, montagem, forneamento, organização do setor, auxílio em pedidos e estocagem.\n•MARQESPAN/TRIGO ARTE E CIA:\nPeríodo: 19/02/2018 - em aberto.\nCargo: Técnico Panificação 2\nRotina: Treinamento da equipe em relação aos produtos congelados, auxílio na produção, controle de estoque e pedidos, manutenção de limpeza dos equipamentos, organização e precificação do PDV, estratégias de vendas com base em relatórios e rotina programada.',
    );
  }
}

class CompetenciasScreen extends StatelessWidget {
  const CompetenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Competências',
      content:
          '• Comunicação\n• Liderança\n• Organização\n• Trabalho em equipe',
    );
  }
}

class ContatoScreen extends StatelessWidget {
  const ContatoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Contato',
      content: 'Email: adrianosptac@gmail.com\nTelefone: (32) 99855-5194',
    );
  }
}
