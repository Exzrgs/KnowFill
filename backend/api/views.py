from django.shortcuts import render

# トークン認証に必要なライブラリ
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

# ビュー作成に必要なライブラリ
from rest_framework import generics
from rest_framework import viewsets
from rest_framework.response import Response

# 作成したモデルとシリアライザをインポート
from django.contrib.auth.models import User
from .models import Problem
from .models import Note
from .models import Hirabun

from .serializers import UserSerializer, ProblemSerializer
from .serializers import NoteSerializer
from .serializers import HirabunSerializer
from rest_framework.decorators import api_view

# 穴埋めロジックファイルをインポート
from .gen_problem import gen_problem

# 作成したpermissionをインポート
from .ownpermissions import OwnPermission


class UserViewSet(viewsets.ModelViewSet):
    # ユーザオブジェクトを全て取得する
    queryset = User.objects.all()

    # 使用するシリアライザを指定する
    serializer_class = UserSerializer

    # 誰でも見れるように指定する
    permission_classes = (OwnPermission,)


class ManageUserView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer

    # 認証が通ったユーザのみアクセスできるように指定する
    authentication_classes = (TokenAuthentication,)

    # ログインしているユーザのみ許可するように指定する
    permission_classes = (IsAuthenticated,)

    # ログインしているユーザ情報を返す関数
    def get_object(self):
        return self.request.user


class NoteViewSet(viewsets.ModelViewSet):
    queryset = Note.objects.all()
    serializer_class = NoteSerializer
    problem = ProblemSerializer(queryset, many=True)

    # authentication_classes = (TokenAuthentication,)
    # permission_classes = (IsAuthenticated,)
    def create(self, request):
        problem_serializer = NoteSerializer(data=request.data)

        if not problem_serializer.is_valid():
            print(problem_serializer.errors)
            return Response("validation error........")

        print(problem_serializer)
        result = problem_serializer.save()

        return Response(result)

    def update(self, request, pk):
        """
        ノートのタイトル更新
        """
        created_problem = ProblemViewSet().create_problem(request.data)[1]
        print(created_problem, "created_problem")
        Note.objects.get(id=pk).problem.add(created_problem)
        return Response("success")


class ProblemViewSet(viewsets.ModelViewSet):
    queryset = Problem.objects.all()
    serializer_class = ProblemSerializer

    def create_problem(self, data):
        """
        穴埋め問題作成関数
        ノートのアップデート関数からのみ呼び出される
        """
        print(data, "aaaaaaaaa")
        hirabun = data["hirabun"]
        # note_id = data['note_id']
        # target_note = Note.objects.get(id=note_id)
        # print(target_note, "target_note")
        problem = gen_problem.gen_problem(hirabun)
        mondaibun_list = problem["mondaibun_list"]
        ana = problem["ana"]
        data["ana"] = ana
        problem_dict = {}
        # problem_dict['note_id'] = target_note.id

        problem_dict["mondaibun_list"] = mondaibun_list
        problem_dict["ana"] = ana
        print(problem_dict, "problem_dict")
        created_problem = Problem.objects.create(**problem_dict)
        print(created_problem, "created_problem")
        problem_serializer = ProblemSerializer(data=problem_dict)
        print(problem_serializer)
        if not problem_serializer.is_valid():
            print(problem_serializer.errors)
            return Response("validation error........2")

        result = problem_serializer.data
        print(result, "result")
        return Response(result), created_problem

    def _create(self, request):
        """
        素の問題文を受け取る
        """
        # 平文のままシリアライズ
        hirabun_serializer = HirabunSerializer(data=request.data)
        print(hirabun_serializer)
        if not hirabun_serializer.is_valid():
            print(hirabun_serializer.errors)
            return Response("validation error........")
        # 穴埋め処理
        print(hirabun_serializer.data)
        result = self.create_problem(hirabun_serializer.data)[0]
        print(result)
        return result

    def create(self, request):
        """
        問題の作成
        """
        created_problem = ProblemViewSet().create_problem(request.data)[1]
        print(created_problem, "created_problem")
        Note.objects.get(id=request.data["note_id"]).problem.add(created_problem)
        return Response("success")
