import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(EcosDeAltheriaApp());
}

class EcosDeAltheriaApp extends StatelessWidget {
  const EcosDeAltheriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cores Originais Restauradas
    const Color originalPrimary =
        Color.fromARGB(255, 0, 0, 0); // Verde Neon/Menta
    const Color originalBackground =
        Color(0xFF0B1020); // Azul Escuro Quase Preto

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecos de Altheria',
      theme: ThemeData.dark().copyWith(
        // Cor Principal do Fundo
        scaffoldBackgroundColor: originalBackground,
        // Cor primária
        colorScheme: ColorScheme.dark(
          primary: originalPrimary,
          // Cor secundária não estava explicitamente definida, mas usamos para consistência
          secondary: originalPrimary.withOpacity(0.8),
        ),
      ),
      home: MainMenu(),
    );
  }
}

// --- ESTRUTURAS DE DADOS ---

class Character {
  String name;
  int maxHp;
  int hp;
  int attack;
  int defense;
  int potions;
  bool defended;

  Character({
    required this.name,
    required this.maxHp,
    required this.hp,
    required this.attack,
    required this.defense,
    this.potions = 2,
    this.defended = false,
  });
}

class Enemy {
  final String id;
  final String title;
  int maxHp;
  int hp;
  int attack;
  String desc;
  List<String> abilities;

  Enemy({
    required this.id,
    required this.title,
    required this.maxHp,
    required this.hp,
    required this.attack,
    required this.desc,
    required this.abilities,
  });

  String get imagePath {
    switch (id) {
      case 'sombra':
        return 'assets/sombra.png';
      case 'guardiao':
        return 'assets/golem.png';
      case 'serpente':
        return 'assets/serpente.png';
      case 'kael':
        return 'assets/Kael.png';
      case 'eco':
        return 'assets/eco.png';
      default:
        return 'assets/image.png'; // fallback
    }
  }

  String? get backgroundPath {
    switch (id) {
      case 'sombra':
        return 'assets/Sombramapa.png';
      case 'guardiao':
        return 'assets/Golemmapa.png';
      case 'serpente':
        return 'assets/Serpentemapa.png';
      case 'kael':
        return 'assets/Kaelmapa.png';
      case 'eco':
        return 'assets/Ecomapa.png';
      default:
        return null;
    }
  }
}

// Lista de inimigos (progressão sequencial: Serpente, Guardião, Eco, Sombra, Kael)
List<Enemy> defaultEnemies() => [
      // 1. Serpente da Areia Infinita
      Enemy(
        id: 'serpente',
        title: 'Serpente da Areia Infinita',
        maxHp: 100,
        hp: 100,
        attack: 18,
        desc:
            'Nasceu do deserto onde o tempo dorme — cada batida de seu coração muda o fluxo das eras.',
        abilities: ['Envelhecer'],
      ),
      // 2. Guardião do Eco
      Enemy(
        id: 'guardiao',
        title: 'Guardião do Eco',
        maxHp: 90,
        hp: 90,
        attack: 14,
        desc:
            'Antigo protetor do Cristal, agora corrompido pelo fluxo do tempo invertido.',
        abilities: ['Punho da Eternidade'],
      ),
      // 3. Sombra Fragmentada (Eco)
      Enemy(
        id: 'eco',
        title: 'Sombra Fragmentada',
        maxHp: 70,
        hp: 70,
        attack: 18,
        desc:
            'Um eco distorcido de antigos guerreiros. Lutam sem alma, presos entre segundos que nunca terminam.',
        abilities: ['Espelhar Ação'],
      ),
      // 4. Eco da Própria Liora (Sombra)
      Enemy(
        id: 'sombra',
        title: 'Eco da Própria Liora',
        maxHp: 60,
        hp: 60,
        attack: 10,
        desc:
            'Um reflexo corrompido da protagonista — nascida dos arrependimentos que ela tentou apagar',
        abilities: ['Ruptura Temporal'],
      ),
      // 5. Kael, o Devoto da Ruína
      Enemy(
        id: 'kael',
        title: 'Kael, o Devoto da Ruína',
        maxHp: 120,
        hp: 120,
        attack: 18,
        desc:
            'Aquele que vê o passado como um paraíso e o presente como um erro.',
        abilities: ['Chama Sombria', 'Reversão Total'],
      ),
    ];

