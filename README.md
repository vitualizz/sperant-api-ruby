# Sperant API

Cliente Ruby para la [API v3 de Sperant](https://sperant.gitbook.io/apiv3). Permite consultar proyectos, clientes y unidades de forma sencilla, con configuración de token y entorno (prueba o producción).

## Instalación

Añade la gema a tu `Gemfile`:

```ruby
gem "sperant-api"
```

Luego ejecuta:

```bash
bundle install
```

O instala la gema directamente:

```bash
gem install sperant-api
```

## Configuración

### Uso standalone (script o consola)

Puedes configurar la gema de forma global y luego usar el cliente sin argumentos:

```ruby
require "sperant_api"

SperantApi.configure do |c|
  c.access_token = "tu-token-entregado-por-sperant"
  c.environment = :test   # o :production
end

client = SperantApi::Client.new
```

O crear un cliente con configuración explícita (sin usar la configuración global):

```ruby
require "sperant_api"

client = SperantApi::Client.new(
  access_token: "tu-token",
  environment: :production
)
```

- **`environment`**: `:test` (por defecto) usa `https://api.eterniasoft.com`; `:production` usa `https://api.sperant.com`.
- **`access_token`**: Token API Key proporcionado por Sperant (solicitar a soporte@sperant.com).

### Uso en Ruby on Rails

Crea un inicializador, por ejemplo `config/initializers/sperant_api.rb`:

```ruby
require "sperant_api"

SperantApi.configure do |c|
  c.access_token = ENV["SPERANT_API_TOKEN"] || Rails.application.credentials.dig(:sperant, :api_token)
  c.environment = Rails.env.production? ? :production : :test
end
```

Luego en controladores o servicios:

```ruby
client = SperantApi::Client.new
client.projects.list(q: "Prados")
```

## Uso básico

### Listar proyectos

```ruby
client = SperantApi::Client.new(access_token: "tu-token", environment: :test)

# Todos los proyectos (paginado, 20 por página)
response = client.projects.list
response.data      # array de proyectos
response.meta      # metadatos (p. ej. page.total)
response.links     # enlaces de paginación
response.total_pages

# Con filtros
response = client.projects.list(q: "Prados")
response = client.projects.list(code: "PRADOS")
response = client.projects.list(page: 2)
```

### Listar clientes

```ruby
response = client.clients.list
response = client.clients.list(q: "+51999...")  # filtrar por documento, email o celular (con código de país)
response = client.clients.list(page: 1)
```

### Listar unidades de un proyecto

```ruby
response = client.units.list(project_id: 7)
response = client.units.list(
  project_id: 7,
  block_id: 10,                    # ID de subdivisión (opcional)
  commercial_status_id: 1,         # 1=Disponible, 2=No disponible, etc. (opcional)
  page: 2
)
```

## Respuesta paginada

Los métodos `list` devuelven un objeto `SperantApi::Response::Paginated` con:

- **`data`**: array de ítems (proyectos, clientes o unidades).
- **`meta`**: hash con metadatos (p. ej. `meta["page"]["total"]`).
- **`links`**: hash con enlaces de paginación (`prev`, `next`, `last`).
- **`total_pages`**: atajo a `meta.dig("page", "total")`.

La API devuelve 20 elementos por página por defecto.

## Manejo de errores

La gema define excepciones específicas que puedes rescatar:

```ruby
begin
  client.projects.list
rescue SperantApi::ConfigurationError => e
  # Token faltante o inválido, entorno no permitido
rescue SperantApi::RateLimitError => e
  # Límite de 15 peticiones por segundo superado (429)
rescue SperantApi::ApiError => e
  # Otro error HTTP (4xx/5xx)
  puts "Status: #{e.status_code}, body: #{e.response_body}"
end
```

## Rate limit

Según la documentación de Sperant, el límite es de **15 peticiones por segundo**. Respeta este límite en tu integración para evitar `SperantApi::RateLimitError`.

## Documentación de la API

- [Introducción y esquema](https://sperant.gitbook.io/apiv3)
- [Listar proyectos](https://sperant.gitbook.io/apiv3/proyecto/listar-proyectos)
- [Listar clientes](https://sperant.gitbook.io/apiv3/clientes/listar-cliente)
- [Listar unidades](https://sperant.gitbook.io/apiv3/unidades/listar-unidades)

## Desarrollo y pruebas

```bash
bundle install
bundle exec rspec
```

## Licencia

MIT. Ver [LICENSE](LICENSE).
