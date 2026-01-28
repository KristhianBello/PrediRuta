# PrediRuta 🚦  
Sistema de Predicción de Tráfico Vehicular con Inteligencia Artificial  

## 📌 Descripción
**PrediRuta** es un sistema universitario que combina **Inteligencia Artificial** y **datos de tráfico en tiempo real** para predecir la congestión vehicular y sugerir rutas óptimas en ciudades ecuatorianas, con enfoque especial en Manta.

El sistema está compuesto por:
- **Frontend Web** (Next.js 14 + React 18)
- **Backend API** (FastAPI con Python 3.13)
- **ChatAgent** (Microservicio de IA conversacional con Google Gemini)
- **Base de datos** (PostgreSQL con PostGIS en Supabase)

## 🎯 Objetivos
- 🎯 **Análisis en Tiempo Real**: Procesar datos de tráfico actuales y patrones históricos
- 🧠 **Predicción con IA**: Utilizar modelos de Machine Learning para predecir congestión
- 🗺️ **Optimización de Rutas**: Sugerir las rutas más rápidas y alternativas viables
- 💬 **Asistente Inteligente**: Chatbot con IA para consultas de movilidad urbana
- 📊 **Visualización de Datos**: Interfaz intuitiva con mapas interactivos
- 📱 **Accesibilidad**: Sistema responsive para escritorio y móvil  

## 🏗️ Arquitectura del Proyecto
```
PrediRuta/
├── frontend/              # Interfaz Web (Next.js 14 + React 18 + TailwindCSS)
│   ├── src/
│   │   ├── app/          # App Router de Next.js
│   │   ├── components/   # Componentes reutilizables
│   │   ├── lib/          # Utilidades y clientes (Supabase, API)
│   │   ├── hooks/        # React Hooks personalizados
│   │   └── styles/       # Estilos globales
│   ├── public/           # Recursos estáticos
│   └── package.json
│
├── backend/              # API REST con FastAPI
│   ├── app/
│   │   ├── routes/      # Endpoints API
│   │   ├── services/    # Lógica de negocio
│   │   ├── models/      # Modelos Pydantic
│   │   └── config/      # Configuración
│   ├── data/            # Dataset de tráfico Ecuador
│   ├── requirements.txt
│   └── Dockerfile
│
├── ChatAgent/           # Microservicio IA conversacional
│   ├── app/
│   │   ├── api/        # Endpoints de chat
│   │   ├── core/       # Cliente Google Gemini
│   │   └── services/   # Lógica del agente
│   ├── requirements.txt
│   └── Dockerfile
│
├── database/            # Scripts y gestión de BD
│   ├── prediruta_schema.sql
│   └── db_manager.py
│
├── docs/                # Documentación del proyecto
│   ├── DOCUMENTACION_COMPLETA.md
│   ├── diagramas/
│   └── document/
│
├── docker-compose.yml   # Orquestación de contenedores
├── LICENSE              # Licencia MIT en español
└── README.md
```

### Componentes del Sistema

- **Frontend (Next.js 14)** → Interfaz de usuario, mapas interactivos (Mapbox/Leaflet), autenticación
- **Backend (FastAPI)** → API REST, predicciones ML, servicios Mapbox, gestión de historial
- **ChatAgent (Google Gemini)** → Asistente conversacional para consultas de movilidad urbana
- **Base de datos (Supabase)** → PostgreSQL con PostGIS para datos geoespaciales
- **Contenedores (Docker)** → Entorno de desarrollo y despliegue unificado  

## ⚙️ Tecnologías Utilizadas

### Frontend
- **Node.js**: 22.18.0
- **Next.js**: 14.2.33 (App Router)
- **React**: 18.3.1
- **TypeScript**: 5.Ejecución

### Requisitos Previos
- Node.js 22.18.0 o superior
- Python 3.13.7 o superior
- Docker y Docker Compose (opcional)
- Cuenta en Supabase
- API Keys: Mapbox, Google Gemini

### 1. Clonar Repositorio
```bash
git clone https://github.com/AnThony69x/PrediRuta.git
cd PrediRuta
```

### 2. Configurar Variables de Entorno

Crear archivo `.env` en la raíz del proyecto:

```env
# Supabase
SUPABASE_URL=tu-proyecto.supabase.co
SUPABASE_KEY=tu-service-role-key
NEXT_PUBLIC_SUPABASE_URL=tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-anon-key

# Mapbox
MAPBOX_ACCESS_TOKEN=tu-mapbox-token

# Google Gemini
GEMINI_API_KEY=tu-gemini-api-key

# Backend
TRAFFIC_API_KEY=tu-traffic-api-key
FRONTEND_ORIGIN=http://localhost:3000
```

### 3. Opción A: Instalación con Docker (Recomendado)

```bash
# Levantar todos los servicios
docker-compose up --build

# Acceder a:
# - Frontend: http://localhost:3000
# - Backend API: http://localhost:8000/docs
# - ChatAgent: http://localhost:8001/docs
```