// --- MENU PRINCIPAL (VÍDEO DE FUNDO) ---

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o asset do vídeo
    _controller = VideoPlayerController.asset('assets/Intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute para habilitar autoplay na web
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover, // Faz o vídeo cobrir o espaço disponível
              alignment: Alignment
                  .centerRight, // Alinha o vídeo à direita, cortando o excesso da esquerda
              child: SizedBox(
                // O SizedBox precisa ser do tamanho original do vídeo
                width: _controller.value.size?.width ?? 640,
                height: _controller.value.size?.height ?? 360,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // 2. Camada escura de sobreposição
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // 3. Overlay buttons
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => GamePage()),
                        );
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text('Iniciar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 56),
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CodexPage()),
                        );
                      },
                      icon: Icon(Icons.book),
                      label: Text('Codex'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 56),
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TELA DE GAME OVER (VÍDEO DE FUNDO) ---

class GameOverScreen extends StatefulWidget {
  final VoidCallback onRetry;
  final VoidCallback onBackToMenu;

  const GameOverScreen(
      {super.key, required this.onRetry, required this.onBackToMenu});

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o asset do vídeo de game over
    _controller = VideoPlayerController.asset('assets/gameovermechendo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute para habilitar autoplay na web
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 640,
                height: _controller.value.size?.height ?? 360,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Camada escura de sobreposição
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Overlay buttons
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onRetry,
                      child: Text('Tentar Novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: widget.onBackToMenu,
                      child: Text('Voltar ao Menu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TELA DE VITÓRIA (VÍDEO DE FUNDO) ---

class VictoryScreen extends StatefulWidget {
  final VoidCallback onRetry;
  final VoidCallback onBackToMenu;

  const VictoryScreen(
      {super.key, required this.onRetry, required this.onBackToMenu});

  @override
  _VictoryScreenState createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o asset do vídeo de vitória
    _controller = VideoPlayerController.asset('assets/Vitoria.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0); // Mute para habilitar autoplay na web
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 640,
                height: _controller.value.size?.height ?? 360,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Camada escura de sobreposição
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Overlay buttons
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onRetry,
                      child: Text('Jogar Novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: widget.onBackToMenu,
                      child: Text('Voltar ao Menu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================== EFEITOS VISUAIS ===================

class FloatingDamage extends StatefulWidget {
  final int damage;
  final bool isPlayerDamage; // Novo: para diferenciar cor/posicao
  const FloatingDamage(
      {required this.damage, this.isPlayerDamage = true, super.key});

  @override
  State<FloatingDamage> createState() => _FloatingDamageState();
}

class _FloatingDamageState extends State<FloatingDamage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctr;
  late final Animation<double> _move;
  late final Animation<double> _fade;
  late final Color _color;

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _move = Tween<double>(begin: 0, end: -40)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeOut));
    _fade = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeIn));

    // Dano no Jogador é Vermelho (padrão do código original)
    // Dano no Inimigo é Amarelo/Primary color
    _color = widget.isPlayerDamage ? Colors.redAccent : Colors.yellowAccent;

    _ctr.forward().then((_) => _ctr.dispose());
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctr,
      builder: (_, __) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(
          offset: Offset(0, _move.value),
          child: Text(
            '-${widget.damage}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _color,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
        ),
      ),
    );
  }
}

class PotionEffect extends StatefulWidget {
  final int heal;
  const PotionEffect({required this.heal, super.key});

  @override
  State<PotionEffect> createState() => _PotionEffectState();
}

class _PotionEffectState extends State<PotionEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctr;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeOut));
    _fade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _ctr, curve: Curves.easeIn));
    _ctr.forward().then((_) => _ctr.dispose());
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctr,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.9 * (1 - _fade.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.7),
                      blurRadius: 20 * (1 - _fade.value),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: _fade.value,
              child: Text(
                '+${widget.heal}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [Shadow(blurRadius: 4, color: Colors.greenAccent)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PÁGINA CODEX (BESTIÁRIO) ---

class CodexPage extends StatelessWidget {
  const CodexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final enemies = defaultEnemies();
    const Color defaultDarkSurface = Color(0xFF1E1E1E);

    return Scaffold(
      appBar: AppBar(title: Text('Bestiário')),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemBuilder: (context, idx) {
          final e = enemies[idx];
          return Card(
            color: defaultDarkSurface,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem do inimigo
                  Image.asset(
                    e.imagePath,
                    height:
                        100, // Tamanho reduzido para visualização do bestiário
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, size: 100),
                  ),
                  SizedBox(width: 12),
                  // Detalhes do inimigo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text(e.desc, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children: [
                            Chip(label: Text('HP: ${e.maxHp}')),
                            Chip(label: Text('Atk: ${e.attack}')),
                            for (var a in e.abilities) Chip(label: Text(a)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8),
        itemCount: enemies.length,
      ),
    );
  }
}

