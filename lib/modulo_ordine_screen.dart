import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ricambi_data.dart';

class ModuloOrdineScreen extends StatefulWidget {
  final Ricambio ricambio;

  const ModuloOrdineScreen({Key? key, required this.ricambio})
    : super(key: key);

  @override
  State<ModuloOrdineScreen> createState() => _ModuloOrdineScreenState();
}

class _ModuloOrdineScreenState extends State<ModuloOrdineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _indirizzoController = TextEditingController();
  final TextEditingController _civicoController = TextEditingController();
  final TextEditingController _comuneController = TextEditingController();
  final TextEditingController _capController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _indirizzoController.dispose();
    _civicoController.dispose();
    _comuneController.dispose();
    _capController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  // Funzione per inviare l'email tramite EmailJS configurata per il sito online
  Future<void> _inviaEmailEmailJS() async {
    const url = 'https://api.emailjs.com/api/v1.0/email/send';

    const serviceId = 'service_h8n26es';
    const templateId = 'template_glr3kdh';
    const userId = '5ACYXSRNDzQyYZJAO';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'origin': 'https://ricambiveloce.it', // Dominio online definitivo
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_nome': _nomeController.text.trim(),
            'user_indirizzo': _indirizzoController.text.trim(),
            'user_civico': _civicoController.text.trim(),
            'user_comune': _comuneController.text.trim(),
            'user_cap': _capController.text.trim(),
            'user_telefono': _telefonoController.text.trim(),
            'sku_prodotto':
                "${widget.ricambio.titolo} (Codice: ${widget.ricambio.codice})",
          },
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Ordine Inviato!"),
            content: const Text(
              "Il tuo ordine è stato inoltrato con successo. Verrai ricontattato presto.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Chiude il dialogo
                  Navigator.pop(context); // Torna indietro
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Errore nell'invio dell'ordine: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Errore di connessione: $e")));
    }
  }

  void _confermaOrdine() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _inviaEmailEmailJS();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modulo Ordine"),
        backgroundColor: const Color(0xFF1B365D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag,
                      color: Color(0xFFE67E22),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ricambio.titolo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Codice: ${widget.ricambio.codice} - € ${widget.ricambio.prezzo.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Inserisci i tuoi dati per la spedizione:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B365D),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome e Cognome *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Inserisci il nome'
                    : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _indirizzoController,
                      decoration: const InputDecoration(
                        labelText: 'Indirizzo *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Campo obbligatorio'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _civicoController,
                      decoration: const InputDecoration(
                        labelText: 'N. Civico *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Obbligatorio'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _comuneController,
                      decoration: const InputDecoration(
                        labelText: 'Comune *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Inserisci il comune'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _capController,
                      decoration: const InputDecoration(
                        labelText: 'CAP *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'CAP' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Telefono *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Inserisci un recapito telefonico'
                    : null,
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
                  onPressed: _isLoading ? null : _confermaOrdine,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'CONFERMA E INVIA ORDINE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
