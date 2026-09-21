import 'package:flutter/material.dart';

class TerminiScreen extends StatelessWidget {
  const TerminiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termini e Condizioni'),
        backgroundColor: const Color(0xFF1B365D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo Principale (h1)
            const Text(
              'Termini e Condizioni del Servizio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 16),

            // Paragrafi introduttivi
            const Text(
              'Benvenuto su Ricambiveloce.it. Al fine di garantire la massima trasparenza, correttezza e tutela dei nostri clienti commerciali e privati sul territorio di Catania, di seguito vengono illustrate le condizioni generali che regolano il nostro servizio espresso di fornitura ricambi.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'La nostra filosofia aziendale si basa sulla fiducia reciproca e sulla totale eliminazione dei rischi per chi acquista. Per questo motivo, abbiamo strutturato condizioni contrattuali uniche, flessibili e orientate alla massima serenità del cliente.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const Divider(height: 35, thickness: 1),

            // Sezione 1 (h2)
            const Text(
              '1. Massima Serenità: Pagamento Esclusivamente alla Consegna',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A differenza delle comuni piattaforme di e-commerce, Ricambi Veloce non richiede alcun pagamento anticipato online, né l\'inserimento di carte di credito. L\'intero importo dell\'ordine verrà corrisposto in contanti direttamente al nostro incaricato express solo nel momento in cui il pezzo di ricambio viene consegnato fisicamente nelle tue mani. Questo azzera ogni rischio di frode o attesa per merce non spedita.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 2 (h2)
            const Text(
              '2. Garanzia "Zero Rischi": Controllo in Loco e Diritto di Ripensamento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sappiamo che acquistare il componente esatto per un elettrodomestico può generare dubbi tecnici. Per questo offriamo una tutela straordinaria: puoi visionare il pezzo di ricambio direttamente al momento della consegna.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Elenchi puntati (li)
            _buildBulletPoint(
              'Se il pezzo non è adatto: Se verifichi che il componente non è compatibile con il modello del tuo elettrodomestico, puoi rifiutare la consegna all\'istante senza dover pagare il costo del ricambio.',
            ),
            _buildBulletPoint(
              'Se cambi idea: Se nel frattempo hai deciso di non effettuare più la riparazione o hai risolto diversamente, sei totalmente libero di non accettare la merce.',
            ),
            _buildBulletPoint(
              'Un piccolo contributo di trasparenza: In caso di mancata accettazione del ricambio (per errore di compatibilità o semplice ripensamento), l\'unico importo dovuto sarà un contributo fisso di soli 5,00 € per la copertura parziale del servizio express di trasporto e logistica sul territorio di Catania.',
            ),

            const SizedBox(height: 12),
            const Text(
              'Questa opzione rappresenta un vantaggio esclusivo: con un costo minimo inferiore a quello di una comune spedizione o del carburante per recarsi in negozio, hai la libertà di valutare il ricambio sulla porta di casa tua.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 3 (h2)
            const Text(
              '3. Servizio Clienti e Prevenzione Errori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Per operare in totale sicurezza ed evitare anche il piccolo contributo di uscita di 5,00 €, Ricambi Veloce mette a disposizione un servizio di consulenza preventiva totalmente gratuito via WhatsApp. Inviando la foto della targhetta tecnica del tuo elettrodomestico prima dell\'ordine, i nostri tecnici verificheranno l\'esatta corrispondenza dei codici di fabbrica, garantendoti una consegna mirata al 100%.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget di supporto per creare i punti elenco in modo ordinato
  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFE67E22),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
