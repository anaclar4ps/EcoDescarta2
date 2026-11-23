import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const EcoDescartaApp());
}

// CORES DO APLICATIVO
const verde = Color(0xFF218838);
const verdeEscuro = Color(0xFF145C2A);
const fundo = Color(0xFFF4F8F4);

// MODELO DOS MATERIAIS
class MaterialItem {
  final String nome;
  final String categoria;
  final String lixeira;
  final String cor;
  final String decomposicao;
  final String dica;
  final IconData icone;

  const MaterialItem({
    required this.nome,
    required this.categoria,
    required this.lixeira,
    required this.cor,
    required this.decomposicao,
    required this.dica,
    required this.icone,
  });
}

// CATÁLOGO LOCAL: NÃO PRECISA DE INTERNET NEM API
const List<MaterialItem> catalogo = [
  MaterialItem(
    nome: 'Garrafa PET',
    categoria: 'Plástico',
    lixeira: 'Vermelha',
    cor: 'Plástico',
    decomposicao: 'Cerca de 400 anos',
    dica: 'Esvazie a garrafa e, se possível, encaminhe-a limpa para a reciclagem.',
    icone: Icons.local_drink,
  ),
  MaterialItem(
    nome: 'Sacola plástica',
    categoria: 'Plástico',
    lixeira: 'Vermelha',
    cor: 'Plástico',
    decomposicao: 'De 10 a 20 anos',
    dica: 'Reutilize a sacola quando possível e encaminhe-a para a coleta seletiva.',
    icone: Icons.shopping_bag,
  ),
  MaterialItem(
    nome: 'Papelão',
    categoria: 'Papel',
    lixeira: 'Azul',
    cor: 'Papel',
    decomposicao: 'Cerca de 6 meses',
    dica: 'Mantenha o papelão seco e sem restos de alimentos.',
    icone: Icons.inventory_2,
  ),
  MaterialItem(
    nome: 'Jornal',
    categoria: 'Papel',
    lixeira: 'Azul',
    cor: 'Papel',
    decomposicao: 'De 2 a 6 semanas',
    dica: 'Junte os jornais limpos e secos para a reciclagem.',
    icone: Icons.newspaper,
  ),
  MaterialItem(
    nome: 'Folha de papel',
    categoria: 'Papel',
    lixeira: 'Azul',
    cor: 'Papel',
    decomposicao: 'De 3 a 6 meses',
    dica: 'Utilize os dois lados da folha antes de descartá-la.',
    icone: Icons.description,
  ),
  MaterialItem(
    nome: 'Lata de alumínio',
    categoria: 'Metal',
    lixeira: 'Amarela',
    cor: 'Metal',
    decomposicao: 'De 200 a 500 anos',
    dica: 'Esvazie a lata e encaminhe-a limpa para a reciclagem.',
    icone: Icons.local_bar,
  ),
  MaterialItem(
    nome: 'Lata de aço',
    categoria: 'Metal',
    lixeira: 'Amarela',
    cor: 'Metal',
    decomposicao: 'Cerca de 10 anos',
    dica: 'Retire os restos de alimentos antes do descarte.',
    icone: Icons.restaurant,
  ),
  MaterialItem(
    nome: 'Pote de vidro',
    categoria: 'Vidro',
    lixeira: 'Verde',
    cor: 'Vidro',
    decomposicao: 'Tempo indeterminado',
    dica: 'Encaminhe o vidro com cuidado. Embale peças quebradas para evitar acidentes.',
    icone: Icons.wine_bar,
  ),
  MaterialItem(
    nome: 'Garrafa de vidro',
    categoria: 'Vidro',
    lixeira: 'Verde',
    cor: 'Vidro',
    decomposicao: 'Tempo indeterminado',
    dica: 'Esvazie a garrafa e encaminhe-a para a coleta seletiva.',
    icone: Icons.local_drink,
  ),
  MaterialItem(
    nome: 'Casca de fruta',
    categoria: 'Orgânico',
    lixeira: 'Marrom',
    cor: 'Orgânico',
    decomposicao: 'Algumas semanas a meses',
    dica: 'Pode ser aproveitada na compostagem.',
    icone: Icons.eco,
  ),
  MaterialItem(
    nome: 'Restos de verduras',
    categoria: 'Orgânico',
    lixeira: 'Marrom',
    cor: 'Orgânico',
    decomposicao: 'Algumas semanas a meses',
    dica: 'Separe os restos vegetais para a compostagem.',
    icone: Icons.grass,
  ),
  MaterialItem(
    nome: 'Pilha',
    categoria: 'Resíduo especial',
    lixeira: 'Ponto de coleta específico',
    cor: 'Especial',
    decomposicao: 'Pode levar centenas de anos',
    dica: 'Não coloque no lixo comum. Procure um ponto de coleta de pilhas e baterias.',
    icone: Icons.battery_full,
  ),
  MaterialItem(
    nome: 'Bateria',
    categoria: 'Resíduo especial',
    lixeira: 'Ponto de coleta específico',
    cor: 'Especial',
    decomposicao: 'Variável',
    dica: 'Leve a um ponto de coleta adequado. Não descarte no lixo comum.',
    icone: Icons.battery_charging_full,
  ),
  MaterialItem(
    nome: 'Lâmpada',
    categoria: 'Resíduo especial',
    lixeira: 'Ponto de coleta específico',
    cor: 'Especial',
    decomposicao: 'Variável',
    dica: 'Procure um ponto de coleta específico para lâmpadas.',
    icone: Icons.lightbulb,
  ),
  MaterialItem(
    nome: 'Guardanapo usado',
    categoria: 'Rejeito',
    lixeira: 'Cinza',
    cor: 'Rejeito',
    decomposicao: 'Variável',
    dica: 'Quando estiver sujo ou engordurado, geralmente não pode ser reciclado.',
    icone: Icons.article,
  ),
  MaterialItem(
    nome: 'Espelho',
    categoria: 'Vidro especial',
    lixeira: 'Ponto de coleta específico',
    cor: 'Especial',
    decomposicao: 'Tempo indeterminado',
    dica: 'Espelhos não devem ser misturados com vidro comum reciclável. Consulte a coleta local.',
    icone: Icons.crop_square,
  ),
];

