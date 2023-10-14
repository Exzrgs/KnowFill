from rest_framework import serializers
from .models import Problem
from .models import Note
from .models import Hirabun

# djangoのデフォルトで用意されているUserモデルをインポート
from django.contrib.auth.models import User

# ユーザ用のトークンをインポート
from rest_framework.authtoken.models import Token

class UserSerializer(serializers.ModelSerializer):
    # 基本設定を行うクラス
    class Meta:
        model = User
        fields = ("id", "username", "password")
        # passwordはGETでアクセスできない上入力必須に指定する
        extra_kwargs = {"password": {"write_only": True, "required": True}}

    # ユーザを作る際に使用するcreateメソッドをオーバーライドする。
    def create(self, validated_data):
        # パスワードをハッシュ化する
        user = User.objects.create_user(**validated_data)
        # トークンを生成する
        Token.objects.create(user=user)
        return user

class HirabunSerializer(serializers.ModelSerializer):
    """
     平文の問題文をシリアライズするクラス
    """

    class Meta:
        model = Hirabun
        fields = ["hirabun", "created_at", "updated_at"]

    def create(self, validated_data):
        print(validated_data, "validated_data")
        return Hirabun.objects.create(**validated_data)


class ProblemSerializer(serializers.ModelSerializer):
    """
    穴埋め処理が成された後の問題をシリアライズするクラス
    """

    class Meta:
        model = Problem
        fields = [
            "mondaibun_list",
            "ana",
            "created_at",
            "updated_at",
            "order_num",
            "id",
        ]

    def create(self, validated_data):
        return Problem.objects.create(**validated_data)


class NoteSerializer(serializers.ModelSerializer):
    problem = ProblemSerializer(many=True)

    # djangoのDatetimefieldの表記を変更
    created_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M", read_only=True)
    updated_at = serializers.DateTimeField(format="%Y-%m-%d %H:%M", read_only=True)

    class Meta:
        model = Note
        fields = ["title", "problem", "created_at", "updated_at", "order_num", "id"]

    def create(self, validated_data):
        result_dict = {}
        problem_list = []
        problem = validated_data.pop("problem")
        created_note = Note.objects.create(**validated_data)
        result_dict["note_id"] = created_note.id
        result_dict["order_num"] = created_note.order_num
        for problem_data in problem:
            print(problem_data)
            created_problem = Problem.objects.create(note=created_note, **problem_data)
            problem_list.append(created_problem.id)
        result_dict["problem_id"] = problem_list

        return result_dict
