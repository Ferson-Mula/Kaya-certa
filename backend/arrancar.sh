#!/bin/sh
# Arranque do servidor (compatível com Docker Compose, Render, Railway e VPS):
# 1. aguarda pela ligação à base de dados (DATABASE_URL ou POSTGRES_HOST)
# 2. corre migrações do Django
# 3. carrega dados de demonstração (se a base de dados estiver vazia)
# 4. recolhe ficheiros estáticos (WhiteNoise)
# 5. inicia o servidor Gunicorn na porta $PORT (padrão 8000)
set -e

echo "A verificar ligação à base de dados..."
python -c "
import os, sys, time
for tentativa in range(30):
    try:
        url = os.environ.get('DATABASE_URL')
        host = os.environ.get('POSTGRES_HOST')
        if url:
            import dj_database_url, psycopg
            cfg = dj_database_url.parse(url)
            conn_args = {'dbname': cfg['NAME']}
            if cfg.get('USER'): conn_args['user'] = cfg['USER']
            if cfg.get('PASSWORD'): conn_args['password'] = cfg['PASSWORD']
            if cfg.get('HOST'): conn_args['host'] = cfg['HOST']
            if cfg.get('PORT'): conn_args['port'] = cfg['PORT']
            psycopg.connect(**conn_args).close()
            print('Ligação à base de dados PostgreSQL estabelecida!')
            break
        elif host:
            import psycopg
            psycopg.connect(
                host=host,
                dbname=os.environ.get('POSTGRES_DB', 'imoveis'),
                user=os.environ.get('POSTGRES_USER', 'imoveis'),
                password=os.environ.get('POSTGRES_PASSWORD', 'imoveis'),
                port=os.environ.get('POSTGRES_PORT', '5432')
            ).close()
            print('Ligação à base de dados PostgreSQL estabelecida!')
            break
        else:
            print('Sem base de dados PostgreSQL configurada; a utilizar SQLite.')
            break
    except Exception as e:
        time.sleep(1)
" || true

echo "A aplicar migrações..."
python manage.py migrate --noinput

echo "A carregar dados de demonstração..."
if [ "$RECARREGAR_DEMO" = "1" ]; then
  echo "A recarregar base de dados com as fotografias reais (--limpar)..."
  python manage.py carregar_demo --limpar
else
  python manage.py carregar_demo
fi

echo "A preparar ficheiros estáticos..."
python manage.py collectstatic --noinput -v 0

PORT="${PORT:-8000}"
WORKERS="${GUNICORN_WORKERS:-2}"
echo "A iniciar servidor Gunicorn na porta $PORT com $WORKERS workers..."
exec gunicorn config.wsgi:application --bind 0.0.0.0:"$PORT" --workers "$WORKERS" --timeout 90
