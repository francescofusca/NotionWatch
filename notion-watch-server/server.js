console.log("1. Inizio del file server.js");

require('dotenv').config();
console.log("2. dotenv caricato correttamente");

const express = require('express');
console.log("3. Express caricato");

//const cloudinary = require('cloudinary').v2; RIMUOVO CONFIGURAZIONE GLOBALE
const { Client } = require('@notionhq/client');
console.log("5. Notion client caricato");

const app = express();
console.log("6. Express app creata");

const multer = require('multer');
console.log("7. Multer caricato");

const upload = multer({ dest: 'uploads/' });
console.log("8. Multer configurato");


const { promises: fs } = require('fs'); // IMPORTAZIONE CORRETTA di fs.promises


app.post('/upload', upload.single('audio'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send('Nessun file caricato.');
    }

    // Recupera la descrizione dal body della richiesta
    const description = req.body.description || "Nota Audio da Watch"; // Usa un valore di default
    const apiKey = req.body.apiKey; //Prendo la API KEY Notion
    const databaseId = req.body.databaseId; //Prendo il database ID Notion
    const cloudinaryCloudName = req.body.cloudinaryCloudName; //Prendo Cloudinary Cloud Name
    const cloudinaryApiKey = req.body.cloudinaryApiKey; //Prendo Cloudinary API Key
    const cloudinaryApiSecret = req.body.cloudinaryApiSecret; //Prendo Cloudinary API Secret


      // Errori se mancano API KEY e DATABASE ID Notion
      if (!apiKey || !databaseId) {
          return res.status(400).send("Credenziali Notion mancanti.");
      }
      // Errori se mancano le credenziali Cloudinary
      if (!cloudinaryCloudName || !cloudinaryApiKey || !cloudinaryApiSecret) {
          return res.status(400).send("Credenziali Cloudinary mancanti.");
      }


    //Configurazione Notion
      const notion = new Client({ auth: apiKey }); //Uso la variabile, non più process.env

    // Configurazione di Cloudinary (DINAMICA, PER UTENTE)
      const cloudinary = require('cloudinary').v2;
        cloudinary.config({
          cloud_name: cloudinaryCloudName, //Uso variabili dalla request!
          api_key: cloudinaryApiKey,
          api_secret: cloudinaryApiSecret,
        });


    // Upload del file su Cloudinary
    const result = await cloudinary.uploader.upload(req.file.path, {
      resource_type: 'auto',
    });

    // Elimino il file temporaneo
    await fs.unlink(req.file.path);

    // Creazione della pagina Notion
    const response = await notion.pages.create({
      parent: { database_id: databaseId }, //Uso la variabile
      properties: {
        Name: {
          title: [{ text: { content: description } }], // USA LA DESCRIZIONE!
        },
        URL: {
          url: result.secure_url,
        },
      },
    });

    console.log('Pagina Notion creata:', response.id);
    res.status(200).json({
      message: 'File caricato e pagina Notion creata.',
      notionPageId: response.id,
      cloudinaryUrl: result.secure_url,
    });
  } catch (error) {
    console.error('Errore:', error);
    //Elimino il file temporaneo
     if(req.file){
         await fs.unlink(req.file.path);
     }
    res.status(500).send('Errore del server.');
  }
});

const port = process.env.PORT || 3000;
console.log("11. Porta definita:", port);

app.listen(port, () => {
  console.log(`Server in ascolto sulla porta ${port}`);
});
console.log("12. Dopo app.listen");