// --- PÁGINA DO JOGO (BATALHA) ---

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Character player = Character(
      name: 'Liora', maxHp: 150, hp: 150, attack: 20, defense: 8, potions: 4);
  late Enemy enemy;
  List<Enemy> pool = [];
  List<String> log = [];
  Random rng = Random();
  bool _isPlayerTurn = true;
  bool battleOver = false;
  bool victory = false;
  bool _isPlayerAttacking = false;

  // Variáveis para Efeitos Visuais
  bool _showHealEffect = false;
  int _lastHealAmount = 0;
  List<Widget> _damageWidgets = [];

  int currentBossIndex = 0;

  @override
  void initState() {
    super.initState();

    pool = defaultEnemies()
        .map((e) => Enemy(
              id: e.id,
              title: e.title,
              maxHp: e.maxHp,
              hp: e.maxHp,
              attack: e.attack,
              desc: e.desc,
              abilities: List.from(e.abilities),
            ))
        .toList();
    _spawnEnemy();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ============== MÉTODOS DE EFEITO VISUAL (MOVIDOS PARA CÁ) ==============

  void showDamageEffect(int dmg, Offset pos, {required bool toPlayer}) {
    final key = UniqueKey();
    final widget = Positioned(
      key: key,
      left: pos.dx,
      top: pos.dy,
      child: FloatingDamage(
        damage: dmg,
        isPlayerDamage: toPlayer,
      ),
    );

    setState(() => _damageWidgets.add(widget));

    // Remove o widget após a animação
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _damageWidgets.removeWhere((w) => w.key == key));
      }
    });
  }

  void showHealEffect(int heal) {
    setState(() {
      _showHealEffect = true;
      _lastHealAmount = heal;
    });
    // Remove o efeito de cura após a animação
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showHealEffect = false);
    });
  }

  // ======================================================================

  void _spawnEnemy() {
    setState(() {
      battleOver = false;
      player.defended = false;
      player.hp = player.hp.clamp(0, player.maxHp);
      enemy = pool[currentBossIndex];
      log.insert(0, 'Um ${enemy.title} aparece!');
    });
  }

  void _applyDamageToEnemy(int dmg) {
    int effective = max(1, dmg); // Garante dano mínimo
    setState(() {
      enemy.hp = (enemy.hp - effective).clamp(0, enemy.maxHp);
      log.insert(0, 'Você causou $effective de dano em ${enemy.title}.');
      if (enemy.hp == 0) {
        log.insert(0, '${enemy.title} foi derrotado!');
        if (currentBossIndex < pool.length - 1) {
          currentBossIndex++;
          log.insert(0, 'Você avança para o próximo desafio!');
        } else {
          // Random chance for final boss: 8 victory, 2 defeat
          int roll = rng.nextInt(10);
          if (roll < 8) {
            victory = true;
            log.insert(0, 'Você venceu a batalha final! Vitória!');
          } else {
            victory = false;
            log.insert(0,
                'Mesmo derrotando ${enemy.title}, o destino se volta contra você. Derrota!');
          }
        }
        battleOver = true;
      }
    });
    // Posição para o dano flutuante no inimigo (ajustada para um ponto central na imagem)
    showDamageEffect(effective, const Offset(280, 200), toPlayer: false);
  }

  void _applyDamageToPlayer(int dmg) {
    // Aplica redução de 5% no dano se o jogador defendeu
    int effective = player.defended
        ? max(0, (dmg * 0.95).round() - player.defense)
        : max(0, dmg - player.defense);

    // Garante um dano mínimo de 1 se o dano base for maior que 0
    effective = max(0, effective);
    if (dmg > 0 && effective == 0) effective = 1;

    setState(() {
      player.hp = (player.hp - effective).clamp(0, player.maxHp);
      log.insert(0, '${enemy.title} causou $effective de dano em você.');
      player.defended = false;
      if (player.hp == 0) {
        log.insert(0, 'Você foi derrotada... Fim de Jogo.');
        battleOver = true;
      }
    });
    // Posição para o dano flutuante no jogador (ajustada para um ponto central na imagem)
    if (effective > 0) {
      showDamageEffect(effective, const Offset(80, 200), toPlayer: true);
    }
  }

  void _playerAttack() {
    if (battleOver || _isPlayerAttacking) return;
    setState(() => _isPlayerAttacking = true);
    int dmg = player.attack + rng.nextInt(7) - 3; // variabilidade
    
    // Delay de 1.5 segundos antes do ataque
    Future.delayed(Duration(milliseconds: 1500), () {
      _applyDamageToEnemy(max(1, dmg));
      _enemyTurn();
      setState(() => _isPlayerAttacking = false);
    });
  }

  void _playerDefend() {
    if (battleOver) return;
    setState(() {
      player.defended = true;
      log.insert(0, 'Você se prepara para reduzir o próximo dano.');
    });
    _enemyTurn();
  }

  void _playerUsePotion() {
    if (battleOver) return;
    if (player.potions <= 0) {
      log.insert(0, 'Sem poções!');
      setState(() {});
      return;
    }
    setState(() {
      player.potions--;
      int heal = 30 + rng.nextInt(11);
      player.hp = min(player.hp + heal, player.maxHp);
      log.insert(0,
          'Você usa uma poção e recupera $heal de HP. (Restam ${player.potions})');
      showHealEffect(heal); // Chamada do efeito visual
    });
    _enemyTurn();
  }

  void _enemyTurn() {
    if (battleOver) return;
    Future.delayed(Duration.zero, () {
      // Aumentei o delay para o efeito visual
      if (enemy.hp <= 0 || player.hp <= 0) return;
      int choice = rng.nextInt(100);

      // Lógica de habilidades do inimigo...
      if (enemy.id == 'sombra') {
        if (choice < 20) {
          log.insert(0,
              '${enemy.title} usa Ruptura Temporal e enfraquece você! (Ataque reduzido temporariamente)');
          int old = player.attack;
          player.attack = max(4, player.attack - 4);
          setState(() {});
          Future.delayed(Duration.zero, () {
            player.attack = old;
            if (mounted) setState(() {});
            log.insert(0, 'O efeito da Ruptura Temporal desaparece.');
          });
          return;
        }
      } else if (enemy.id == 'guardiao') {
        if (choice < 25) {
          log.insert(0, '${enemy.title} prepara Punho da Eternidade!');
          // Atraso de 3 segundos para a habilidade (efeito de "carga")
          Future.delayed(Duration(seconds: 3),
              () => _applyDamageToPlayer(enemy.attack + 12));
          return;
        }
      } else if (enemy.id == 'serpente') {
        if (choice < 18) {
          log.insert(0,
              '${enemy.title} usa Envelhecer! Seu HP máximo cai temporariamente.');
          int oldMax = player.maxHp;
          player.maxHp = max(40, player.maxHp - 20);
          player.hp = min(player.hp, player.maxHp);
          setState(() {});
          Future.delayed(Duration.zero, () {
            player.maxHp = oldMax;
            player.hp = min(player.hp, player.maxHp);
            if (mounted) setState(() {});
            log.insert(0, 'O efeito de Envelhecer se desfaz.');
          });
          return;
        }
        if (enemy.id == 'kael') {
          if (choice < 12) {
            log.insert(0, '${enemy.title} usa Chama Sombria!');
            _applyDamageToPlayer(enemy.attack + 10);
            return;
          } else if (choice < 15) {
            // Reversão Total: cura com chance reduzida e menor cura
            if (enemy.hp > 0) {
              int heal = (enemy.maxHp * 0.15).round();
              enemy.hp = min(enemy.maxHp, enemy.hp + heal);
              log.insert(0,
                  '${enemy.title} usa Reversão Total e recupera $heal de HP!');
              // Não tem efeito visual de cura para o inimigo, mas atualiza o estado
              setState(() {});
            }
            return;
          }
        }
        if (choice < 30) {
          log.insert(0, '${enemy.title} espelha sua ação!');
          // O dano refletido é baseado no ataque do jogador - 2, mas não menos que 1
          Future.delayed(Duration(seconds: 3),
              () => _applyDamageToPlayer(max(1, player.attack - 2)));
          return;
        }
      }

      // Caso padrão: ataque simples
      Future.delayed(Duration(seconds: 3),
          () => _applyDamageToPlayer(enemy.attack + rng.nextInt(6) - 2));
    });
  }

  void _nextEncounter() {
    // Respawn de inimigo aleatório com HP reset
    setState(() {
      for (var e in pool) {
        e.hp = e.maxHp;
      }
      _spawnEnemy();
    });
  }

  void _resetGame() {
    setState(() {
      // RESET DO JOGADOR
      player.maxHp = 150;
      player.hp = 150;
      player.attack = 20;
      player.potions = 4;
      player.defended = false;

      log.clear();
      battleOver = false;
      victory = false;
      currentBossIndex = 0;
      _spawnEnemy();
    });
  }

  Widget _statusPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Liora',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  LinearProgressIndicator(
                      value: player.hp / player.maxHp,
                      minHeight: 10,
                      color: Colors.yellowAccent),
                  SizedBox(height: 6),
                  Text(
                      'HP: ${player.hp}/${player.maxHp}  •  Atk: ${player.attack}  •  Def: ${player.defense}  •  Poções: ${player.potions}'),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(enemy.title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                      value: enemy.hp / enemy.maxHp,
                      minHeight: 10,
                      color: Colors.redAccent), // Inimigo HP em vermelho
                ),
                SizedBox(height: 6),
                Text('HP: ${enemy.hp}/${enemy.maxHp}'),
              ],
            )
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed:
                  battleOver || _isPlayerAttacking ? null : _playerAttack,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.black,
              ),
              child: Column(
                children: [
                  Icon(Icons.flash_on, color: Colors.black),
                  SizedBox(height: 4),
                  Text('Atacar')
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: battleOver ? null : _playerDefend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.black,
              ),
              child: Column(
                children: [
                  Icon(Icons.shield),
                  SizedBox(height: 4),
                  Text('Defender')
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed:
                  battleOver || player.potions <= 0 ? null : _playerUsePotion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.black,
              ),
              child: Column(
                children: [
                  Icon(Icons.local_drink),
                  SizedBox(height: 4),
                  Text('Usar Poção (${player.potions})')
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (battleOver && victory) {
      return VictoryScreen(
        onRetry: _resetGame,
        onBackToMenu: () => Navigator.pop(context),
      );
    }
    if (battleOver && player.hp == 0) {
      return GameOverScreen(
        onRetry: _resetGame,
        onBackToMenu: () => Navigator.pop(context),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Batalha'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () =>
                showDialog(context: context, builder: (_) => _helpDialog()),
          )
        ],
      ),
      body: Container(
        decoration: enemy.backgroundPath != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(enemy.backgroundPath!),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _statusPanel(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: enemy.backgroundPath != null
                        ? Colors.black.withOpacity(
                            0.3) // Fundo semitransparente sobre a imagem
                        : Color(0xFF0D1324), // Mantém a cor original sem imagem
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Registro',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 100,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: ListView.builder(
                                      reverse: true,
                                      itemCount: log.length,
                                      itemBuilder: (context, idx) => Text(
                                          log[idx],
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                ),

                                // Placeholder para Imagem do Player
                                Expanded(child: SizedBox.shrink()),

                                Image.asset(
                                  'assets/Loiradlc.png',
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.person, size: 180),
                                ),
                                SizedBox(height: 8),
                                Text('Liora',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Placeholder para Imagem do Inimigo
                                Expanded(child: SizedBox.shrink()),

                                Image.asset(
                                  enemy.imagePath,
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error, size: 180),
                                ),
                                SizedBox(height: 8),
                                Text(enemy.title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(enemy.desc,
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Efeitos visuais sobrepostos:
                      ..._damageWidgets,
                      // Efeito de cura
                      if (_showHealEffect)
                        Positioned(
                          left: 80, // Posição aproximada do personagem Liora
                          top: 200,
                          child: PotionEffect(heal: _lastHealAmount),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              _actionButtons(),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.yellow),
                        label: Text('Sair'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: ElevatedButton.icon(
                        onPressed:
                            battleOver && !victory ? _nextEncounter : null,
                        icon: Icon(Icons.shuffle),
                        label: Text('Próximo Encontro'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade700,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _helpDialog() {
    // Implementação do diálogo de ajuda
    return AlertDialog(
      title: Text('Ajuda (Regras Básicas)'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('O objetivo é derrotar todos os chefes na sequência.'),
            SizedBox(height: 10),
            Text(
                '• Atacar: Causa dano com base no seu Ataque (Atk) e uma pequena variação.'),
            Text(
                '• Defender: Reduz o próximo dano recebido em 5% e adiciona +6 de defesa. O efeito dura apenas um turno.'),
            Text(
                '• Usar Poção: Recupera HP (variável entre 30 e 40). O número de poções é limitado.'),
            SizedBox(height: 10),
            Text(
                'Os inimigos têm habilidades únicas com chances de ativação no turno deles.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}