# 📖 Documentación Completa - PrediRuta

## 🚦 Sistema de Predicción de Tráfico Vehicular con Inteligencia Artificial

### Versión 1.0.0
**Última actualización:** 27 de enero de 2026

---

## 📑 Tabla de Contenidos

1. [Visión General del Proyecto](#1-visión-general-del-proyecto)
2. [Arquitectura del Sistema](#2-arquitectura-del-sistema)
3. [Tecnologías Utilizadas](#3-tecnologías-utilizadas)
4. [Componentes del Sistema](#4-componentes-del-sistema)
5. [Base de Datos](#5-base-de-datos)
6. [APIs y Endpoints](#6-apis-y-endpoints)
7. [Instalación y Configuración](#7-instalación-y-configuración)
8. [Guía de Desarrollo](#8-guía-de-desarrollo)
9. [Despliegue](#9-despliegue)
10. [Seguridad y Autenticación](#10-seguridad-y-autenticación)
11. [Testing](#11-testing)
12. [Mantenimiento](#12-mantenimiento)
13. [Roadmap](#13-roadmap)
14. [Créditos y Licencia](#14-créditos-y-licencia)

---

## 1. Visión General del Proyecto

### 1.1 Descripción

**PrediRuta** es un sistema web universitario de predicción de tráfico vehicular que combina **Inteligencia Artificial** y **datos de tráfico en tiempo real** para predecir la congestión vehicular y sugerir rutas óptimas en ciudades ecuatorianas, con enfoque especial en Manta.

### 1.2 Objetivos

- 🎯 **Análisis en Tiempo Real**: Procesar datos de tráfico actuales y patrones históricos
- 🧠 **Predicción con IA**: Utilizar modelos de Machine Learning para predecir congestión
- 🗺️ **Optimización de Rutas**: Sugerir las rutas más rápidas y alternativas viables
- 💬 **Asistente Inteligente**: Chatbot con IA para consultas de movilidad urbana
- 📊 **Visualización de Datos**: Interfaz intuitiva con mapas interactivos
- 📱 **Accesibilidad**: Sistema responsive para escritorio y móvil

### 1.3 Alcance

El sistema está diseñado para:
- Ciudades ecuatorianas (principalmente Manta)
- Usuarios finales: conductores, ciclistas, peatones
- Planificadores urbanos y autoridades de tránsito
- Investigadores en movilidad urbana

### 1.4 Características Principales

#### ✨ Funcionalidades Core
- Cálculo de rutas optimizadas
- Predicción de tráfico con IA
- Historial de rutas consultadas
- Rutas favoritas
- Estadísticas de uso
- Exportación de datos
- Chatbot de consultas urbanas

#### 🔒 Seguridad
- Autenticación con Supabase Auth
- Políticas RLS (Row Level Security)
- Encriptación de datos sensibles
- CORS configurado
- Rate limiting

---

## 2. Arquitectura del Sistema

### 2.1 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │           Frontend - Next.js 14 (React 18)               │  │
│  │  • App Router • TailwindCSS • Mapbox GL • Leaflet        │  │
│  │  • Supabase Client • React Hooks • TypeScript            │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/HTTPS
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    API GATEWAY / NGINX                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                 ┌────────────┴────────────┐
                 ▼                         ▼
┌─────────────────────────────┐  ┌──────────────────────────┐
│  Backend API - FastAPI      │  │  ChatAgent - FastAPI     │
│  Puerto: 8000               │  │  Puerto: 8001            │
│                             │  │                          │
│  • Rutas de tráfico         │  │  • Google Gemini AI      │
│  • Predicciones ML          │  │  • Context Manta         │
│  • Mapbox Services          │  │  • Natural Language      │
│  • Dataset Ecuador          │  │  • Chat Endpoints        │
│  • Historial & Favoritos    │  │                          │
└─────────────────────────────┘  └──────────────────────────┘
         │                                   │
         │                                   │
         ▼                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Supabase (PostgreSQL)                        │
│  • user_profiles           • route_queries                      │
│  • historial_rutas         • route_options                      │
│  • historial_predicciones  • favorite_routes                    │
│  • traffic_data            • road_segments                      │
│  • ml_models               • api_usage                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    APIs EXTERNAS                                │
│  • Mapbox (Directions, Geocoding, Static)                      │
│  • Google Gemini AI                                             │
│  • Traffic Data Providers                                       │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Flujo de Datos Principal

#### Consulta de Ruta
1. Usuario ingresa origen y destino en el Frontend
2. Frontend envía petición a Backend API (`/api/mapbox/directions`)
3. Backend consulta Mapbox Directions API
4. Backend procesa la respuesta y añade predicciones de tráfico
5. Backend guarda la consulta en Supabase (`route_queries`, `route_options`)
6. Frontend recibe las opciones de ruta y las muestra en el mapa
7. Usuario selecciona una ruta
8. Sistema guarda en historial (`historial_rutas`)

#### Predicción de Tráfico
1. Sistema recopila datos históricos de `traffic_data`
2. Modelo ML analiza patrones (hora, día, clima, eventos)
3. Genera predicción de nivel de congestión (1-5)
4. Se integra con las rutas calculadas
5. Usuario visualiza predicción en tiempo real

#### Chat con IA
1. Usuario hace pregunta sobre movilidad en Manta
2. Frontend envía mensaje a ChatAgent (`POST /chat`)
3. ChatAgent procesa con contexto de Manta
4. Google Gemini genera respuesta inteligente
5. Respuesta se muestra en interfaz de chat

### 2.3 Patrones de Diseño Implementados

- **MVC (Model-View-Controller)**: Separación de lógica de negocio
- **Repository Pattern**: Capa de acceso a datos
- **Service Layer**: Lógica de negocio encapsulada
- **Dependency Injection**: FastAPI dependencies
- **Factory Pattern**: Creación de clientes (Mapbox, Supabase)
- **Strategy Pattern**: Diferentes proveedores de tráfico
- **Observer Pattern**: React hooks y estado

---

## 3. Tecnologías Utilizadas

### 3.1 Frontend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Node.js** | 22.18.0 | Runtime JavaScript |
| **Next.js** | 14.2.33 | Framework React con SSR |
| **React** | 18.3.1 | Biblioteca UI |
| **TypeScript** | 5.5.2 | Tipado estático |
| **TailwindCSS** | 3.4.4 | Framework CSS utility-first |
| **Mapbox GL** | 3.1.2 | Mapas interactivos |
| **Leaflet** | 1.9.4 | Alternativa de mapas |
| **Supabase JS** | 2.58.0 | Cliente de Supabase |
| **Lucide React** | 0.544.0 | Iconos |

### 3.2 Backend

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Python** | 3.13.7 | Lenguaje principal |
| **FastAPI** | 0.117.1 | Framework web asíncrono |
| **Uvicorn** | - | Servidor ASGI |
| **Pydantic** | 2.11.9 | Validación de datos |
| **Pandas** | 2.3.2 | Análisis de datos |
| **NumPy** | 2.3.3 | Computación numérica |
| **scikit-learn** | - | Machine Learning |
| **httpx** | 0.28.1 | Cliente HTTP asíncrono |
| **python-dotenv** | 1.1.1 | Variables de entorno |
| **Supabase Client** | - | Acceso a Supabase |

### 3.3 ChatAgent

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Python** | 3.11+ | Lenguaje principal |
| **FastAPI** | - | API REST |
| **Google Gemini** | - | Modelo de IA conversacional |
| **Uvicorn** | - | Servidor ASGI |

### 3.4 Base de Datos

| Tecnología | Propósito |
|------------|-----------|
| **PostgreSQL** | Base de datos relacional (via Supabase) |
| **Supabase** | Backend as a Service |
| **PostGIS** | Extensión geoespacial |

### 3.5 DevOps e Infraestructura

| Tecnología | Propósito |
|------------|-----------|
| **Docker** | Contenedorización |
| **Docker Compose** | Orquestación local |
| **Git** | Control de versiones |
| **GitHub** | Repositorio remoto |
| **Vercel** | Hosting frontend (opcional) |

### 3.6 APIs Externas

| API | Propósito |
|-----|-----------|
| **Mapbox Directions API** | Cálculo de rutas |
| **Mapbox Geocoding API** | Conversión dirección ↔ coordenadas |
| **Mapbox Static Images API** | Imágenes de mapas |
| **Google Gemini API** | IA conversacional |
| **Traffic Data APIs** | Datos de tráfico en tiempo real |

---

## 4. Componentes del Sistema

### 4.1 Frontend (Next.js)

#### 4.1.1 Estructura de Carpetas

```
frontend/src/
├── app/                           # App Router (Next.js 13+)
│   ├── (auth)/                   # Rutas de autenticación
│   │   ├── login/
│   │   ├── register/
│   │   └── reset-password/
│   ├── dashboard/                # Dashboard principal
│   ├── rutas/                    # Cálculo de rutas
│   ├── historial/                # Historial de rutas
│   ├── favoritos/                # Rutas favoritas
│   ├── predicciones/             # Predicciones de tráfico
│   ├── chat/                     # Chat con IA
│   ├── perfil/                   # Perfil de usuario
│   ├── layout.tsx                # Layout principal
│   ├── page.tsx                  # Página de inicio
│   └── globals.css               # Estilos globales
├── components/                    # Componentes reutilizables
│   ├── ui/                       # Componentes UI base
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── card.tsx
│   │   └── ...
│   ├── layout/                   # Componentes de layout
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   └── Footer.tsx
│   ├── maps/                     # Componentes de mapas
│   │   ├── MapContainer.tsx
│   │   ├── RouteMap.tsx
│   │   └── TrafficLayer.tsx
│   └── chat/                     # Componentes de chat
│       ├── ChatWindow.tsx
│       └── MessageBubble.tsx
├── lib/                          # Utilidades y SDKs
│   ├── supabase.ts              # Cliente Supabase
│   ├── api.ts                   # Cliente API backend
│   └── history-service.ts       # Servicio de historial
├── hooks/                        # React Hooks personalizados
│   ├── useAuth.ts
│   ├── useHistory.ts
│   └── useRoutes.ts
├── types/                        # Definiciones TypeScript
│   ├── route.ts
│   ├── traffic.ts
│   └── user.ts
├── utils/                        # Funciones auxiliares
│   ├── formatters.ts
│   └── validators.ts
└── styles/                       # Estilos adicionales
    └── maps.css
```

#### 4.1.2 Componentes Clave

##### MapContainer.tsx
Contenedor principal de mapas con soporte para Mapbox GL y Leaflet.

**Props:**
- `center: [lat, lng]` - Centro inicial del mapa
- `zoom: number` - Nivel de zoom
- `routes: Route[]` - Rutas a mostrar
- `markers: Marker[]` - Marcadores a mostrar

##### RouteMap.tsx
Visualización de rutas con niveles de tráfico.

**Features:**
- Renderizado de polilíneas
- Colores según nivel de tráfico
- Marcadores de origen/destino
- Tooltips informativos

##### ChatWindow.tsx
Interfaz de chat con el agente IA.

**Features:**
- Historial de conversación
- Indicador de escritura
- Envío de mensajes
- Scroll automático

#### 4.1.3 Hooks Personalizados

##### useAuth
```typescript
const { user, signIn, signOut, signUp, loading } = useAuth();
```

##### useHistory
```typescript
const { 
  history, 
  addToHistory, 
  deleteFromHistory, 
  clearHistory,
  loading 
} = useHistory();
```

##### useRoutes
```typescript
const {
  routes,
  calculateRoutes,
  selectRoute,
  selectedRoute,
  loading,
  error
} = useRoutes();
```

### 4.2 Backend (FastAPI)

#### 4.2.1 Estructura de Carpetas

```
backend/
├── app/
│   ├── main.py                   # Punto de entrada FastAPI
│   ├── config.py                 # Configuración global
│   ├── database.py               # Conexión a Supabase
│   ├── routes/                   # Endpoints API
│   │   ├── auth.py              # Autenticación
│   │   ├── traffic.py           # Tráfico
│   │   ├── mapbox.py            # Servicios Mapbox
│   │   ├── dataset.py           # Dataset Ecuador
│   │   ├── predictions_real.py  # Predicciones
│   │   └── routes_history_real.py # Historial
│   ├── services/                # Lógica de negocio
│   │   ├── mapbox_directions.py
│   │   ├── mapbox_geocoding.py
│   │   ├── mapbox_static.py
│   │   ├── traffic_service.py
│   │   ├── velocity_calculator.py
│   │   └── dataset_loader.py
│   ├── models/                  # Modelos Pydantic
│   │   └── (definiciones de datos)
│   └── config/                  # Configuraciones
│       └── mapbox.py
├── data/                        # Datos
│   ├── trafico_ecuador.csv
│   └── README.md
├── main.py                      # Wrapper
├── requirements.txt
└── Dockerfile
```

#### 4.2.2 Endpoints Principales

##### Tráfico
```
GET  /api/traffic/current         - Tráfico actual
GET  /api/traffic/predict         - Predicción de tráfico
GET  /api/traffic/history         - Historial de tráfico
```

##### Mapbox
```
POST /api/mapbox/directions       - Calcular rutas
POST /api/mapbox/geocode          - Geocodificación
GET  /api/mapbox/reverse-geocode  - Geocodificación inversa
GET  /api/mapbox/static-image     - Imagen estática de mapa
```

##### Dataset
```
GET  /api/dataset/stats           - Estadísticas del dataset
GET  /api/dataset/sample          - Muestra de datos
GET  /api/dataset/cities          - Ciudades disponibles
```

##### Predicciones
```
POST /api/predictions/traffic     - Predecir tráfico
POST /api/predictions/route-time  - Predecir tiempo de ruta
GET  /api/predictions/model-info  - Info del modelo ML
```

##### Historial
```
GET  /api/history/routes          - Obtener historial de rutas
POST /api/history/routes          - Guardar ruta en historial
DELETE /api/history/routes/{id}   - Eliminar ruta
GET  /api/history/stats           - Estadísticas de historial
```

#### 4.2.3 Servicios

##### MapboxDirectionsService
Servicio para cálculo de rutas usando Mapbox Directions API.

**Métodos:**
- `get_directions(origin, destination, profile='driving-traffic')`
- `get_alternative_routes(origin, destination, alternatives=3)`
- `optimize_waypoints(waypoints)`

##### TrafficService
Servicio para datos de tráfico en tiempo real.

**Métodos:**
- `get_current_traffic(area)`
- `predict_traffic(location, time)`
- `analyze_traffic_patterns(segment_id, date_range)`

##### VelocityCalculator
Cálculo de velocidades basado en datos históricos y predicciones.

**Métodos:**
- `calculate_average_speed(segment_id, hour, day_of_week)`
- `estimate_travel_time(route, departure_time)`
- `get_speed_profile(route)`

### 4.3 ChatAgent (Google Gemini)

#### 4.3.1 Estructura

```
ChatAgent/
├── app/
│   ├── main.py                  # Punto de entrada
│   ├── api/
│   │   └── routes/
│   │       └── chat.py         # Endpoints de chat
│   ├── core/
│   │   ├── config.py           # Configuración
│   │   ├── gemini_client.py    # Cliente Gemini
│   │   └── prompt.py           # Prompts del agente
│   ├── services/
│   │   └── agent_service.py    # Lógica del agente
│   └── schemas/
│       ├── chat_request.py
│       └── chat_response.py
├── test_agent.py
├── requirements.txt
└── Dockerfile
```

#### 4.3.2 Endpoints

```
POST /chat                        - Enviar mensaje al agente
GET  /chat/history                - Obtener historial de chat
DELETE /chat/history              - Limpiar historial
GET  /health                      - Health check
```

#### 4.3.3 Contexto del Agente

El agente está entrenado con conocimiento específico sobre:
- Geografía de Manta (avenidas, barrios, zonas)
- Patrones de tráfico típicos
- Horarios pico y valle
- Eventos que afectan la movilidad
- Rutas alternativas comunes
- Transporte público

---

## 5. Base de Datos

### 5.1 Esquema de Base de Datos

#### Tablas Principales

##### user_profiles
Perfiles de usuarios del sistema.

```sql
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR NOT NULL UNIQUE,
  full_name VARCHAR,
  avatar_url TEXT,
  phone VARCHAR,
  preferences JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### route_queries
Consultas de rutas realizadas por usuarios.

```sql
CREATE TABLE route_queries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id),
  session_id VARCHAR,
  origin_name VARCHAR,
  origin_coords GEOGRAPHY(POINT),
  destination_name VARCHAR,
  destination_coords GEOGRAPHY(POINT),
  departure_time TIMESTAMP WITH TIME ZONE,
  query_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  response_time_ms INTEGER,
  routes_returned INTEGER DEFAULT 0,
  selected_route_index INTEGER,
  preferences JSONB DEFAULT '{}'
);
```

##### route_options
Opciones de ruta retornadas para cada consulta.

```sql
CREATE TABLE route_options (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  query_id UUID REFERENCES route_queries(id),
  route_index INTEGER NOT NULL,
  route_name VARCHAR,
  route_geometry GEOGRAPHY(LINESTRING),
  distance_km NUMERIC,
  duration_minutes INTEGER,
  traffic_level INTEGER CHECK (traffic_level >= 1 AND traffic_level <= 5),
  route_type VARCHAR DEFAULT 'fastest',
  toll_cost NUMERIC DEFAULT 0,
  fuel_cost NUMERIC DEFAULT 0,
  road_segments VARCHAR[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### historial_rutas
Historial de rutas consultadas por usuarios.

```sql
CREATE TABLE historial_rutas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id),
  origen VARCHAR NOT NULL,
  destino VARCHAR NOT NULL,
  distancia_km NUMERIC,
  duracion_minutos INTEGER,
  nivel_trafico INTEGER,
  ruta_seleccionada VARCHAR,
  coordenadas_origen GEOGRAPHY(POINT),
  coordenadas_destino GEOGRAPHY(POINT),
  fecha_consulta TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### favorite_routes
Rutas favoritas de usuarios.

```sql
CREATE TABLE favorite_routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id),
  name VARCHAR NOT NULL,
  origin_name VARCHAR NOT NULL,
  origin_coords GEOGRAPHY(POINT),
  destination_name VARCHAR NOT NULL,
  destination_coords GEOGRAPHY(POINT),
  route_geometry GEOGRAPHY(LINESTRING),
  estimated_distance_km NUMERIC,
  estimated_duration_minutes INTEGER,
  preferences JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### traffic_data
Datos de tráfico histórico y en tiempo real.

```sql
CREATE TABLE traffic_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  segment_id VARCHAR REFERENCES road_segments(id),
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
  speed_kmh NUMERIC,
  congestion_level INTEGER CHECK (congestion_level >= 1 AND congestion_level <= 5),
  vehicle_count INTEGER,
  incident_type VARCHAR,
  weather_condition VARCHAR,
  day_of_week INTEGER,
  hour_of_day INTEGER,
  is_holiday BOOLEAN DEFAULT FALSE
);
```

##### road_segments
Segmentos de carretera/calles.

```sql
CREATE TABLE road_segments (
  id VARCHAR PRIMARY KEY,
  name VARCHAR,
  geometry GEOGRAPHY(LINESTRING),
  road_type VARCHAR CHECK (road_type IN ('highway', 'arterial', 'collector', 'local', 'residential')),
  speed_limit INTEGER DEFAULT 50,
  lanes INTEGER DEFAULT 2,
  surface_type VARCHAR DEFAULT 'asphalt',
  length_km NUMERIC,
  city VARCHAR,
  province VARCHAR,
  country VARCHAR DEFAULT 'EC',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### ml_models
Información de modelos de Machine Learning.

```sql
CREATE TABLE ml_models (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR NOT NULL,
  version VARCHAR NOT NULL,
  model_type VARCHAR NOT NULL,
  file_path TEXT,
  training_data_range TSTZRANGE,
  accuracy_metrics JSONB,
  features JSONB,
  parameters JSONB,
  is_active BOOLEAN DEFAULT FALSE,
  deployed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

##### api_usage
Uso de la API (logs y métricas).

```sql
CREATE TABLE api_usage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id),
  endpoint VARCHAR NOT NULL,
  method VARCHAR NOT NULL,
  status_code INTEGER,
  response_time_ms INTEGER,
  request_size_bytes INTEGER DEFAULT 0,
  response_size_bytes INTEGER DEFAULT 0,
  ip_address INET,
  user_agent TEXT,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 5.2 Índices

```sql
-- Índices geoespaciales
CREATE INDEX idx_route_queries_origin ON route_queries USING GIST(origin_coords);
CREATE INDEX idx_route_queries_destination ON route_queries USING GIST(destination_coords);
CREATE INDEX idx_road_segments_geometry ON road_segments USING GIST(geometry);
CREATE INDEX idx_traffic_data_segment ON traffic_data(segment_id);

-- Índices de tiempo
CREATE INDEX idx_route_queries_query_time ON route_queries(query_time);
CREATE INDEX idx_traffic_data_timestamp ON traffic_data(timestamp);
CREATE INDEX idx_historial_fecha ON historial_rutas(fecha_consulta);

-- Índices de usuario
CREATE INDEX idx_route_queries_user ON route_queries(user_id);
CREATE INDEX idx_historial_user ON historial_rutas(user_id);
CREATE INDEX idx_favorite_routes_user ON favorite_routes(user_id);
```

### 5.3 Políticas RLS (Row Level Security)

```sql
-- Habilitar RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_queries ENABLE ROW LEVEL SECURITY;
ALTER TABLE historial_rutas ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_routes ENABLE ROW LEVEL SECURITY;

-- Políticas para user_profiles
CREATE POLICY "Users can view own profile" ON user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);

-- Políticas para historial_rutas
CREATE POLICY "Users can view own history" ON historial_rutas
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own history" ON historial_rutas
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own history" ON historial_rutas
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas para favorite_routes
CREATE POLICY "Users can view own favorites" ON favorite_routes
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own favorites" ON favorite_routes
  FOR ALL USING (auth.uid() = user_id);
```

---

## 6. APIs y Endpoints

### 6.1 Backend API (Puerto 8000)

#### 6.1.1 Autenticación

```http
POST /auth/register
POST /auth/login
POST /auth/logout
POST /auth/refresh-token
POST /auth/reset-password
```

**Ejemplo - Registro:**
```json
POST /auth/register
Content-Type: application/json

{
  "email": "usuario@ejemplo.com",
  "password": "contraseña_segura",
  "full_name": "Juan Pérez"
}

Response 201:
{
  "user_id": "uuid-here",
  "email": "usuario@ejemplo.com",
  "access_token": "jwt-token-here"
}
```

#### 6.1.2 Mapbox Directions

```http
POST /api/mapbox/directions
```

**Request:**
```json
{
  "origin": {
    "lat": -0.9549,
    "lng": -80.7303,
    "name": "Malecón Manta"
  },
  "destination": {
    "lat": -0.9331,
    "lng": -80.7405,
    "name": "Universidad Laica"
  },
  "profile": "driving-traffic",
  "alternatives": true,
  "steps": true
}
```

**Response:**
```json
{
  "routes": [
    {
      "route_index": 0,
      "distance_km": 4.2,
      "duration_minutes": 12,
      "traffic_level": 2,
      "route_type": "fastest",
      "geometry": {
        "type": "LineString",
        "coordinates": [[lng, lat], ...]
      },
      "steps": [
        {
          "instruction": "Head north on Av. 4 de Noviembre",
          "distance_meters": 500,
          "duration_seconds": 60
        }
      ],
      "waypoints": [...]
    }
  ],
  "query_id": "uuid-here",
  "processing_time_ms": 245
}
```

#### 6.1.3 Predicciones de Tráfico

```http
POST /api/predictions/traffic
```

**Request:**
```json
{
  "location": {
    "lat": -0.9549,
    "lng": -80.7303
  },
  "timestamp": "2026-01-27T15:00:00Z",
  "road_segment_id": "seg_001"
}
```

**Response:**
```json
{
  "prediction": {
    "congestion_level": 3,
    "confidence": 0.87,
    "estimated_speed_kmh": 35,
    "estimated_delay_minutes": 8
  },
  "factors": {
    "hour_of_day": 15,
    "day_of_week": 1,
    "is_holiday": false,
    "weather": "clear"
  },
  "model_info": {
    "name": "traffic_predictor_v1",
    "version": "1.2.0",
    "accuracy": 0.89
  }
}
```

#### 6.1.4 Historial de Rutas

```http
GET /api/history/routes?user_id={uuid}&limit=20&offset=0
```

**Response:**
```json
{
  "routes": [
    {
      "id": "uuid-here",
      "origen": "Malecón Manta",
      "destino": "Universidad Laica",
      "distancia_km": 4.2,
      "duracion_minutos": 12,
      "nivel_trafico": 2,
      "fecha_consulta": "2026-01-27T14:30:00Z"
    }
  ],
  "total": 145,
  "page": 1,
  "limit": 20
}
```

```http
POST /api/history/routes
```

**Request:**
```json
{
  "user_id": "uuid-here",
  "origen": "Malecón Manta",
  "destino": "Universidad Laica",
  "distancia_km": 4.2,
  "duracion_minutos": 12,
  "nivel_trafico": 2,
  "ruta_seleccionada": "route_0",
  "coordenadas_origen": {"lat": -0.9549, "lng": -80.7303},
  "coordenadas_destino": {"lat": -0.9331, "lng": -80.7405}
}
```

#### 6.1.5 Rutas Favoritas

```http
GET /api/favorites?user_id={uuid}
POST /api/favorites
PUT /api/favorites/{id}
DELETE /api/favorites/{id}
```

### 6.2 ChatAgent API (Puerto 8001)

```http
POST /chat
```

**Request:**
```json
{
  "message": "¿Cuál es la mejor ruta desde el Malecón hasta ULEAM en hora pico?",
  "context": {
    "user_id": "uuid-here",
    "location": "Manta, Ecuador"
  }
}
```

**Response:**
```json
{
  "response": "En hora pico (7:00-9:00 AM y 5:00-7:00 PM), te recomiendo tomar la Av. 4 de Noviembre hasta la Av. Universitaria. Es más rápida que la ruta por el centro. Considera que el tráfico es más denso cerca del mercado central.",
  "confidence": 0.92,
  "sources": ["traffic_patterns", "user_reports"],
  "suggestions": [
    "Evita pasar por el centro entre 7:00-9:00 AM",
    "Alternativa: Av. Flavio Reyes"
  ]
}
```

### 6.3 Códigos de Estado HTTP

| Código | Significado |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 204 | No Content - Eliminación exitosa |
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - No autenticado |
| 403 | Forbidden - Sin permisos |
| 404 | Not Found - Recurso no encontrado |
| 422 | Unprocessable Entity - Validación fallida |
| 500 | Internal Server Error - Error del servidor |
| 503 | Service Unavailable - Servicio no disponible |

---

## 7. Instalación y Configuración

### 7.1 Requisitos del Sistema

#### Software Requerido
- **Node.js**: 22.18.0 o superior
- **Python**: 3.13.7 o superior
- **Docker**: 20.10+ (opcional)
- **Docker Compose**: 2.0+ (opcional)
- **Git**: 2.30+
- **PostgreSQL**: 14+ (si no usas Docker)

#### Hardware Mínimo
- **CPU**: 2 cores
- **RAM**: 4 GB
- **Disco**: 10 GB libres
- **Conexión**: Internet estable para APIs externas

### 7.2 Instalación con Docker (Recomendado)

#### 1. Clonar el Repositorio

```bash
git clone https://github.com/AnThony69x/PrediRuta.git
cd PrediRuta
```

#### 2. Configurar Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
# Supabase
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=tu-service-role-key
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-anon-key

# Mapbox
MAPBOX_ACCESS_TOKEN=tu-mapbox-token

# Google Gemini
GEMINI_API_KEY=tu-gemini-api-key

# Backend
TRAFFIC_API_KEY=tu-traffic-api-key
TRAFFIC_PROVIDER=mapbox
FRONTEND_ORIGIN=http://localhost:3000

# Google OAuth (opcional)
NEXT_PUBLIC_GOOGLE_CLIENT_ID=tu-google-client-id
```

#### 3. Levantar Servicios

```bash
docker-compose up --build
```

#### 4. Verificar

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000/docs
- ChatAgent: http://localhost:8001/docs

### 7.3 Instalación Manual

#### Frontend

```bash
cd frontend

# Instalar dependencias
npm install

# Configurar .env.local
cp .env.example .env.local
# Editar .env.local con tus credenciales

# Desarrollo
npm run dev

# Producción
npm run build
npm start
```

#### Backend

```bash
cd backend

# Crear entorno virtual
python -m venv venv

# Activar (Windows)
venv\Scripts\activate
# Activar (Linux/Mac)
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar .env
cp .env.example .env
# Editar .env con tus credenciales

# Desarrollo
uvicorn app.main:app --reload --port 8000

# Producción
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

#### ChatAgent

```bash
cd ChatAgent

# Crear entorno virtual
python -m venv venv

# Activar entorno
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Instalar dependencias
pip install -r requirements.txt

# Configurar .env
# Agregar GEMINI_API_KEY=tu-api-key

# Ejecutar
uvicorn app.main:app --reload --port 8001
```

### 7.4 Configuración de Supabase

#### 1. Crear Proyecto en Supabase

1. Ve a [supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Crea un nuevo proyecto
4. Guarda las credenciales (URL y Keys)

#### 2. Ejecutar Scripts SQL

En el SQL Editor de Supabase:

```bash
# Ejecutar script principal
database/script_data_base.sql

# Ejecutar script de historial
database/historial_schema.sql
```

#### 3. Configurar Autenticación

1. Ve a Authentication > Settings
2. Habilita Email Auth
3. (Opcional) Configura Google OAuth
4. Configura las URLs de redirección

#### 4. Configurar Storage (opcional)

Para imágenes de perfil:
```sql
CREATE BUCKET avatars;

-- Política de acceso
CREATE POLICY "Avatar images are publicly accessible" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');
```

### 7.5 Obtener API Keys

#### Mapbox

1. Ve a [mapbox.com](https://www.mapbox.com/)
2. Crea una cuenta
3. Ve a "Account" > "Access tokens"
4. Crea un nuevo token con los scopes:
   - `styles:read`
   - `fonts:read`
   - `datasets:read`
   - `directions:read`
   - `geocoding:read`

#### Google Gemini

1. Ve a [Google AI Studio](https://makersuite.google.com/)
2. Crea un proyecto
3. Genera una API key
4. Habilita Gemini API

---

## 8. Guía de Desarrollo

### 8.1 Flujo de Trabajo Git

#### Ramas

- `main` - Producción
- `develop` - Desarrollo
- `feature/nombre-feature` - Nuevas características
- `bugfix/nombre-bug` - Correcciones
- `hotfix/nombre-hotfix` - Hotfixes urgentes

#### Workflow

```bash
# Crear rama de feature
git checkout develop
git pull origin develop
git checkout -b feature/nueva-funcionalidad

# Desarrollar...
git add .
git commit -m "feat: agregar nueva funcionalidad"

# Push
git push origin feature/nueva-funcionalidad

# Crear Pull Request en GitHub
# Después de revisión y aprobación, merge a develop
```

#### Convención de Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: nueva característica
fix: corrección de bug
docs: cambios en documentación
style: formateo, no afecta lógica
refactor: refactorización de código
test: agregar tests
chore: tareas de mantenimiento
```

### 8.2 Desarrollo Frontend

#### Crear un Nuevo Componente

```typescript
// src/components/NuevoComponente.tsx
import React from 'react';

interface NuevoComponenteProps {
  titulo: string;
  onClick?: () => void;
}

export const NuevoComponente: React.FC<NuevoComponenteProps> = ({ 
  titulo, 
  onClick 
}) => {
  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h2 className="text-xl font-bold">{titulo}</h2>
      {onClick && (
        <button onClick={onClick} className="mt-2 px-4 py-2 bg-blue-500 text-white rounded">
          Acción
        </button>
      )}
    </div>
  );
};
```

#### Crear una Nueva Página

```typescript
// src/app/nueva-pagina/page.tsx
import { NuevoComponente } from '@/components/NuevoComponente';

export default function NuevaPaginaPage() {
  const handleClick = () => {
    console.log('Clicked!');
  };

  return (
    <div className="container mx-auto py-8">
      <NuevoComponente titulo="Mi Nueva Página" onClick={handleClick} />
    </div>
  );
}
```

### 8.3 Desarrollo Backend

#### Crear un Nuevo Endpoint

```python
# backend/app/routes/nuevo_modulo.py
from fastapi import APIRouter, Depends, HTTPException
from app.models.nuevo_modelo import NuevoModelo, NuevoResponse

router = APIRouter(prefix="/api/nuevo", tags=["Nuevo Módulo"])

@router.post("/crear", response_model=NuevoResponse)
async def crear_item(data: NuevoModelo):
    """
    Crea un nuevo item.
    
    Args:
        data: Datos del item a crear
        
    Returns:
        NuevoResponse: Item creado
    """
    try:
        # Lógica de creación
        result = {"id": "uuid-here", "status": "created"}
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/listar", response_model=list[NuevoResponse])
async def listar_items():
    """
    Lista todos los items.
    
    Returns:
        List[NuevoResponse]: Lista de items
    """
    # Lógica de listado
    return []
```

#### Registrar el Router

```python
# backend/app/main.py
from app.routes import nuevo_modulo

app.include_router(nuevo_modulo.router)
```

### 8.4 Testing

#### Frontend Tests (Jest + React Testing Library)

```typescript
// src/components/__tests__/NuevoComponente.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { NuevoComponente } from '../NuevoComponente';

describe('NuevoComponente', () => {
  it('renderiza el título correctamente', () => {
    render(<NuevoComponente titulo="Test Titulo" />);
    expect(screen.getByText('Test Titulo')).toBeInTheDocument();
  });

  it('llama a onClick cuando se hace clic', () => {
    const handleClick = jest.fn();
    render(<NuevoComponente titulo="Test" onClick={handleClick} />);
    
    fireEvent.click(screen.getByText('Acción'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

#### Backend Tests (pytest)

```python
# backend/tests/test_nuevo_modulo.py
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_crear_item():
    response = client.post("/api/nuevo/crear", json={
        "nombre": "Test Item",
        "valor": 123
    })
    assert response.status_code == 200
    assert response.json()["status"] == "created"

def test_listar_items():
    response = client.get("/api/nuevo/listar")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
```

### 8.5 Debugging

#### Frontend (Chrome DevTools)

1. Abre Chrome DevTools (F12)
2. Ve a la pestaña Sources
3. Establece breakpoints en tu código
4. Inspecciona variables y call stack

#### Backend (VS Code)

Crear `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: FastAPI",
      "type": "python",
      "request": "launch",
      "module": "uvicorn",
      "args": [
        "app.main:app",
        "--reload"
      ],
      "jinja": true,
      "justMyCode": true
    }
  ]
}
```

---

## 9. Despliegue

### 9.1 Despliegue con Docker

#### Producción con Docker Compose

```yaml
# docker-compose.prod.yml
version: "3.9"

services:
  frontend:
    image: prediruta-frontend:latest
    environment:
      - NODE_ENV=production
    restart: always
    
  backend:
    image: prediruta-backend:latest
    environment:
      - ENV=production
    restart: always
    
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend
    restart: always
```

```bash
# Build y deploy
docker-compose -f docker-compose.prod.yml up -d --build
```

### 9.2 Despliegue en Vercel (Frontend)

#### 1. Instalar Vercel CLI

```bash
npm install -g vercel
```

#### 2. Configurar vercel.json

Ya existe en `frontend/vercel.json`.

#### 3. Desplegar

```bash
cd frontend
vercel --prod
```

#### Variables de Entorno en Vercel

En el dashboard de Vercel, agregar:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `NEXT_PUBLIC_BACKEND_API_URL`
- `BACKEND_API_URL`
- `NEXT_PUBLIC_GOOGLE_CLIENT_ID`

### 9.3 Despliegue Backend (VPS/Cloud)

#### DigitalOcean/AWS/Azure

##### 1. Crear Droplet/VM

- Ubuntu 22.04 LTS
- 2 GB RAM mínimo
- 2 vCPUs

##### 2. Configurar Servidor

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias
sudo apt install python3.13 python3-pip python3-venv nginx -y

# Clonar repositorio
git clone https://github.com/AnThony69x/PrediRuta.git
cd PrediRuta/backend

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
nano .env  # Editar con credenciales reales
```

##### 3. Configurar Systemd

```bash
sudo nano /etc/systemd/system/prediruta-backend.service
```

```ini
[Unit]
Description=PrediRuta Backend
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/home/usuario/PrediRuta/backend
Environment="PATH=/home/usuario/PrediRuta/backend/venv/bin"
ExecStart=/home/usuario/PrediRuta/backend/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000

[Install]
WantedBy=multi-user.target
```

```bash
# Iniciar servicio
sudo systemctl daemon-reload
sudo systemctl start prediruta-backend
sudo systemctl enable prediruta-backend
sudo systemctl status prediruta-backend
```

##### 4. Configurar Nginx

```bash
sudo nano /etc/nginx/sites-available/prediruta
```

```nginx
server {
    listen 80;
    server_name api.prediruta.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/prediruta /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

##### 5. Configurar SSL (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d api.prediruta.com
```

### 9.4 CI/CD con GitHub Actions

Crear `.github/workflows/deploy.yml`:

```yaml
name: Deploy PrediRuta

on:
  push:
    branches: [main]

jobs:
  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '22.18.0'
      
      - name: Install dependencies
        working-directory: ./frontend
        run: npm ci
      
      - name: Build
        working-directory: ./frontend
        run: npm run build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
          working-directory: ./frontend

  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /home/usuario/PrediRuta
            git pull origin main
            cd backend
            source venv/bin/activate
            pip install -r requirements.txt
            sudo systemctl restart prediruta-backend
```

---

## 10. Seguridad y Autenticación

### 10.1 Autenticación con Supabase

PrediRuta utiliza Supabase Auth para gestión de usuarios.

#### Flujo de Autenticación

1. Usuario se registra/inicia sesión en frontend
2. Supabase genera JWT token
3. Token se almacena en cookie httpOnly
4. Frontend incluye token en headers de API requests
5. Backend valida token con Supabase

#### Implementación Frontend

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

// hooks/useAuth.ts
export const useAuth = () => {
  const signUp = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signUp({ email, password });
    return { data, error };
  };

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    return { data, error };
  };

  const signOut = async () => {
    const { error } = await supabase.auth.signOut();
    return { error };
  };

  return { signUp, signIn, signOut };
};
```

### 10.2 Protección de Rutas

#### Frontend (Next.js Middleware)

```typescript
// middleware.ts
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export async function middleware(req: NextRequest) {
  const res = NextResponse.next();
  const supabase = createMiddlewareClient({ req, res });

  const {
    data: { session },
  } = await supabase.auth.getSession();

  // Proteger rutas
  const protectedPaths = ['/dashboard', '/rutas', '/historial', '/perfil'];
  const isProtectedPath = protectedPaths.some(path => 
    req.nextUrl.pathname.startsWith(path)
  );

  if (isProtectedPath && !session) {
    return NextResponse.redirect(new URL('/login', req.url));
  }

  return res;
}

export const config = {
  matcher: ['/dashboard/:path*', '/rutas/:path*', '/historial/:path*', '/perfil/:path*']
};
```

#### Backend (FastAPI Dependencies)

```python
# app/dependencies.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from supabase import create_client, Client
import os

security = HTTPBearer()

def get_supabase() -> Client:
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_KEY")
    return create_client(supabase_url, supabase_key)

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    supabase: Client = Depends(get_supabase)
):
    try:
        token = credentials.credentials
        user = supabase.auth.get_user(token)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials"
            )
        return user
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )

# Uso en rutas
@router.get("/protected")
async def protected_route(current_user = Depends(get_current_user)):
    return {"message": f"Hello {current_user.email}"}
```

### 10.3 Seguridad de API Keys

#### Backend

```python
# Nunca exponer keys en responses
# Usar variables de entorno
import os
from dotenv import load_dotenv

load_dotenv()

MAPBOX_TOKEN = os.getenv("MAPBOX_ACCESS_TOKEN")
GEMINI_KEY = os.getenv("GEMINI_API_KEY")

# Nunca hacer:
# return {"api_key": MAPBOX_TOKEN}  # ❌ NO

# En su lugar:
# Usar el key internamente y solo retornar datos procesados
```

#### Frontend

```typescript
// Solo exponer claves públicas
// Keys con NEXT_PUBLIC_ son visibles en el cliente
const publicMapboxToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;

// Keys sin prefijo solo están en server-side
const secretKey = process.env.SECRET_KEY;  // Solo en API routes o SSR
```

### 10.4 Rate Limiting

```python
# Backend rate limiting con slowapi
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@router.get("/api/data")
@limiter.limit("10/minute")
async def get_data(request: Request):
    return {"data": "some data"}
```

### 10.5 CORS

```python
# Backend CORS configuration
from fastapi.middleware.cors import CORSMiddleware

origins = [
    "http://localhost:3000",
    "https://prediruta.vercel.app",
    "https://prediruta.com"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 10.6 Sanitización de Inputs

```python
# Validación con Pydantic
from pydantic import BaseModel, validator, EmailStr

class UserInput(BaseModel):
    email: EmailStr
    name: str
    age: int

    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v or len(v.strip()) == 0:
            raise ValueError('name cannot be empty')
        return v.strip()

    @validator('age')
    def age_must_be_positive(cls, v):
        if v <= 0:
            raise ValueError('age must be positive')
        return v
```

---

## 11. Testing

### 11.1 Testing Frontend

#### Configuración Jest

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testPathIgnorePatterns: ['/node_modules/', '/.next/'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
```

#### Tests de Componentes

```bash
npm test
npm run test:watch
npm run test:coverage
```

### 11.2 Testing Backend

#### Configuración pytest

```bash
cd backend
pytest
pytest --cov=app tests/
pytest -v -s
```

#### Fixtures

```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from app.main import app

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def auth_headers(client):
    # Login y obtener token
    response = client.post("/auth/login", json={
        "email": "test@test.com",
        "password": "test123"
    })
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}
```

### 11.3 Testing de Integración

```python
def test_full_route_flow(client, auth_headers):
    # 1. Calcular ruta
    response = client.post("/api/mapbox/directions", 
        json={
            "origin": {"lat": -0.9549, "lng": -80.7303},
            "destination": {"lat": -0.9331, "lng": -80.7405}
        },
        headers=auth_headers
    )
    assert response.status_code == 200
    query_id = response.json()["query_id"]
    
    # 2. Verificar que se guardó en historial
    response = client.get(f"/api/history/routes", headers=auth_headers)
    assert response.status_code == 200
    assert len(response.json()["routes"]) > 0
```

### 11.4 Testing E2E (Playwright)

```typescript
// e2e/routes.spec.ts
import { test, expect } from '@playwright/test';

test('calculate route flow', async ({ page }) => {
  await page.goto('http://localhost:3000');
  
  // Login
  await page.click('text=Iniciar Sesión');
  await page.fill('input[name="email"]', 'test@test.com');
  await page.fill('input[name="password"]', 'test123');
  await page.click('button[type="submit"]');
  
  // Navigate to routes
  await page.click('text=Calcular Ruta');
  
  // Fill route form
  await page.fill('input[name="origin"]', 'Malecón Manta');
  await page.fill('input[name="destination"]', 'Universidad Laica');
  await page.click('button:has-text("Calcular")');
  
  // Verify results
  await expect(page.locator('.route-result')).toBeVisible();
  await expect(page.locator('.map-container')).toBeVisible();
});
```

---

## 12. Mantenimiento

### 12.1 Logs y Monitoreo

#### Backend Logging

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

@router.get("/data")
async def get_data():
    logger.info("Fetching data...")
    try:
        data = fetch_data()
        logger.info(f"Successfully fetched {len(data)} records")
        return data
    except Exception as e:
        logger.error(f"Error fetching data: {str(e)}", exc_info=True)
        raise
```

#### Monitoreo con Sentry (Opcional)

```python
import sentry_sdk

sentry_sdk.init(
    dsn="https://your-sentry-dsn",
    environment="production",
    traces_sample_rate=1.0,
)
```

### 12.2 Backups

#### Base de Datos (Supabase)

Supabase realiza backups automáticos. También puedes exportar manualmente:

```bash
# Exportar desde Supabase CLI
supabase db dump -f backup.sql

# Restaurar
psql -h db.your-project.supabase.co -U postgres -d postgres < backup.sql
```

#### Archivos y Configuración

```bash
# Backup de configuración
tar -czf config-backup-$(date +%Y%m%d).tar.gz .env* docker-compose.yml

# Backup de datos locales
tar -czf data-backup-$(date +%Y%m%d).tar.gz backend/data/
```

### 12.3 Actualizaciones

#### Dependencias Frontend

```bash
cd frontend

# Ver paquetes desactualizados
npm outdated

# Actualizar paquetes menores
npm update

# Actualizar paquetes mayores (con cuidado)
npm install package-name@latest

# Verificar que todo funciona
npm run build
npm test
```

#### Dependencias Backend

```bash
cd backend

# Ver paquetes desactualizados
pip list --outdated

# Actualizar paquete específico
pip install --upgrade package-name

# Actualizar requirements.txt
pip freeze > requirements.txt

# Verificar que todo funciona
pytest
```

### 12.4 Optimización de Performance

#### Frontend

- **Code Splitting**: Next.js lo hace automáticamente
- **Image Optimization**: Usar `next/image`
- **Lazy Loading**: Componentes pesados
- **Memoization**: `useMemo`, `useCallback`

```typescript
import dynamic from 'next/dynamic';

// Lazy load mapa
const MapContainer = dynamic(() => import('@/components/maps/MapContainer'), {
  ssr: false,
  loading: () => <div>Cargando mapa...</div>
});
```

#### Backend

- **Async/Await**: Usar operaciones asíncronas
- **Caching**: Redis para datos frecuentes
- **Database Indexing**: Índices en columnas frecuentes
- **Connection Pooling**: Reutilizar conexiones DB

```python
from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend

@app.on_event("startup")
async def startup():
    FastAPICache.init(RedisBackend("redis://localhost"), prefix="prediruta:")

@router.get("/data")
@cache(expire=300)  # Cache por 5 minutos
async def get_data():
    return fetch_expensive_data()
```

---

## 13. Roadmap

### Versión 1.1 (Q1 2026)

- [ ] Predicción de tráfico con LSTM
- [ ] Notificaciones push para rutas favoritas
- [ ] Integración con Waze API
- [ ] Modo offline con Service Workers
- [ ] Reportes de incidentes por usuarios

### Versión 1.2 (Q2 2026)

- [ ] App móvil nativa (React Native)
- [ ] Integración con transporte público
- [ ] Planificación de rutas multimodal
- [ ] Gamificación (badges, logros)
- [ ] Compartir rutas con otros usuarios

### Versión 2.0 (Q3 2026)

- [ ] Expansión a más ciudades de Ecuador
- [ ] Predicción de estacionamiento
- [ ] Integración con vehículos conectados (IoT)
- [ ] Dashboard para autoridades de tránsito
- [ ] APIs públicas para terceros

### Mejoras Continuas

- [ ] Optimización de modelos ML
- [ ] Mejora de UX/UI basada en feedback
- [ ] Documentación en inglés
- [ ] Tests automatizados (cobertura >80%)
- [ ] Monitoreo avanzado (APM)

---

## 14. Créditos y Licencia

### 14.1 Equipo de Desarrollo

**PrediRuta** es un proyecto universitario desarrollado por:

- **Anthony Mejia** - Desarrollador Full Stack
- **Kristhin Bello** - Desarrollador Full Stack
- **Jesus Montes** - Desarrollador Full Stack

**Institución:**  
Universidad Laica de Eloy Alfaro de Manabí (ULEAM)  
Carrera: Ingeniería en Software  
Manta, Ecuador

### 14.2 Tecnologías y Librerías

Agradecimientos especiales a los creadores de:

- Next.js y React (Meta/Vercel)
- FastAPI (Sebastián Ramírez)
- Supabase (Supabase Inc.)
- Mapbox (Mapbox Inc.)
- Google Gemini (Google AI)
- TailwindCSS (Tailwind Labs)
- Y todas las librerías open source utilizadas

### 14.3 Licencia

Este proyecto está licenciado bajo la **Licencia MIT en Español**.

```
MIT License (Spanish Version)

Copyright (c) 2025-2026 Anthony Mejia, Kristhin Bello, Jesus Montes

Se concede permiso, de forma gratuita, a cualquier persona que obtenga una copia
de este software y de los archivos de documentación asociados (el "Software"),
para utilizar el Software sin restricción, incluyendo sin limitación los derechos
a usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar, y/o vender
copias del Software, y a permitir a las personas a las que se les proporcione el
Software a hacer lo mismo, sujeto a las siguientes condiciones:

El aviso de copyright anterior y este aviso de permiso se incluirán en todas las
copias o partes sustanciales del Software.

EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O
IMPLÍCITA, INCLUYENDO PERO NO LIMITADO A GARANTÍAS DE COMERCIALIZACIÓN, IDONEIDAD
PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN. EN NINGÚN CASO LOS AUTORES O TITULARES
DEL COPYRIGHT SERÁN RESPONSABLES DE NINGUNA RECLAMACIÓN, DAÑOS U OTRAS RESPONSABILIDADES,
YA SEA EN UNA ACCIÓN DE CONTRATO, AGRAVIO O CUALQUIER OTRO MOTIVO, QUE SURJA DE,
FUERA DE O EN CONEXIÓN CON EL SOFTWARE O EL USO U OTRO TIPO DE ACCIONES EN EL SOFTWARE.
```

### 14.4 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'feat: add amazing feature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### 14.5 Contacto

- **Repositorio**: [github.com/AnThony69x/PrediRuta](https://github.com/AnThony69x/PrediRuta)
- **Issues**: [github.com/AnThony69x/PrediRuta/issues](https://github.com/AnThony69x/PrediRuta/issues)
- **Email**: [Contacto del proyecto]

### 14.6 Citas y Referencias

Si utilizas PrediRuta en tu investigación o proyecto académico, por favor cita:

```bibtex
@software{prediruta2026,
  author = {Mejia, Anthony and Bello, Kristhin and Montes, Jesus},
  title = {PrediRuta: Sistema de Predicción de Tráfico Vehicular con IA},
  year = {2026},
  publisher = {GitHub},
  url = {https://github.com/AnThony69x/PrediRuta}
}
```

---

## Apéndices

### A. Glosario de Términos

- **API**: Application Programming Interface
- **CORS**: Cross-Origin Resource Sharing
- **JWT**: JSON Web Token
- **ML**: Machine Learning
- **RLS**: Row Level Security
- **SSR**: Server-Side Rendering
- **LSTM**: Long Short-Term Memory (tipo de red neuronal)
- **PostGIS**: Extensión geoespacial de PostgreSQL

### B. Recursos Adicionales

#### Documentación Oficial
- [Next.js Docs](https://nextjs.org/docs)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [Supabase Docs](https://supabase.com/docs)
- [Mapbox Docs](https://docs.mapbox.com/)
- [Google Gemini Docs](https://ai.google.dev/docs)

#### Tutoriales y Guías
- [React Docs](https://react.dev/)
- [TailwindCSS Docs](https://tailwindcss.com/docs)
- [Python Docs](https://docs.python.org/)
- [Docker Docs](https://docs.docker.com/)

### C. Troubleshooting Común

#### Frontend no se conecta al Backend
```bash
# Verificar que el backend esté corriendo
curl http://localhost:8000/docs

# Verificar CORS en backend
# Verificar NEXT_PUBLIC_BACKEND_API_URL en .env.local
```

#### Error de autenticación en Supabase
```bash
# Verificar credenciales en .env
# Verificar que las políticas RLS estén activas
# Verificar que el usuario esté autenticado
```

#### Mapbox no muestra mapas
```bash
# Verificar token de Mapbox
# Verificar que el componente no esté renderizando en SSR
# Usar dynamic import con ssr: false
```

---

**Fin de la Documentación**

*Última actualización: 27 de enero de 2026*  
*Versión del documento: 1.0.0*

Para más información, consulta el repositorio en GitHub o contacta al equipo de desarrollo.
