📱 Flutter Frontend Project
Este repositorio contiene el código fuente de la interfaz móvil. Está construido siguiendo buenas prácticas de desarrollo modular y tipado estricto para asegurar un rendimiento óptimo en Android e iOS.

🛠️ Requisitos Previos
Antes de empezar, asegúrate de tener instalado lo siguiente:

Flutter SDK: ^3.x.x (Versión estable)

Dart SDK: ^3.x.x

IDE: VS Code (recomendado) o Android Studio.

Herramientas de entorno:

CocoaPods (Solo para usuarios de macOS/iOS).

Android SDK & Build Tools.

🚀 Guía de Instalación
Sigue estos pasos para tener el entorno listo en tu máquina local:

1. Clonar el repositorio
Bash
git clone https://github.com/tu-usuario/tu-proyecto-flutter.git
cd tu-proyecto-flutter
2. Instalar dependencias
Descarga todos los paquetes necesarios definidos en el pubspec.yaml:

Bash
flutter pub get
3. Configuración de Pods (Solo iOS)
Si estás en una Mac y vas a probar en simulador de iPhone o dispositivo físico:

Bash
cd ios
pod install
cd ..
4. Selección de variables de entorno
Si el proyecto usa un archivo de configuración (como .env o assets/config.json), asegúrate de crear una copia basada en el ejemplo:

Bash
cp .env.example .env
🏃 Lanzamiento
Para ejecutar la aplicación en modo debug:

Desde la terminal:

Bash
flutter run
Para un dispositivo específico:

Bash
# Listar dispositivos conectados
flutter devices

# Ejecutar en uno específico
flutter run -d <DEVICE_ID>
📂 Estructura del Directorio lib/
Para mantener el orden, el frontend se organiza de la siguiente manera:

assets/: Imágenes, fuentes y archivos JSON.

lib/screens/: Screens (Vistas) y Widgets reutilizables.

lib/providers/: Manejo de estados (Providers).

lib/services/: Llamadas a APIs y servicios externos.

lib/models/: Definición de clases de datos y serialización.

Nota: Si encuentras errores de compilación, intenta limpiar el caché con flutter clean y vuelve a ejecutar flutter pub get.