### 4. Opción B: Instalación Manual

#### Frontend
```bash
cd frontend
npm install
npm run dev
# Disponible en http://localhost:3000
```✨ Características Principales

- ✅ Cálculo de rutas optimizadas con múltiples alternativas
- ✅ Predicción de tráfico con Machine Learning
- ✅ Historial de rutas consultadas
- ✅ Sistema de rutas favoritas
- ✅ Estadísticas y métricas de uso
- ✅ Chatbot inteligente para consultas de movilidad
- ✅ Mapas interactivos con visualización de tráfico
- ✅ Autenticación segura con Supabase Auth
- ✅ Interfaz responsive (escritorio y móvil)
- ✅ Exportación de datos en múltiples formatos

## 📊 Datos Utilizados

- **Dataset Ecuador**: Datos históricos de tráfico vehicular en ciudades ecuatorianas
- **Mapbox Traffic**: Datos de tráfico en tiempo real
- **Datos Geoespaciales**: PostGIS para consultas espaciales eficientes
- **Patrones Históricos**: Análisis de tráfico por hora, día, eventos especiales
```bash
cd backend
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
# Disponible en http://localhost:8000
```

#### ChatAgent
```bash
cd ChatAgent
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8001
# Disponible en http://localhost:8001
```

### 5. Configurar Base de Datos

1. Crear proyecto en [Supabase](https://supabase.com)
2. Ejecutar el script SQL en el SQL Editor:
```bash
database/prediruta_schema.sql
```
3. Configurar autenticación en Supabase Dashboard
- **Uvicorn**: Servidor ASGI

### Base de Datos
- **PostgreSQL**: 14+ (via Supabase)
- **PostGIS**: Extensión geoespacial
- **Supabase**: Backend as a Service

### APIs Externas
- **Mapbox Directions API**: Cálculo de rutas
- **Mapbox Geocoding API**: Conversión dirección ↔ coordenadas
- **Mapbox Static Images API**: Imágenes de mapas
- **Google Gemini API**: IA conversacional

### DevOps
- **Docker**: Contenedorización
- **Docker Compose**: Orquestación local
- **Git & GitHub**: Control de versiones  

## 🚀 Instalación y ejecución

### 1. Clonar repositorio
```bash
git clone https://github.com/AnThony69x/PrediRuta.git
cd prediruta
```

### 2. Configurar variables de entorno

Toda la documentación técnica se encuentra en la carpeta `/docs`:

- **DOCUMENTACION_COMPLETA.md**: Documentación completa del sistema (1000+ líneas)
- **Arquitectura del Sistema**: Diagramas y flujos de datos
- **API Documentation**: Especificación completa de endpoints
- **Guía de Instalación**: Instrucciones detalladas de configuración
- **Guía de Desarrollo**: Estándares de código y contribución
- **Manual de Despliegue**: Instrucciones para producción

## 🔒 Seguridad

- Autenticación con Supabase Auth
- Row Level Security (RLS) en base de datos
- Encriptación de datos sensibles
- CORS configurado correctamente
- Rate limiting en API endpoints
- Validación de datos con Pydantic

## 🧪 Testing

```bash
# Frontend
cd frontend
npm test
npm run test:coverage

# Backend
cd backend
pytest
pytest --cov=app tests/
```

## 📝 Licencia

Este proyecto está bajo la Licencia MIT en español. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Equipo de Desarrollo

Proyecto universitario desarrollado por:
- **Anthony Mejia** - Desarrollador Full Stack
- **Kristhin Bello** - Desarrollador Full Stack
- **Jesus Montes** - Desarrollador Full Stack

**Institución:** Universidad Laica de Eloy Alfaro de Manabí (ULEAM)  
**Carrera:** Ingeniería en Software  
**Ubicación:** Manta, Ecuador

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'feat: add amazing feature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📧 Contacto

- **Repositorio**: [github.com/AnThony69x/PrediRuta](https://github.com/AnThony69x/PrediRuta)
- **Issues**: [github.com/AnThony69x/PrediRuta/issues](https://github.com/AnThony69x/PrediRuta/issues)

---

⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub!
## 📊 Datos utilizados
- **Históricos:** datasets simulados o abiertos de movilidad en Ecuador.  
- **Tiempo real:** integración con la API de **Google Maps Traffic Layer**.  

## 📄 Documentación
Toda la documentación técnica y académica se encuentra en la carpeta `/docs`:
- Diagramas UML.  
- Informe de accesibilidad y usabilidad.  
- Evaluación de arquitectura y despliegue.  

## 👨‍💻 Autores
Proyecto universitario desarrollado por:  
- **Anthony Mejia** 
- **Kristhin Bello** 
- **Jesus Montes** 
- Universidad Laica de Eloy Alfaro de Manabí – Carrera de Ingeniería en Software.  
