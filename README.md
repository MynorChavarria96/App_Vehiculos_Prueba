# App_Vehiculos_Prueba

Esta aplicación móvil permite gestionar una concesionaria de vehículos, incluyendo el registro, edición, eliminación y visualización de vehículos con sus respectivas marcas y modelos.

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Firebase**: 
  - Authentication: Para gestión de usuarios y autenticación
  - Storage: Para almacenamiento de imágenes
- **Provider**: Para gestión del estado de la aplicación
- **Image Picker**: Para la selección de imágenes desde la galería
- **REST API**: Para la gestión de datos (marcas, modelos y vehículos)

## Requisitos Previos

1. Flutter SDK (versión 3.0.0 o superior)
2. Dart SDK
3. Android Studio o VS Code con las extensiones de Flutter y Dart
4. Git
5. Un dispositivo físico o emulador para pruebas
6. Cuenta de Firebase

## Configuración del Proyecto

1. Clonar el repositorio:
```bash
git clone [url-del-repositorio]
cd app_vehiculos
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Configurar Firebase:
   - Crear un nuevo proyecto en la [consola de Firebase](https://console.firebase.google.com)
   - Agregar una aplicación Android/iOS
   - Descargar y reemplazar el archivo `google-services.json` en la carpeta `android/app/`
   - Asegurarse de que el archivo `lib/config/firebase_options.dart` esté actualizado

4. Configurar la API:
   - Actualizar la URL base de la API en `lib/config/api_config.dart`
actualmente se encuentra desplegada, se puede utilizar la url que contiene.


## Características Principales

- Autenticación de usuarios (registro e inicio de sesión)
- Gestión de vehículos:
  - Crear, editar y eliminar vehículos
  - Subir y mostrar imágenes de vehículos
  - Selección de marca y modelo
  - Visualización en lista o cuadrícula
- Búsqueda de vehículos por:
  - Nombre
  - Marca
  - Modelo
  - Placa
- Interfaz de usuario intuitiva y responsive

## Ejecución del Proyecto

1. Asegurarse de tener un dispositivo conectado o un emulador en ejecución:
```bash
flutter devices
```

2. Ejecutar la aplicación:
```bash
flutter run
```

## Problemas Comunes y Soluciones

1. **Error de Firebase**: 
   - Verificar que `google-services.json` esté correctamente ubicado
   - Comprobar la configuración en `firebase_options.dart`

2. **Error de API**:
   - Verificar la URL base en `api_config.dart`
   - Comprobar la conectividad a internet

3. **Error de dependencias**:
```bash
flutter clean
flutter pub get
```

