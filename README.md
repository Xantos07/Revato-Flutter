# Revato

Revato est une application multiplateforme permettant la prise de notes sur les rêves réalisés pendant la nuit.
Elle a pour objectif de faciliter la rédaction avec la plus grande simplicité et le plus rapidement possible, afin d’archiver les rêves pour les relire plus tard.

Par la suite, des graphiques sont prévus pour analyser les éléments récurrents et les mettre en relation, afin de visualiser les différentes influences.


## 📂 Structure du projet

Le projet comporte deux grandes parties : l’une concernant l’API, et l’autre, l’application côté front.

```text
Revato-flutter/
├── api/
├── app/
├── caddy/
├── php/
├── .gitignore
├── compose.yaml
└── README.md
```


---

## 🚀 Installation et Exécution

### 1️⃣ Prérequis
- **Docker & Docker Compose** installés
- **Flutter** installés

Par la suite, Flutter sera intégré dans Docker. Je continue mes recherches pour pouvoir faire un build Flutter sous Docker sans que cela pose de souci. ^^
### 2️⃣ Installation
Cloner le dépôt :
```bash
git clone https://github.com/Xantos07/Revato-Flutter.git
cd Revato-Flutter
```

Initialisation pour un build:
```bash
docker-compose build 
```

Lancement du build:
```bash
docker-compose up -d
```

---

Schéma de la base de donnée :



Schéma Docker  :



---

## 🛠️ Technologies & Justification

| Technologie          | Raison du choix                                                              |
|----------------------|------------------------------------------------------------------------------|
| **Docker / Compose** | Isolation des services et portabilité ; déploiement rapide et reproductible. |
| **MariaDB**          | Système de gestion de base de données relationnelle robuste et open source, idéal<br/> pour stocker des données structurées de manière fiable, avec de bonnes performances et une large compatibilité.           |
| **Flutter**          | Framework multiplateforme performant permettant de développer une application <br/>mobile et web avec une base de code unique, garantissant une interface fluide et moderne.                                                               |
| **Synfony**          | Framework PHP robuste et modulaire, idéal pour structurer une API backend <br/>sécurisée, maintenable et conforme aux bonnes pratiques.                                                               |
| **Git**              | Système de contrôle de version distribué permettant une gestion efficace du code <br/>source, le travail en équipe, le suivi des modifications et l'intégration continue                       |

---

Accée au container Synfony
```bash
docker exec -it php82_revato bash
```

Build sur navigateur : 
```bash
flutter run -d chrome --web-hostname=localhost --web-port=9000 
```


Get device id : 
```bash
flutter devices
```

Build directement sur l'appareil en question :
```bash
flutter run -d idOfDevice 
```

Build un APK pour android
```bash
flutter build apk --release
```

Build pour IOS
```bash
flutter build ios --release
```