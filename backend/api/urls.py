from django.urls import path
from django.conf.urls import include
from rest_framework import routers
from api.views import UserViewSet, ManageUserView, ProblemViewSet

router = routers.DefaultRouter()
router.register('users',UserViewSet)
router.register('Problemlist',ProblemViewSet)

urlpatterns = [
    path('myself/',ManageUserView.as_view( ), name='myself'),
    #ユーザ名とパスワードをPOSTするとトークンを返す。
    path('',include(router.urls)),
]