Color corDaLixeira(String cor) {
  switch (cor) {
    case 'Plástico':
      return Colors.red;
    case 'Papel':
      return Colors.blue;
    case 'Metal':
      return Colors.amber.shade700;
    case 'Vidro':
      return Colors.green;
    case 'Orgânico':
      return Colors.brown;
    case 'Rejeito':
      return Colors.grey;
    default:
      return Colors.deepPurple;
  }
}

class EcoDescartaApp extends StatelessWidget {
  const EcoDescartaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoDescarta',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: verde),
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          foregroundColor: verdeEscuro,
          centerTitle: false,
        ),
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;
  int pontos = 0;

  Uint8List? imagemSelecionada;
  MaterialItem? materialSelecionado;

  final ImagePicker seletorImagem = ImagePicker();
  final TextEditingController pesquisaController = TextEditingController();

  String pesquisa = '';
  List<Map<String, dynamic>> historico = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  // CARREGA PONTUAÇÃO E HISTÓRICO SALVOS NO DISPOSITIVO
  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final dadosHistorico = prefs.getString('historicoEcoDescarta');

    if (!mounted) return;

    setState(() {
      pontos = prefs.getInt('pontosEcoDescarta') ?? 0;

      if (dadosHistorico != null) {
        historico = List<Map<String, dynamic>>.from(
          (jsonDecode(dadosHistorico) as List).map(
            (item) => Map<String, dynamic>.from(item),
          ),
        );
      }
    });
  }

  Future<void> salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('pontosEcoDescarta', pontos);
    await prefs.setString(
      'historicoEcoDescarta',
      jsonEncode(historico),
    );
  }

  // SELEÇÃO DE FOTO
  Future<void> escolherImagem(ImageSource origem) async {
    try {
      final XFile? arquivo = await seletorImagem.pickImage(
        source: origem,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (arquivo == null) return;

      final bytes = await arquivo.readAsBytes();

      if (!mounted) return;

      setState(() {
        imagemSelecionada = bytes;
        materialSelecionado = null;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível selecionar a imagem.'),
        ),
      );
    }
  }

  void abrirOpcoesImagem() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: verde),
                title: const Text('Tirar uma foto'),
                onTap: () {
                  Navigator.pop(context);
                  escolherImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: verde),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);
                  escolherImagem(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ESCOLHA MANUAL DO MATERIAL
  void abrirCatalogoParaEscolher() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'Qual é o material?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: catalogo.length,
                    itemBuilder: (context, index) {
                      final item = catalogo[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              corDaLixeira(item.cor).withOpacity(0.15),
                          child: Icon(
                            item.icone,
                            color: corDaLixeira(item.cor),
                          ),
                        ),
                        title: Text(item.nome),
                        subtitle: Text(item.categoria),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          setState(() {
                            materialSelecionado = item;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // REGISTRA O DESCARTE E ATRIBUI PONTOS
  Future<void> registrarDescarte() async {
    if (materialSelecionado == null) return;

    final item = materialSelecionado!;

    setState(() {
      pontos += 10;

      historico.insert(0, {
        'nome': item.nome,
        'lixeira': item.lixeira,
        'data': DateTime.now().toIso8601String(),
        'pontos': 10,
      });

      imagemSelecionada = null;
      materialSelecionado = null;
    });

    await salvarDados();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descarte registrado! Você ganhou 10 pontos.'),
        backgroundColor: verde,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final telas = [
      construirInicio(),
      construirCatalogo(),
      construirHistorico(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.eco, color: verde, size: 28),
            const SizedBox(width: 8),
            const Text(
              'EcoDescarta',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: const Icon(Icons.stars, color: Colors.orange),
              label: Text('$pontos pts'),
              backgroundColor: Colors.orange.withOpacity(0.12),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: paginaAtual,
        children: telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Identificar',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }

  // TELA INICIAL
  Widget construirInicio() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: verdeEscuro,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.eco, color: Colors.white, size: 38),
              SizedBox(height: 12),
              Text(
                'Pequenas atitudes,\n grandes mudanças!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Descubra como descartar seus resíduos corretamente.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Identifique um resíduo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tire uma foto ou escolha uma imagem para começar.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),

        // ÁREA DA FOTO
        InkWell(
          onTap: abrirOpcoesImagem,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black12),
            ),
            child: imagemSelecionada == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 55,
                        color: verde,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Adicionar foto',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Câmera ou galeria',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.memory(
                      imagemSelecionada!,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),

        OutlinedButton.icon(
          onPressed: abrirOpcoesImagem,
          icon: const Icon(Icons.photo_camera),
          label: const Text('Escolher outra foto'),
        ),

        const SizedBox(height: 20),
        const Text(
          'Selecione o material manualmente:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: abrirCatalogoParaEscolher,
          icon: const Icon(Icons.search),
          label: Text(
            materialSelecionado?.nome ?? 'Pesquisar material no catálogo',
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),

        if (materialSelecionado != null) ...[
          const SizedBox(height: 16),
          construirDetalhesMaterial(materialSelecionado!),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: registrarDescarte,
            icon: const Icon(Icons.check_circle),
            label: const Text('Registrar descarte (+10 pontos)'),
            style: FilledButton.styleFrom(
              backgroundColor: verde,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
        const SizedBox(height: 25),
      ],
    );
  }

  // CARTÃO COM INFORMAÇÕES DO MATERIAL
  Widget construirDetalhesMaterial(MaterialItem item) {
    final cor = corDaLixeira(item.cor);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.nome,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 24),
          const Text(
            'Lixeira ou destino indicado:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(backgroundColor: cor, radius: 10),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.lixeira,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tempo aproximado de decomposição:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            item.decomposicao,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dica de descarte:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(item.dica),
        ],
      ),
    );
  }

  // TELA DO CATÁLOGO
  Widget construirCatalogo() {
    final itensFiltrados = catalogo.where((item) {
      return item.nome.toLowerCase().contains(pesquisa.toLowerCase()) ||
          item.categoria.toLowerCase().contains(pesquisa.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: pesquisaController,
            onChanged: (valor) {
              setState(() {
                pesquisa = valor;
              });
            },
            decoration: InputDecoration(
              hintText: 'Pesquisar resíduo...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: itensFiltrados.isEmpty
              ? const Center(child: Text('Nenhum material encontrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: itensFiltrados.length,
                  itemBuilder: (context, index) {
                    final item = itensFiltrados[index];
                    final cor = corDaLixeira(item.cor);

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cor.withOpacity(0.15),
                          child: Icon(item.icone, color: cor),
                        ),
                        title: Text(
                          item.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item.categoria} • ${item.lixeira}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SafeArea(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      construirDetalhesMaterial(item),
                                      const SizedBox(height: 15),
                                      FilledButton(
                                        onPressed: () {
                                          setState(() {
                                            materialSelecionado = item;
                                            paginaAtual = 0;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Selecionar este material',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // TELA DO HISTÓRICO
  Widget construirHistorico() {
    if (historico.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 65, color: Colors.black26),
              SizedBox(height: 12),
              Text(
                'Nenhum descarte registrado ainda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),
              SizedBox(height: 6),
              Text(
                'Registre seu primeiro descarte para começar!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: verdeEscuro,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              const Text(
                'Sua pontuação',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 5),
              Text(
                '$pontos pontos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${historico.length} descartes registrados',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: historico.length,
            itemBuilder: (context, index) {
              final registro = historico[index];
              final data = DateTime.tryParse(registro['data'] ?? '');

              final dataFormatada = data == null
                  ? 'Data não disponível'
                  : '${data.day.toString().padLeft(2, '0')}/'
                      '${data.month.toString().padLeft(2, '0')}/'
                      '${data.year} às '
                      '${data.hour.toString().padLeft(2, '0')}:'
                      '${data.minute.toString().padLeft(2, '0')}';

              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE4F3E6),
                    child: Icon(Icons.check, color: verde),
                  ),
                  title: Text(
                    registro['nome'] ?? 'Material',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${registro['lixeira'] ?? 'Destino não informado'}\n$dataFormatada',
                  ),
                  isThreeLine: true,
                  trailing: const Text(
                    '+10 pts',
                    style: TextStyle(
                      color: verde,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}