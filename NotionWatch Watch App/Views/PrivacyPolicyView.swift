//  NotionWatch/Views/PrivacyPolicyView.swift
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode // Per chiudere la view

    //TODO: Sostituisci con la TUA informativa sulla privacy
    let privacyPolicyText = """
    Informativa sulla Privacy di NotionWatch

    Ultimo aggiornamento: 18 maggio 2024

    1. Introduzione

    NotionWatch è un'applicazione per Apple Watch sviluppata da Francesco Fusca che ti permette di registrare note audio e salvarle direttamente nel tuo spazio di lavoro Notion. Questa Informativa sulla Privacy spiega quali dati personali raccogliamo, come li utilizziamo, con chi li condividiamo e quali sono i tuoi diritti in relazione ai tuoi dati.

    2. Dati Raccolti

    NotionWatch raccoglie i seguenti dati personali:

        *   **Informazioni di Autenticazione (Firebase):**
            *   Indirizzo email: Utilizzato per creare e gestire il tuo account utente tramite Firebase Authentication.
            *   Password: Utilizzata per proteggere il tuo account utente (memorizzata in forma crittografata da Firebase).
            *   User ID: Un identificatore univoco generato da Firebase e associato al tuo account.
        *   **Credenziali Notion:**
            *   API Key di Notion: Un token segreto che permette all'app di accedere al tuo account Notion. Questa chiave viene fornita da te e memorizzata *localmente* sul tuo dispositivo tramite UserDefaults.
            *   Database ID di Notion: Un identificatore univoco del database Notion in cui vuoi salvare le note audio. Questo ID viene fornito da te e memorizzato *localmente* sul tuo dispositivo tramite UserDefaults.
        *   **Registrazioni Audio:**
            *   File Audio: I file audio delle tue note vocali, registrati tramite l'app e memorizzati su Cloudinary.
        * **Descrizioni testuali:**
            *   Testo: Il testo che inserisci come descrizione delle note audio (dettato o digitato), inviato a Notion.

        *   **Informazioni sul Dispositivo (NON RACCOLTE - Conferma):**
          Allo stato attuale, l'applicazione NON raccoglie in modo automatico informazioni specifiche sul dispositivo, come il modello o la versione del sistema operativo, tranne le informazioni strettamente necessarie a Firebase Auth per funzionare.

    3. Utilizzo dei Dati

    Utilizziamo i dati raccolti *esclusivamente* per le seguenti finalità:

        *   **Fornire il Servizio:**
            *   Per permetterti di registrare note audio.
            *   Per salvare le note audio (file audio e descrizione) nel tuo spazio di lavoro Notion, tramite l'uso della tua API Key e del Database ID.
            *   Per autenticarti e gestire il tuo account utente tramite Firebase Authentication.
        *   **Comunicazioni:**
            *   Per inviarti notifiche relative all'app (es. conferma di salvataggio, errori, aggiornamenti importanti).
            *   Per rispondere alle tue richieste di supporto (se ci contatti).

    4. Condivisione dei Dati

    Condividiamo i tuoi dati con i seguenti fornitori di servizi terzi, *esclusivamente* per le finalità indicate:

        *   **Firebase (Google):**
            *   Firebase Authentication: Per la gestione dell'autenticazione utente (email, password, user ID). I dati sono memorizzati sui server di Google (Firebase) negli Stati Uniti o in altre regioni in cui Google ha delle infrastrutture. Google agisce come responsabile del trattamento dei dati per nostro conto. Puoi consultare l'informativa sulla privacy di Google qui: [https://policies.google.com/privacy](https://policies.google.com/privacy)
        *   **Cloudinary:**
            *   Per l'hosting dei file audio. I file audio vengono caricati sui server di Cloudinary. Cloudinary agisce come responsabile del trattamento dei dati per nostro conto. Puoi consultare l'informativa sulla privacy di Cloudinary qui: [https://cloudinary.com/privacy](https://cloudinary.com/privacy)
        *   **Notion:**
            *   Per salvare le note audio (come URL di Cloudinary) e le descrizioni nel tuo spazio di lavoro Notion. Notion agisce come responsabile del trattamento dei dati per nostro conto. Puoi consultare l'informativa sulla privacy di Notion qui: [https://www.notion.so/privacy_policy](https://www.notion.so/privacy_policy)

        *Non* vendiamo, affittiamo o condividiamo i tuoi dati personali con terze parti per scopi di marketing.

    5. Base Giuridica del Trattamento (GDPR)

    Se ti trovi nello Spazio Economico Europeo (SEE), il trattamento dei tuoi dati personali si basa sulle seguenti basi giuridiche, ai sensi del Regolamento Generale sulla Protezione dei Dati (GDPR):

        *   **Esecuzione di un Contratto:** Il trattamento dei dati è necessario per fornirti il servizio (registrazione e salvataggio delle note audio su Notion), come descritto nei Termini di Servizio [Inserisci un link ai tuoi Termini di Servizio, se li hai].
        *   **Consenso:** Non raccogliamo dati in base al consenso.
        *  **Legittimo interesse:** Non raccogliamo dati per legittimo interesse.

    6. Conservazione dei Dati

    Conserviamo i tuoi dati personali per il tempo necessario a fornirti il servizio e per le finalità indicate in questa Informativa sulla Privacy:

        *   **Account Firebase:** I dati del tuo account Firebase (email, User ID) vengono conservati finché non elimini il tuo account tramite l'apposita funzione nell'app.
        *   **Credenziali Notion:** La tua API Key e il tuo Database ID vengono conservati *localmente* sul tuo dispositivo finché non effettui il logout, elimini il tuo account, o disinstalli l'app.
        *   **Registrazioni Audio:** I file audio vengono conservati su Cloudinary in base alle impostazioni predefinite.
        * **Descrizioni testuali:** Le descrizioni sono memorizzate su Notion.

    7. I Tuoi Diritti

    Hai i seguenti diritti in relazione ai tuoi dati personali:

        *   **Accesso:** Hai il diritto di accedere ai tuoi dati personali e di richiederne una copia.  Puoi accedere alla tua email tramite le impostazioni del tuo account Firebase. Puoi accedere alle tue note audio e descrizioni tramite Notion.  Puoi accedere alla tua API Key e al tuo Database ID tramite le impostazioni dell'app.
        *   **Rettifica:** Hai il diritto di richiedere la correzione di dati inesatti o incompleti. Puoi modificare la tua email tramite le impostazioni del tuo account Firebase. Puoi modificare la tua API Key e il tuo Database ID tramite le impostazioni dell'app. Puoi modificare le tue note audio e descrizioni tramite Notion.
        *   **Cancellazione ("Diritto all'Oblio"):** Hai il diritto di richiedere la cancellazione dei tuoi dati personali.  Puoi eliminare il tuo account Firebase tramite l'apposita funzione nell'app.  Questo eliminerà la tua email e il tuo User ID da Firebase.  Puoi eliminare le tue note audio da Cloudinary e Notion.  La tua API Key e il tuo Database ID verranno eliminati dal tuo dispositivo quando elimini il tuo account, effettui il logout o disinstalli l'app.
        *   **Limitazione del Trattamento:** Hai il diritto di richiedere la limitazione del trattamento dei tuoi dati, in determinate circostanze. Contattaci per richiederlo.
        *   **Portabilità dei Dati:**  Questo diritto non è pienamente applicabile nel contesto di quest'app, poichè i tuoi dati sono salvati in servizi esterni.
        *   **Opposizione:** Hai il diritto di opporti al trattamento dei tuoi dati personali, in determinate circostanze. Contattaci per esercitare questo diritto.
        *   **Revoca del Consenso:** Non raccogliamo dati in base al consenso.

    Per esercitare questi diritti, contattaci all'indirizzo email fornito di seguito.

    8. Sicurezza dei Dati

    Adottiamo misure di sicurezza tecniche e organizzative adeguate per proteggere i tuoi dati personali da accessi non autorizzati, perdite, distruzioni o alterazioni. Queste misure includono:

        *   Crittografia delle password (gestita da Firebase Authentication).
        *   Comunicazione sicura tramite HTTPS tra l'app e il server, e tra il server e i servizi terzi (Cloudinary, Notion).
        *   Memorizzazione locale sicura delle credenziali Notion tramite UserDefaults (che è un meccanismo di memorizzazione sicuro fornito da Apple).
        *   Accesso limitato ai dati: solo il personale autorizzato ha accesso ai tuoi dati, e solo per le finalità indicate in questa informativa.

    9. Modifiche all'Informativa sulla Privacy

    Ci riserviamo il diritto di modificare questa Informativa sulla Privacy in qualsiasi momento. Ti informeremo di eventuali modifiche sostanziali tramite l'app o via email (se possibile). La versione aggiornata sarà sempre disponibile all'interno dell'app, nella sezione Impostazioni.

    10. Contatti

    Per qualsiasi domanda o richiesta relativa a questa Informativa sulla Privacy o al trattamento dei tuoi dati personali, puoi contattarci all'indirizzo:

    NotionWatch, Francesco Fusca
    francescofusca9@gmail.com
    """

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Informativa sulla Privacy")
                    .font(.title)
                    .padding(.bottom)

                Text(privacyPolicyText)
                    .font(.body)
                    .padding()

                Button("Chiudi") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
        }
    }
}
