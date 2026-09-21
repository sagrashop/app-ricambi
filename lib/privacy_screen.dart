import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informativa sulla Privacy'),
        backgroundColor: const Color(0xFF1B365D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo Principale
            const Text(
              'Informativa sulla Privacy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ultimo aggiornamento: 21 settembre 2026',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Introduzione
            const Text(
              'La presente Informativa sulla Privacy descrive come l\'applicazione mobile per la richiesta e l\'ordine di ricambi per elettrodomestici ("l\'App") raccoglie, utilizza e protegge le informazioni personali degli utenti.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const Divider(height: 35, thickness: 1),

            // Sezione 1
            const Text(
              '1. Titolare del Trattamento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Il titolare del trattamento dei dati è il creatore e gestore dell\'applicazione. Per qualsiasi domanda o richiesta relativa alla privacy, puoi contattarci all\'indirizzo email di supporto: info@ricambiveloce.it',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 2
            const Text(
              '2. Quali dati raccogliamo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'L\'App è progettata per permettere agli utenti di verificare la disponibilità e inviare richieste d\'ordine per i ricambi. Durante l\'utilizzo delle funzioni di ordinazione, raccogliamo i seguenti dati personali forniti volontariamente dall\'utente:',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Dati di contatto e identificativi: Nome, Cognome, Indirizzo email, Numero di telefono.',
            ),
            _buildBulletPoint(
              'Dati di spedizione: Indirizzo fisico (via, città, cap, provincia) necessario per l\'invio della merce.',
            ),
            _buildBulletPoint(
              'Dati tecnici dell\'ordine: Modello dell\'elettrodomestico, tipo di ricambio richiesto, codice prodotto o SKU inserito nei campi di ricerca o nel modulo d\'ordine.',
            ),
            const SizedBox(height: 20),

            // Sezione 3
            const Text(
              '3. Come utilizziamo i tuoi dati',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'I dati raccolti vengono utilizzati esclusivamente per le seguenti finalità:',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Gestione ed evasione degli ordini: Per elaborare la richiesta di acquisto o di preventivo del ricambio e ricontattare l\'utente.',
            ),
            _buildBulletPoint(
              'Comunicazioni di servizio: Per inviare aggiornamenti sullo stato dell\'ordine o rispondere a richieste di assistenza.',
            ),
            const SizedBox(height: 8),
            const Text(
              'I dati non vengono utilizzati per finalità di profilazione commerciale e non vengono ceduti, venduti o condivisi con terze parti per scopi pubblicitari.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 4
            const Text(
              '4. Condivisione dei dati e Servizi Terzi (EmailJS)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Per consentire l\'invio della richiesta d\'ordine direttamente dall\'app, utilizziamo servizi di terze parti sicuri, come EmailJS, che gestisce il trasferimento tecnico del messaggio di posta elettronica contenente i dati inseriti dall\'utente. Tali servizi trattano i dati nel rispetto delle normative vigenti sulla protezione dei dati personali.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 5 (AGGIORNATA CON PAGAMENTO ALLA CONSEGNA / NO DATI BANCARI)
            const Text(
              '5. Conservazione, Sicurezza dei Dati e Metodi di Pagamento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adottiamo misure di sicurezza tecniche e organizzative adeguate per proteggere i dati personali da accessi non autorizzati, perdita o alterazione. I dati trasmessi tramite l\'app utilizzano protocolli di connessione protetti (HTTPS/TLS). I dati vengono conservati per il tempo strettamente necessario a gestire l\'evasione dell\'ordine e per adempiere agli obblighi di legge fiscali o amministrativi.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Importante - Pagamenti e Dati Bancari: All\'interno dell\'App non è previsto né consentito inserire alcun metodo di pagamento online (come carte di credito o conti digitali). Di conseguenza, la nostra piattaforma non raccoglie, elabora o memorizza in alcun modo dati bancari o finanziari, in quanto accettiamo esclusivamente il pagamento in contanti alla consegna.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 6
            const Text(
              '6. Diritti dell\'Utente',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ai sensi del Regolamento UE 2016/679 (GDPR), l\'utente ha il diritto di:',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Accedere ai propri dati personali in nostro possesso.',
            ),
            _buildBulletPoint(
              'Richiedere la rettifica o la cancellazione dei dati.',
            ),
            _buildBulletPoint(
              'Opporsi al trattamento o richiederne la limitazione.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Per esercitare questi diritti, è possibile inviare una richiesta all\'indirizzo email: info@ricambiveloce.it',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Sezione 7
            const Text(
              '7. Modifiche a questa Informativa sulla Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ci riserviamo il diritto di aggiornare la presente informativa in qualsiasi momento. Eventuali modifiche saranno pubblicate su questa pagina con l\'aggiornamento della data iniziale.',
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

  // Widget di supporto per gli elenchi puntati
  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
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
