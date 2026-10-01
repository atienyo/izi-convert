# IziConvert (izi-convert)

> Convertisseur universel de documents (300+ formats) pour 0,90 $ USD — Rapide, sécurisé et sans abonnement récurrent.

## 🚀 Fonctionnalités

- **Conversion haute fidélité** : PDF, Word, Excel, PowerPoint, Images, EPUB, CSV, TXT, etc.
- **Paiement unique (0,90 $ USD)** : Sans engagement ni abonnement caché.
- **Moyens de paiement intégrés** :
  - Carte bancaire & Stripe (3D Secure, PCI-DSS Level 1)
  - Stripe Link (Paiement 1-clic)
  - Mobile Money Afrique Francophone (Wave, Orange Money, MTN MoMo, Moov Money, Airtel, Free Money)
  - Apple Pay & Google Pay (Validation biométrique Face ID / Touch ID)
  - PayPal
  - Mode Démonstration (Test instantané offert)
- **Facturation automatique** : Téléchargement de reçu / facture officielle au format PDF conforme.
- **Sécurité et confidentialité** : Chiffrement SSL 256-bit, suppression automatique sous 24h.
- **Bilingue complet** : Français / Anglais avec bascule instantanée.
- **Design moderne & ultra-responsive** : Compatible tous écrans (mobile, tablette, desktop).

## 🛠️ Stack Technique

- **Frontend** : HTML5 sémantique, CSS3 (Glassmorphism, animations modernes), Vanilla JavaScript haute performance.
- **Librairies embarquées** : jsPDF, Canvas, PDF.js, etc.
- **Base de données** : Supabase (PostgreSQL, Row Level Security).
- **Serveur local** : Node.js standard (`local-server.js`).

## 📦 Lancement en local

```bash
# Lancer le serveur local
node local-server.js
# Ou via npm
npm run dev
```

Le serveur sera disponible sur `http://localhost:3000/`.

## 🗄️ Schéma Supabase

Le schéma complet de la base de données est disponible dans `supabase_schema.sql` et dans `supabase/migrations/`.

## 📄 Licence

MIT
