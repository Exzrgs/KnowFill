from rest_framework import serializers
from .models import Problem
#djangoのデフォルトで用意されているUserモデルをインポート
from django.contrib.auth.models import User
#ユーザ用のトークンをインポート
from rest_framework.authtoken.models import Token

class UserSerializer(serializers.ModelSerializer):
    #基本設定を行うクラス
    class Meta:
        model = User
        fields = ('id', 'username', 'password')
        #passwordはGETでアクセスできない上入力必須に指定する
        extra_kwargs = {'password': {'write_only':True, 'required': True}}

    #ユーザを作る際に使用するcreateメソッドをオーバーライドする。
    def create(self,validated_data):
        #パスワードをハッシュ化する
        user = User.objects.create_user(**validated_data)
        #トークンを生成する
        Token.objects.create(user=user)
        return user

class ProblemSerializer(serializers.ModelSerializer):

    #djangoのDatetimefieldの表記を変更
    created_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M", read_only=True)
    updated_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M", read_only=True)

    class Meta:
        model = Problem
        fields = ['id','title','content','created_at','updated_at']
