from django.shortcuts import render

#トークン認証に必要なライブラリ
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

#ビュー作成に必要なライブラリ
from rest_framework import generics
from rest_framework import viewsets

#作成したモデルとシリアライザをインポート
from django.contrib.auth.models import User
from .models import Problem
from .serializers import UserSerializer,ProblemSerializer

#作成したpermissionをインポート
from .ownpermissions import OwnPermission

class UserViewSet(viewsets.ModelViewSet):

    #ユーザオブジェクトを全て取得する
    queryset = User.objects.all()

    #使用するシリアライザを指定する
    serializer_class = UserSerializer

    #誰でも見れるように指定する
    permission_classes = (OwnPermission,)

class ManageUserView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer

    #認証が通ったユーザのみアクセスできるように指定する
    authentication_classes = (TokenAuthentication,)

    #ログインしているユーザのみ許可するように指定する
    permission_classes = (IsAuthenticated,)

    #ログインしているユーザ情報を返す関数
    def get_object(self):
        return self.request.user

class ProblemViewSet(viewsets.ModelViewSet):
    queryset = Problem.objects.all()
    serializer_class = ProblemSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
