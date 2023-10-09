from django.urls import path
from django.conf.urls import include
from rest_framework import routers
from api.views import UserViewSet, ManageUserView, NoteViewSet, ProblemViewSet
from rest_framework.authtoken.views import obtain_auth_token

router = routers.DefaultRouter()
router.register("users", UserViewSet)
router.register(r"Notelist", NoteViewSet)
router.register("problem", ProblemViewSet)

urlpatterns = [
    path("myself/", ManageUserView.as_view(), name="myself"),
    # ユーザ名とパスワードをPOSTするとトークンを返す。
    path('auth/',obtain_auth_token ),
    path("", include(router.urls)),
]
