import 'package:flutter/material.dart';

// Eventuale pacchetto per inviare email o richiesta HTTP (es. http.post per EmailJS)

class ModuloOrdineScreen extends StatefulWidget {
  final String skuProdotto;

  const ModuloOrdineScreen({Key? key, required this.skuProdotto})
    : super(key: key);

  @override
  _ModuloOrdineScreenState createState() => _ModuloOrdineScreenState();
}

class _ModuloOrdineScreenState extends State<ModuloOrdineScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller per i campi obbligatori
  final _nomeController = TextEditingController();
  final _indirizzoController = TextEditingController();
  final _civicoController = TextEditingController();
  final _capController = TextEditingController();
  final _telefonoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _indirizzoController.dispose();
    _civicoController.dispose();
    _capController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _inviaOrdine() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulazione invio email a peppino82gi@gmail.com (tramite API o EmailJS)
      // Dati raccolti:
      // - SKU: widget.skuProdotto
      // - Nome: _nomeController.text
      // - Indirizzo: ${_indirizzoController.text} N. ${_civicoController.text}, ${_capController.text}
      // - Telefono: _telefonoController.text

      await Future.delayed(const Duration(seconds: 15)); // Simula invio di rete

      setState(() {
        _isLoading = false;
      });

      // Mostra messaggio di successo
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
                Navigator.of(context).pop(); // Chiude il dialog
                // Reindirizza alla Home Page rimuovendo le schermate precedenti
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completa Ordine (SKU: ${widget.skuProdotto})"),
        backgroundColor: const Color(0xFF1B365D),
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
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _capController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CAP *'),
                      validator: (value) =>
                          value!.isEmpty ? 'Obbligatorio' : null,
                    ),
                  ),
                ],
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
