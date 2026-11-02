"""Rotas da API REST."""
from pathlib import Path
from django.conf import settings
from django.contrib import admin
from django.http import FileResponse
from django.urls import include, path, re_path
from django.views.static import serve
from rest_framework.routers import DefaultRouter

from administracao import views as adm
from anuncios import views as anu

def servir_media(request, path):
    caminho = Path(settings.MEDIA_ROOT) / path
    if caminho.is_file():
        return serve(request, path, document_root=settings.MEDIA_ROOT)
    pasta_fotos = settings.BASE_DIR / "anuncios" / "fotos_reais"
    if pasta_fotos.is_dir():
        candidatos = sorted(list(pasta_fotos.glob("*.jpg")))
        if candidatos:
            idx = sum(ord(c) for c in path) % len(candidatos)
            return FileResponse(open(candidatos[idx], "rb"), content_type="image/jpeg")
    return serve(request, path, document_root=settings.MEDIA_ROOT)

router = DefaultRouter()
router.register("anuncios", anu.AnuncioPublicoViewSet, basename="anuncios")
router.register("meus-anuncios", anu.MeusAnunciosViewSet, basename="meus-anuncios")
router.register("admin/moderacao", adm.ModeracaoViewSet, basename="moderacao")
router.register("admin/utilizadores", adm.UtilizadoresViewSet, basename="utilizadores")
router.register("admin/alertas", adm.AlertasViewSet, basename="alertas")
router.register("admin/parametros", adm.ParametrosViewSet, basename="parametros")
router.register("admin/registos", adm.RegistosView, basename="registos")

urlpatterns = [
    path("django-admin/", admin.site.urls),
    path("api/auth/", include("contas.urls")),
    path("api/estimativa-preco/", anu.EstimativaPrecoView.as_view()),
    path("api/favoritos/", anu.FavoritosView.as_view()),
    path("api/favoritos/<int:anuncio_id>/", anu.FavoritoDetalheView.as_view()),
    path("api/recomendacoes/", anu.RecomendacoesView.as_view()),
    path("api/assistente/", anu.AssistenteView.as_view()),
    path("api/notificacoes/", anu.NotificacoesView.as_view()),
    path("api/admin/indicadores/", adm.IndicadoresView.as_view()),
    path("api/admin/indicadores/exportar/", adm.ExportarIndicadoresView.as_view()),
    path("api/", include(router.urls)),
    re_path(r"^media/(?P<path>.*)$", servir_media),
]
