
-- =====================================================
-- PREDIRUTA - SCHEMA DE BASE DE DATOS
-- =====================================================
-- Sistema de Predicción de Tráfico Vehicular con IA
-- 
-- Este script crea el esquema completo de la base de datos
-- para el sistema PrediRuta en PostgreSQL con Supabase.
--
-- CARACTERÍSTICAS:
-- - Gestión de perfiles de usuario
-- - Almacenamiento de rutas y consultas
-- - Datos de tráfico en tiempo real e históricos
-- - Predicciones de tráfico con ML
-- - Historial de rutas y predicciones
-- - Sistema de logs y métricas

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.user_profiles (
  id uuid NOT NULL,
  email character varying NOT NULL,
  full_name character varying,
  avatar_url text,
  phone character varying,
  date_of_birth date,
  preferences jsonb DEFAULT '{}'::jsonb,
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT user_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT user_profiles_email_key UNIQUE (email),
  CONSTRAINT user_profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX IF NOT EXISTS idx_user_profiles_is_active ON public.user_profiles(is_active);

CREATE TABLE IF NOT EXISTS public.road_segments (
  id character varying NOT NULL,
  name character varying,
  geometry geometry(LineString, 4326) NOT NULL,
  road_type character varying CHECK (road_type IN ('highway', 'arterial', 'collector', 'local', 'residential')),
  speed_limit integer DEFAULT 50 CHECK (speed_limit > 0 AND speed_limit <= 150),
  lanes integer DEFAULT 2 CHECK (lanes > 0 AND lanes <= 12),
  surface_type character varying DEFAULT 'asphalt',
  length_km numeric CHECK (length_km >= 0),
  city character varying,
  province character varying,
  country character varying DEFAULT 'EC',
  is_active boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT road_segments_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_road_segments_geometry ON public.road_segments USING GIST(geometry);
CREATE INDEX IF NOT EXISTS idx_road_segments_city ON public.road_segments(city);
CREATE INDEX IF NOT EXISTS idx_road_segments_type ON public.road_segments(road_type);

CREATE TABLE IF NOT EXISTS public.traffic_data (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  road_segment_id character varying,
  location geometry(Point, 4326) NOT NULL,
  timestamp timestamp with time zone NOT NULL,
  speed_kmh numeric CHECK (speed_kmh >= 0 AND speed_kmh <= 200),
  traffic_level integer CHECK (traffic_level >= 1 AND traffic_level <= 5),
  vehicle_count integer DEFAULT 0 CHECK (vehicle_count >= 0),
  congestion_factor numeric CHECK (congestion_factor >= 0 AND congestion_factor <= 1),
  weather_conditions jsonb DEFAULT '{}'::jsonb,
  data_source character varying DEFAULT 'system',
  created_at timestamp with time zone DEFAULT now(),
  
  CONSTRAINT traffic_data_pkey PRIMARY KEY (id),
  CONSTRAINT traffic_data_road_segment_id_fkey FOREIGN KEY (road_segment_id) 
    REFERENCES public.road_segments(id) ON DELETE SET NULL
);

-- Índices para optimizar consultas temporales y espaciales
CREATE INDEX IF NOT EXISTS idx_traffic_data_segment ON public.traffic_data(road_segment_id);
CREATE INDEX IF NOT EXISTS idx_traffic_data_timestamp ON public.traffic_data(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_traffic_data_location ON public.traffic_data USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_traffic_data_level ON public.traffic_data(traffic_level);

COMMENT ON TABLE public.traffic_data IS 'Datos de tráfico en tiempo real e históricos';
COMMENT ON COLUMN public.traffic_data.traffic_level IS 'Nivel de tráfico: 1=fluido, 2=moderado, 3=denso, 4=muy denso, 5=congestionado';
COMMENT ON COLUMN public.traffic_data.congestion_factor IS 'Factor de congestión de 0.0 (libre) a 1.0 (totalmente congestionado)';

-- =====================================================
-- TABLA: traffic_predictions
-- =====================================================
-- Almacena predicciones de tráfico generadas por
--CONSTRAINT traffic_data_pkey PRIMARY KEY (id),
  CONSTRAINT traffic_data_road_segment_id_fkey FOREIGN KEY (road_segment_id) REFERENCES public.road_segments(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_traffic_data_segment ON public.traffic_data(road_segment_id);
CREATE INDEX IF NOT EXISTS idx_traffic_data_timestamp ON public.traffic_data(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_traffic_data_location ON public.traffic_data USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_traffic_data_level ON public.traffic_data(traffic_level);
-- Índices para consultas de predicciones
CREATE INDEX IF NOT EXISTS idx_traffic_predictions_segment ON public.traffic_predictions(road_segment_id);
CREATE INDEX IF NOT EXISTS idx_traffic_predictions_target ON public.traffic_predictions(target_time);
CREATE INDEX IF NOT EXISTS idx_traffic_predictions_model ON public.traffic_predictions(model_version);

COMMENT ON TABLE public.traffic_predictions IS 'Predicciones de tráfico generadas por modelos de ML';
COMMENT ON COLUMN public.traffic_predictions.confidence_score IS 'Nivel de confianza del modelo en la predicción (0.0 a 1.0)';

-- =====================================================
-- TABLA: route_queries
-- =====================================================
-- Registra todas las consultas de rutas realizadas
--CONSTRAINT traffic_predictions_pkey PRIMARY KEY (id),
  CONSTRAINT traffic_predictions_road_segment_id_fkey FOREIGN KEY (road_segment_id) REFERENCES public.road_segments(id) ON DELETE SET NULL,
  CONSTRAINT valid_prediction_time CHECK (target_time > prediction_time)
);

CREATE INDEX IF NOT EXISTS idx_traffic_predictions_segment ON public.traffic_predictions(road_segment_id);
CREATE INDEX IF NOT EXISTS idx_traffic_predictions_target ON public.traffic_predictions(target_time);
CREATE INDEX IF NOT EXISTS idx_traffic_predictions_model ON public.traffic_predictions(model_version);
  CONSTRAINT route_queries_user_id_fkey FOREIGN KEY (user_id) 
    REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

-- Índices para consultas de rutas
CREATE INDEX IF NOT EXISTS idx_route_queries_user ON public.route_queries(user_id);
CREATE INDEX IF NOT EXISTS idx_route_queries_time ON public.route_queries(query_time DESC);
CREATE INDEX IF NOT EXISTS idx_route_queries_origin ON public.route_queries USING GIST(origin_coords);
CREATE INDEX IF NOT EXISTS idx_route_queries_destination ON public.route_queries USING GIST(destination_coords);

COMMENT ON TABLE public.route_queries IS 'Registro de consultas de rutas realizadas por usuarios';
COMMENT ON COLUMN public.route_queries.preferences IS 'Preferencias del usuario: evitar peajes, ruta más corta, etc.';

-- =====================================================
-- TABLA: route_options
-- =====================================================
-- Almacena las diferentes opciones de ruta retornadas
-- para cada consulta.

CREATE TABLE IF NOT EXISTS public.route_options (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  query_id uuid,
  route_index integer NOT NULL CHECK (route_index >= 0),
  route_name character varying,
  route_geometry geometry(LineString, 4326) NOT NULL,
  distance_km numeric CHECK (distance_km >= 0),
  duration_minutes integer CHECK (duration_minutes >= 0),
  traffic_level integer CHECK (traffic_level >= 1 AND traffic_level <= 5),
  route_type character varying DEFAULT 'fastest',
  CONSTRAINT route_queries_pkey PRIMARY KEY (id),
  CONSTRAINT route_queries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_route_queries_user ON public.route_queries(user_id);
CREATE INDEX IF NOT EXISTS idx_route_queries_time ON public.route_queries(query_time DESC);
CREATE INDEX IF NOT EXISTS idx_route_queries_origin ON public.route_queries USING GIST(origin_coords);
CREATE INDEX IF NOT EXISTS idx_route_queries_destination ON public.route_queries USING GIST(destination_coords);
-- =====================================================

CREATE TABLE IF NOT EXISTS public.favorite_routes (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  user_id uuid,
  name character varying NOT NULL,
  origin_name character varying NOT NULL,
  origin_coords geometry(Point, 4326) NOT NULL,
  destination_name character varying NOT NULL,
  destination_coords geometry(Point, 4326) NOT NULL,
  route_geometry geometry(LineString, 4326),
  estimated_distance_km numeric CHECK (estimated_distance_km >= 0),
  estimated_duration_minutes integer CHECK (estimated_duration_minutes >= 0),
  preferences jsonb DEFAULT '{}'::jsonb,
  CONSTRAINT route_options_pkey PRIMARY KEY (id),
  CONSTRAINT route_options_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.route_queries(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_route_options_query ON public.route_options(query_id);
CREATE INDEX IF NOT EXISTS idx_route_options_geometry ON public.route_options USING GIST(route_geometry);
-- - trafico: Estado del tráfico (fluido, moderado, congestionado)
-- - tiempo_ahorrado: Tiempo ahorrado vs ruta alternativa
-- =====================================================

CREATE TABLE IF NOT EXISTS public.historial_rutas (
  id text NOT NULL,
  user_id uuid NOT NULL,
  fecha timestamp with time zone NOT NULL DEFAULT now(),
  origen text NOT NULL,
  destino text NOT NULL,
  distancia numeric NOT NULL CHECK (distancia >= 0),
  duracion integer NOT NULL CHECK (duracion >= 0),
  tiempo_ahorrado integer NOT NULL DEFAULT 0,
  trafico text CHECK (trafico IN ('fluido', 'moderado', 'congestionado')),
  coordenadas_origen jsonb,
  CONSTRAINT favorite_routes_pkey PRIMARY KEY (id),
  CONSTRAINT favorite_routes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_favorite_routes_user ON public.favorite_routes(user_id);
CREATE INDEX IF NOT EXISTS idx_favorite_routes_active ON public.favorite_routes(is_active);
--
-- CAMPOS CLAVE:
-- - precision_real: Precisión real de la predicción (0-100%)
-- - congestion_predicha: Factor de congestión predicho
-- =====================================================

CREATE TABLE IF NOT EXISTS public.historial_predicciones (
  id text NOT NULL,
  user_id uuid NOT NULL,
  fecha date NOT NULL,
  zona text NOT NULL,
  hora_consulta text NOT NULL,
  precision_real integer NOT NULL CHECK (precision_real >= 0 AND precision_real <= 100),
  congestion_predicha numeric NOT NULL CHECK (congestion_predicha >= 0 AND congestion_predicha <= 1),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  
  CONSTRAINT historial_predicciones_pkey PRIMARY KEY (id),
  CONSTRAINT historial_predicciones_user_id_fkey FOREIGN KEY (user_id) 
    REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Índices para historial de predicciones
CREATE INDEX IF NOT EXISTS idx_historial_predicciones_user ON public.historial_predicciones(user_id);
CREATE INDEX IF NOT EXISTS idx_historial_predicciones_fecha ON public.historial_predicciones(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_historial_predicciones_zona ON public.historial_predicciones(zona);

COMMENT ON TABLE public.historial_predicciones IS 'Historial de predicciones de tráfico solicitadas';
COMMENT ON COLUMN public.historial_predicciones.precision_real IS 'Precisión real de la predicción (0-100%)';
COMMENT ON COLUMN public.historial_predicciones.congestion_predicha IS 'Factor de congestión predicho (0.0 a 1.0)';

-- =====================================================
--CONSTRAINT historial_rutas_pkey PRIMARY KEY (id),
  CONSTRAINT historial_rutas_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_historial_rutas_user ON public.historial_rutas(user_id);
CREATE INDEX IF NOT EXISTS idx_historial_rutas_fecha ON public.historial_rutas(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_historial_rutas_trafico ON public.historial_rutas(trafico);
  CONSTRAINT ml_models_pkey PRIMARY KEY (id),
  CONSTRAINT ml_models_unique_version UNIQUE (name, version)
);

-- Índices para modelos ML
CREATE INDEX IF NOT EXISTS idx_ml_models_name ON public.ml_models(name);
CREATE INDEX IF NOT EXISTS idx_ml_models_active ON public.ml_models(is_active);
CREATE INDEX IF NOT EXISTS idx_ml_models_type ON public.ml_models(model_type);

COMMENT ON TABLE public.ml_models IS 'Registro de modelos de Machine Learning para predicciones';
COMMENT ON COLUMN public.ml_models.accuracy_metrics IS 'Métricas de precisión: accuracy, precision, recall, f1-score';
COCONSTRAINT historial_predicciones_pkey PRIMARY KEY (id),
  CONSTRAINT historial_predicciones_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_historial_predicciones_user ON public.historial_predicciones(user_id);
CREATE INDEX IF NOT EXISTS idx_historial_predicciones_fecha ON public.historial_predicciones(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_historial_predicciones_zona ON public.historial_predicciones(zona);
  CONSTRAINT api_usage_pkey PRIMARY KEY (id),
  CONSTRAINT api_usage_user_id_fkey FOREIGN KEY (user_id) 
    REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

-- Índices para análisis de uso de API
CREATE INDEX IF NOT EXISTS idx_api_usage_user ON public.api_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_api_usage_timestamp ON public.api_usage(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_api_usage_endpoint ON public.api_usage(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_usage_status ON public.api_usage(status_code);

COMMENT ON TABLE public.api_usage IS 'Registro de uso de la API para métricas y monitoreo';
COMMENT ON COLUMN public.api_usage.response_time_ms IS 'Tiempo de respuesta del endpoint en milisegundos';

-- =====================================================
-- TABLA: system_logs
-- =====================================================
-- Logs del sistema para debugging y auditoría.
--
-- CAMPOS CLAVE:
-- - level: Nivel de log (DEBUG, INFO, WARNING, ERROR, CRITICAL)
-- - extra_data: Datos adicionales en formato JSON
-- =====================================================

CREATE TABLE IF NOT EXISTS public.system_logs (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  level character varying CHECK (level IN ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')),
  message text NOT NULL,
  module character varying,
  function_name character varying,
  user_id uuid,
  request_id character varying,
  extra_data jsonb,
  CONSTRAINT ml_models_pkey PRIMARY KEY (id),
  CONSTRAINT ml_models_unique_version UNIQUE (name, version)
);

CREATE INDEX IF NOT EXISTS idx_ml_models_name ON public.ml_models(name);
CREATE INDEX IF NOT EXISTS idx_ml_models_active ON public.ml_models(is_active);
CREATE INDEX IF NOT EXISTS idx_ml_models_type ON public.ml_models(model_type);
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para actualizar updated_at
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CRCONSTRAINT api_usage_pkey PRIMARY KEY (id),
  CONSTRAINT api_usage_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_api_usage_user ON public.api_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_api_usage_timestamp ON public.api_usage(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_api_usage_endpoint ON public.api_usage(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_usage_status ON public.api_usage(status_code);

-- =====================================================
-- POLÍTICAS RLS (ROW LEVEL SECURITY)
-- =====================================================
-- Nota: Estas políticas deben configurarse según
-- tus necesidades de seguridad específicas.
-- Por defecto están comentadas para evitar problemas.
-- =====================================================

-- Habilitar RLS en tablas sensibles
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historial_rutas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historial_predicciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorite_routes ENABLE ROW LEVEL SECURITY;

-- Políticas de ejemplo (descomenta y ajusta según necesites)

-- Usuarios solo pueden ver su propio perfil
-- CREATE POLICY "Users can view own profile" ON public.user_profiles
--     FOR SELECT USING (auth.uid() = id);

-- Usuarios solo pueden actualizar su propio perfil
-- CREATE POLICY "Users can update own profile" ON public.user_profiles
--     FOR UPDATE USING (auth.uid() = id);

-- Usuarios solo pueden ver su propio historial
-- CREATE POLICY "Users can view own history" ON public.historial_rutas
--CONSTRAINT system_logs_pkey PRIMARY KEY (id),
  CONSTRAINT system_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.user_profiles(id) ON DELETE SET NULL
);

-- AUTOR: PrediRuta Team - ULEAM
-- FECHA: Enero 2026
-- VERSIÓN: 1.0.0
-- =====================================================