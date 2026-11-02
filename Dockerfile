# Servidor de aplicação Django REST (para Render / Cloud Deploy)
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app

COPY backend/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .
RUN chmod +x arrancar.sh
RUN if [ ! -f anuncios/fotos_reais/manifesto.json ]; then python anuncios/fotos_reais/descarregar_fotos.py || true; fi

EXPOSE 8000
CMD ["./arrancar.sh"]
