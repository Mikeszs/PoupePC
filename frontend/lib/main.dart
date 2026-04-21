import 'package:flutter/material.dart';

void main() {
  runApp(const PoupePCApp());
}

class PoupePCApp extends StatefulWidget {
  const PoupePCApp({super.key});

  @override
  State<PoupePCApp> createState() => _PoupePCAppState();
}

class _PoupePCAppState extends State<PoupePCApp> {
  // Gerenciador de estado simples para o tema
  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Poupe PC',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          // Definição do Tema Claro
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blueAccent,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          ),
          // Definição do Tema Escuro
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blueAccent,
          ),
          home: HomeScreen(themeNotifier: _themeNotifier),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const HomeScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNavBar(context),
            _buildHeroSection(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 1, child: FiltersSidebar()),
                  const SizedBox(width: 30),
                  Expanded(flex: 4, child: MainContentArea()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES DA UI ---

  Widget _buildTopNavBar(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          const Icon(Icons.forum_outlined, color: Colors.blue, size: 30),
          const SizedBox(width: 10),
          const Text(
            "Poupe PC",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          _navItem("Início"),
          _navItem("Peças"),
          _navItem("Comparações"),
          _navItem("Ofertas"),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text("Login", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50.withOpacity(0.5), Colors.white],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Compare preços de\npeças de PC em tempo real",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 15),
                Text(
                  "Encontre as melhores ofertas de hardware!",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      ),
                      child: const Text("Comparar Agora", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 15),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      ),
                      child: const Text("Ver Categorias"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Placeholder para a imagem dos componentes
          const Expanded(
            child: Icon(Icons.computer, size: 200, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class FiltersSidebar extends StatelessWidget {
  const FiltersSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Filtros", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Divider(),
        _filterSection("Faixa de Preço", Slider(value: 0.5, onChanged: (v) {})),
        _filterSection("Marca", Column(
          children: [
            CheckboxListTile(value: false, title: const Text("Intel"), onChanged: (v) {}),
            CheckboxListTile(value: true, title: const Text("AMD"), onChanged: (v) {}),
          ],
        )),
        _filterSection("Capacidade", Wrap(
          spacing: 8,
          children: ["256GB", "512GB", "1TB", "2TB"].map((e) => Chip(label: Text(e))).toList(),
        )),
      ],
    );
  }

  Widget _filterSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        children: [content],
      ),
    );
  }
}

class MainContentArea extends StatelessWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs de Categoria
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _categoryTab("Processadores", Icons.memory, true),
              _categoryTab("Placas de Vídeo", Icons.settings_input_component, false),
              _categoryTab("Memória RAM", Icons.sd_storage, false),
              _categoryTab("SSDs", Icons.developer_board, false),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Tabela de Produtos
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Produto')),
                DataColumn(label: Text('Loja')),
                DataColumn(label: Text('Menor Preço')),
                DataColumn(label: Text('Economia')),
              ],
              rows: [
                _buildDataRow("GeForce RTX 3060 12GB", "Kabum!", "R\$ 2.199", "Economize R\$ 300", Colors.green),
                _buildDataRow("GeForce RTX 3060 12GB", "Terabyte Shop", "R\$ 2.249", "R\$ 2.599", Colors.grey),
                _buildDataRow("GeForce RTX 3060 12GB", "Pichau", "R\$ 2.320", "+ R\$ 121", Colors.red),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Footer Stats
        Row(
          children: [
            _statCard("Menor Preço Atual", "R\$ 2.199", Icons.local_offer),
            const SizedBox(width: 20),
            _statCard("Mais de 5.000 Peças", "Atualização Diária", Icons.storage),
          ],
        )
      ],
    );
  }

  DataRow _buildDataRow(String name, String store, String price, String savings, Color color) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(store, style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
      DataCell(Text(price, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
        child: Text(savings, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      )),
    ]);
  }

  Widget _categoryTab(String title, IconData icon, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(title),
        avatar: Icon(icon, size: 18, color: active ? Colors.white : Colors.blue),
        selected: active,
        selectedColor: Colors.blue,
        labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
        onSelected: (v) {},
      ),
    );
  }

  Widget _statCard(String title, String subtitle, IconData icon) {
    return Expanded(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.blue.shade50, child: Icon(icon, color: Colors.blue)),
          title: Text(title, style: const TextStyle(fontSize: 12)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}