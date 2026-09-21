import 'package:flutter/material.dart';

import 'categoria_screen.dart';
import 'ricambi_data.dart';
import 'dettaglio_prodotto_screen.dart';
import 'termini_screen.dart';
import 'privacy_screen.dart';

import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _ricambioController = TextEditingController();
  final TextEditingController _codiceController = TextEditingController();

  bool _isLoading = false;
  String _messaggioErrore = "";
  List<Ricambio> _prodottiTrovati = [];
  List<Ricambio> _prodottiSimili = []; // Nuova lista per i simili
  String _categoriaSelezionata = "Tutti i prodotti";

  void _verificaDisponibilita() {
    setState(() {
      _isLoading = true;
      _messaggioErrore = "";
      _prodottiTrovati.clear();
      _prodottiSimili.clear();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final String marcaInput = _marcaController.text.trim().toLowerCase();
      final String ricambioInput = _ricambioController.text
          .trim()
          .toLowerCase();
      final String codiceInput = _codiceController.text.trim().toLowerCase();

      if (marcaInput.isEmpty && ricambioInput.isEmpty && codiceInput.isEmpty) {
        setState(() {
          _isLoading = false;
          _messaggioErrore =
              "Inserisci almeno una parola in uno dei campi per cercare.";
        });
        return;
      }

      List<Ricambio> trovatiEsatti = [];
      List<Ricambio> trovatiSimili = [];

      // 1. SE C'È UN CODICE INSERITO, CERCHIAMO PRIMA IL CORRISPONDENTE ESATTO
      if (codiceInput.isNotEmpty) {
        trovatiEsatti = catalogoRicambi.where((item) {
          final codiceL = item.codice.toLowerCase();
          final skuL = item.sku.toLowerCase();
          return codiceL == codiceInput ||
              skuL == codiceInput ||
              codiceL.contains(codiceInput) ||
              skuL.contains(codiceInput);
        }).toList();
      }

      // 2. CERCHIAMO COMUNQUE I SIMILI (tramite marca o tipo di ricambio)
      trovatiSimili = catalogoRicambi.where((item) {
        final titoloL = item.titolo.toLowerCase();
        final descCortaL = item.descrizioneCorta.toLowerCase();
        final descLungaL = item.descrizioneLunga.toLowerCase();
        final codiceL = item.codice.toLowerCase();
        final skuL = item.sku.toLowerCase();

        bool matchSimile = false;

        if (marcaInput.isNotEmpty) {
          if (codiceL.contains(marcaInput) ||
              skuL.contains(marcaInput) ||
              titoloL.contains(marcaInput) ||
              descCortaL.contains(marcaInput) ||
              descLungaL.contains(marcaInput)) {
            matchSimile = true;
          }
        }
        if (ricambioInput.isNotEmpty) {
          if (titoloL.contains(ricambioInput) ||
              descCortaL.contains(ricambioInput) ||
              descLungaL.contains(ricambioInput)) {
            matchSimile = true;
          }
        }

        // Escludiamo dai simili quelli già trovati esattamente dal codice
        if (trovatiEsatti.contains(item)) {
          return false;
        }

        return matchSimile;
      }).toList();

      setState(() {
        _isLoading = false;

        if (codiceInput.isNotEmpty && trovatiEsatti.isNotEmpty) {
          // REGOLA: Se trova il codice esatto, mostra SOLO quello e nient'altro
          _prodottiTrovati = [trovatiEsatti.first];
          _prodottiSimili = [];
          _messaggioErrore = "";
        } else if (codiceInput.isNotEmpty && trovatiEsatti.isEmpty) {
          // REGOLA: Se inserisce il codice ma NON lo trova -> Mostra avviso e risultati simili
          _prodottiTrovati = [];
          _prodottiSimili = trovatiSimili;
          _messaggioErrore =
              "Codice ricambio non trovato, contatta l'assistenza.";
        } else {
          // Ricerca standard basata su marca/tipo ricambio se il codice non è stato inserito
          _prodottiTrovati = trovatiSimili;
          _prodottiSimili = [];
          if (_prodottiTrovati.isEmpty) {
            _messaggioErrore = "Nessun risultato trovato. Cerca nel menu nell'apposita categoria.";
          }
        }
      });
    });
  }

  void _apriCategoria(String categoria) {
    setState(() {
      _categoriaSelezionata = categoria;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriaScreen(categoriaSelezionata: categoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B365D),
        elevation: 0,
        title: const Text(''),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: !isDesktop
          ? Drawer(
              child: Container(
                color: const Color(0xFF1B365D),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xFF15294A)),
                      child: Text(
                        'Menu Categorie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _categoriaSelezionata = "Tutti i prodotti";
                          _prodottiTrovati.clear();
                          _prodottiSimili.clear();
                          _messaggioErrore = "";
                        });
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Ricambi per Lavatrice',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _apriCategoria('Lavatrice');
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Ricambi per Cappe',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _apriCategoria('Cappe');
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Ricambi per Frigorifero',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _apriCategoria('Frigorifero');
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Ricambi Stufe a Pellet',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _apriCategoria('Stufe a Pellet');
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            SizedBox(
              height: isDesktop ? 260 : 160,
              width: double.infinity,
              child: Image.asset(
                'assets/bunner1.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF1B365D));
                },
              ),
            ),

            if (isDesktop)
              Container(
                color: const Color(0xFF15294A),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _categoriaSelezionata = "Tutti i prodotti";
                          _prodottiTrovati.clear();
                          _prodottiSimili.clear();
                          _messaggioErrore = "";
                        });
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () => _apriCategoria('Lavatrice'),
                      child: const Text(
                        'Lavatrice',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () => _apriCategoria('Cappe'),
                      child: const Text(
                        'Cappe',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () => _apriCategoria('Frigorifero'),
                      child: const Text(
                        'Frigorifero',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () => _apriCategoria('Stufe a Pellet'),
                      child: const Text(
                        'Stufe a Pellet',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),

            // --- BLOCCO ICONE CATEGORIE ---
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoriaIcon(
                    context,
                    "Lavatrice",
                    Icons.local_laundry_service,
                    Colors.blue,
                  ),
                  _buildCategoriaIcon(context, "Cappe", Icons.air, Colors.teal),
                  _buildCategoriaIcon(
                    context,
                    "Frigorifero",
                    Icons.kitchen,
                    Colors.indigo,
                  ),
                  _buildCategoriaIcon(
                    context,
                    "Stufe a pellet",
                    Icons.local_fire_department,
                    Colors.deepOrange,
                  ),
                ],
              ),
            ),

            // Campi di ricerca
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Marca Elettrodomestico',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _marcaController,
                    decoration: InputDecoration(
                      hintText: 'Inserisci marca...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(
                        Icons.confirmation_number_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '2. Tipo di Ricambio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ricambioController,
                    decoration: InputDecoration(
                      hintText: 'Descrivi il ricambio (es. Filtro scarico)',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.build_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '3. Codice Ricambio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codiceController,
                    decoration: InputDecoration(
                      hintText: 'Es. FILT-001',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.code),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE67E22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      onPressed: _isLoading ? null : _verificaDisponibilita,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'VERIFICA DISPONIBILITÀ E ORDINA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Risultati Ricerca:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bottone WhatsApp Contattaci
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B365D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        final Uri whatsappUri = Uri.parse(
                          "https://wa.me/393287095115?text=Salve,%20non%20trovo%20il%20mio%20ricambio.",
                        );
                        if (await canLaunchUrl(whatsappUri)) {
                          await launchUrl(
                            whatsappUri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Non trovi il tuo ricambio? Contattaci",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Aggiungi questo blocco dove preferisci sotto il pulsante di verifica o di contatto
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TerminiScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Termini e Condizioni',
                            style: TextStyle(
                              color: Color(0xFF1B365D),
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(' | ', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF1B365D),
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // AREE RISULTATI IN BASE ALLE REGOLE IMPOSTATE
                  if (_messaggioErrore.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _messaggioErrore,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],

                  // 1. SE TROVA IL CODICE ESATTO, MOSTRA SOLO QUELLO
                  if (_prodottiTrovati.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prodottiTrovati.length,
                      itemBuilder: (context, index) {
                        final ricambio = _prodottiTrovati[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                ricambio.immagineUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.settings,
                                    size: 40,
                                    color: Colors.orange,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              ricambio.titolo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              "Cod: ${ricambio.codice} | SKU: ${ricambio.sku}\n${ricambio.descrizioneCorta}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              "€ ${ricambio.prezzo.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DettaglioProdottoScreen(
                                    ricambio: ricambio,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],

                  // 2. SE IL CODICE NON È STATO TROVATO, MOSTRA I SIMILI SOTTO
                  if (_prodottiSimili.isNotEmpty) ...[
                    const Text(
                      'Potrebbero interessarti anche questi ricambi simili:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _prodottiSimili.length,
                      itemBuilder: (context, index) {
                        final ricambio = _prodottiSimili[index];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                ricambio.immagineUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.settings,
                                    size: 30,
                                    color: Colors.orange,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              ricambio.titolo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "Cod: ${ricambio.codice}",
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: Text(
                              "€ ${ricambio.prezzo.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DettaglioProdottoScreen(
                                    ricambio: ricambio,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaIcon(
    BuildContext context,
    String categoria,
    IconData icona,
    Color colore,
  ) {
    return GestureDetector(
      onTap: () => _apriCategoria(categoria),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colore.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icona, color: colore, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            categoria,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B365D),
            ),
          ),
        ],
      ),
    );
  }
}
