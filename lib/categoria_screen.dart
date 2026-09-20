import 'package:flutter/material.dart';

import 'ricambi_data.dart';
import 'dettaglio_prodotto_screen.dart';

class CategoriaScreen extends StatelessWidget {
  final String categoriaSelezionata;

  const CategoriaScreen({Key? key, required this.categoriaSelezionata})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtriamo i prodotti di questa specifica categoria
    final prodottiFiltrati = catalogoRicambi
        .where(
          (item) =>
              item.categoria.toLowerCase() ==
              categoriaSelezionata.toLowerCase(),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ricambi: $categoriaSelezionata'),
        backgroundColor: const Color(0xFF1B365D),
      ),
      body: prodottiFiltrati.isEmpty
          ? const Center(
              child: Text(
                'Nessun prodotto trovato in questa categoria.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: prodottiFiltrati.length,
              itemBuilder: (context, index) {
                final ricambio = prodottiFiltrati[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    // FOTO PICCOLA ACCANTO
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        ricambio.immagineUrl,
                        width: 60,
                        height: 60,
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
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Codice: ${ricambio.codice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "SKU: ${ricambio.sku}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ricambio.descrizioneCorta,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      "€ ${ricambio.prezzo.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DettaglioProdottoScreen(ricambio: ricambio),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
