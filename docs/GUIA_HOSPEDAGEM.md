# Guia de Hospedagem 24/7 Gratuita — Casa Certa

Este guia explica passo a passo como colocar o **Casa Certa** online na nuvem de forma **100% gratuita**, utilizando:
* **Backend:** [Render.com](https://render.com) (Django REST + IA)
* **Base de Dados:** [Neon.tech](https://neon.tech) ou [Render PostgreSQL](https://render.com) (PostgreSQL gerenciado)
* **Frontend:** [Vercel](https://vercel.com) (React SPA com CDN rápida e SSL gratuito)

---

## 1. Subir o Código para o GitHub

Render e Vercel conectam-se diretamente ao GitHub para construir e publicar o projeto automaticamente.

No terminal do seu computador (na pasta `plataforma-imoveis`):

```bash
# 1. Inicializar o repositório Git
git init

# 2. Adicionar todos os ficheiros
git add .

# 3. Criar o primeiro commit
git commit -m "Configuracao para hospedagem na nuvem"

# 4. Criar um novo repositório no seu GitHub (público ou privado)
# Depois, associe o repositório remoto e faça o push:
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/casa-certa.git
git push -u origin main
```

---

## 2. Base de Dados PostgreSQL Gratuita

Recomendamos o **Neon.tech** por ser gratuito permanentemente:

1. Aceda a [neon.tech](https://neon.tech) e crie conta gratuita (com GitHub ou Google).
2. Clique em **Create Project** (nome sugerido: `casa-certa-db`).
3. Copie a **Connection String** fornecida (formato: `postgresql://user:password@ep-xyz.aws.neon.tech/neondb?sslmode=require`).
4. Guarde esse endereço para configurar no Render no passo seguinte.

*(Nota: Se preferir, o Render também tem base de dados PostgreSQL integrada gratuita por 30 dias).*

---

## 3. Hospedar o Backend no Render

1. Aceda a [render.com](https://render.com) e entre com a sua conta GitHub.
2. Clique em **New +** > **Web Service**.
3. Selecione o repositório GitHub do projeto (`casa-certa`).
4. Preencha as configurações:
   * **Name:** `casa-certa-backend`
   * **Language / Environment:** `Docker`
   * **Dockerfile Path:** `./backend/Dockerfile`
   * **Docker Build Context Directory:** `./backend`
   * **Instance Type:** `Free`
5. Na secção **Environment Variables** (Variáveis de Ambiente), adicione:
   * `DATABASE_URL`: *(Cole a URL do Neon obtida no passo 2)*
   * `DJANGO_DEBUG`: `0`
   * `DJANGO_SECRET_KEY`: *(Gere uma chave ou digite uma sequência aleatória segura)*
   * `DJANGO_ALLOWED_HOSTS`: `*`
   * `CSRF_TRUSTED_ORIGINS`: `https://*.onrender.com,https://*.vercel.app`
6. Clique em **Deploy Web Service**.
7. O Render irá construir o container Docker, rodar as migrações, carregar os dados de demonstração automaticamente e iniciar o Gunicorn.
8. Ao terminar, copie a URL do backend gerada pelo Render (ex.: `https://casa-certa-backend.onrender.com`).

---

## 4. Hospedar o Frontend na Vercel

1. Aceda a [vercel.com](https://vercel.com) e entre com GitHub.
2. Clique em **Add New...** > **Project**.
3. Importe o repositório `casa-certa`.
4. Em **Root Directory**, clique em Edit e selecione a pasta `frontend`.
5. Em **Environment Variables**, adicione:
   * **Name:** `VITE_API_URL`
   * **Value:** *(A URL do seu backend no Render, ex.: `https://casa-certa-backend.onrender.com` — sem barra no final)*
6. Clique em **Deploy**.
7. Em cerca de 1 minuto, a Vercel gera o link final do sistema (ex.: `https://casa-certa.vercel.app`).

---

## 5. Testar e Acessar o Sistema Online

Abra o link gerado pela Vercel no navegador. Pode aceder com qualquer uma das contas de teste:

* **Palavra-passe geral:** `Demo@2026`
* **Inquilino / Comprador:** `inquilino@imoveis.co.mz`
* **Proprietário / Agência:** `proprietario@imoveis.co.mz` ou `agencia@imoveis.co.mz`
* **Administrador:** `admin@imoveis.co.mz`

> **Dica sobre o plano gratuito do Render:**
> Serviços gratuitos no Render suspendem o processo após 15 minutos sem visitas. Quando alguém aceder pela primeira vez após uma pausa, o servidor demorará entre 30 a 50 segundos para despertar. Os acessos seguintes serão imediatos.
