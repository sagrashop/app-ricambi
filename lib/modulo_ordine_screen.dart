import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ModuloOrdineScreen extends StatefulWidget {
  final String skuProdotto;

  const ModuloOrdineScreen({Key? key, required this.skuProdotto})
    : super(key: key);

  @override
  _ModuloOrdineScreenState createState() => _ModuloOrdineScreenState();
}

class _ModuloOrdineScreenState extends State<ModuloOrdineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _indirizzoController = TextEditingController();
  final _civicoController = TextEditingController();
  final _comuneController = TextEditingController();
  final _capController = TextEditingController();
  final _telefonoController = TextEditingController();

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

  // FUNZIONE PER INVIARE L'EMAIL TRAMITE EMAILJS
  Future<void> _inviaEmailEmailJS() async {
    const url = 'https://api.emailjs.com/api/v1.0/email/send';

    // SOSTITUISCI QUESTI TRE VALORI CON I TUOI DATI PRESI DALLA DASHBOARD DI EMAILJS
    const serviceId = 'service_h8n26es';
    const templateId = 'template_glr3kdh';
    const userId = '5ACYXSRNdZQyYZJAO';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_nome': _nomeController.text,
          'user_indirizzo': _indirizzoController.text,
          'user_civico': _civicoController.text,
          'user_comune': _comuneController.text,
          'user_cap': _capController.text,
          'user_telefono': _telefonoController.text,
          'sku_prodotto': widget.skuProdotto,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'invio dell\'email');
    }
  }

  void _inviaOrdine() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Esegue l'invio reale dell'email
        await _inviaEmailEmailJS();

        setState(() {
          _isLoading = false;
        });

        // Mostra messaggio di successo e torna alla Home
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Ordine Confermato"),
            content: const Text(
              "Grazie per il tuo ordine! Stiamo arrivando con il tuo ricambio.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore di invio: $e. Riprova.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completa Ordine (SKU: ${widget.skuProdotto})"),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo *'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _indirizzoController,
                decoration: const InputDecoration(
                  labelText: 'Indirizzo (Via/Piazza) *',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _civicoController,
                      decoration: const InputDecoration(
                        labelText: 'N. Civico *',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Obbligatorio' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _comuneController,
                decoration: const InputDecoration(labelText: 'Comune *'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _capController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CAP *'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obbligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Numero di Telefono *',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obbligatorio' : null,
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
                  onPressed: _isLoading ? null : _inviaOrdine,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'ORDINA',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
