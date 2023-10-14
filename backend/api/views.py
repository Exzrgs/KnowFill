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

from .ocr import ocr

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

    # ログイン中のユーザーのみアクセス可能
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    # デフォルトのgetをオーバーライド
    def get_queryset(self):
        """
         ログイン中のユーザーが作成したノートのみを表示
        """
        
        # ログイン中のユーザー情報を取得
        current_user = self.request.user.id

        # ログイン中のユーザーのモデルを取得
        user_data = User.objects.get(id=current_user)

        if user_data:
            # ログイン中のユーザーのNoteのみを選択
            queryset = Note.objects.filter(user_id=user_data).all()

            # order_numの昇順にソート
            queryset = queryset.order_by("order_num")
        
        return queryset

    def create(self, request):
        """
         ノート新規作成
        """
        # シリアライズ
        note_serializer = NoteSerializer(data=request.data)

        # バリテーション
        if not note_serializer.is_valid():
            print(note_serializer.errors)
            return Response("validation error........")
        
        # データベースに保存
        result = note_serializer.save(user_id=request.user.id)

        return Response(result)

    def update(self, request, pk):
        """
         ノートのタイトル更新 または order_numの更新
        """
        # 更新するNoteを取得
        note = Note.objects.get(id=pk)

        # 更新するNoteのtitleを更新
        if request.data["title"]:
            note.title = request.data["title"]
        if request.data["order_num"]:
            note.order_num = request.data["order_num"]
        note.save()

        return Response("success")

class ProblemViewSet(viewsets.ModelViewSet):
    queryset = Problem.objects.all()
    serializer_class = ProblemSerializer

    def get_queryset(self):
        """
         ログイン中のユーザーが作成したProblemのみを表示
        """
        
        # ログイン中のユーザー情報を取得
        current_user = self.request.user.id

        # ログイン中のユーザーのモデルを取得
        user_data = User.objects.get(id=current_user)

        if user_data:
            # ログイン中のユーザーのNoteのみを選択
            queryset = Problem.objects.filter(user_id=user_data).all()

            # order_numの昇順にソート
            queryset = queryset.order_by("order_num")
        
        return queryset
    
    def create_problem(self, data, request):
        """
         Problemを新規作成
        """
        base64imge = data["problem_image"]
        hirabun = ocr(base64imge)

        data["hirabun"] = hirabun
        # 平文から穴埋め問題を作成
        #hirabun = data["hirabun"]
        problem = gen_problem.gen_problem(hirabun)

        mondaibun_list = problem["mondaibun_list"]
        ana = problem["ana"]

        # Problemに渡す連想配列を作成
        problem_dict = {}
        problem_dict["mondaibun_list"] = mondaibun_list
        problem_dict["ana"] = ana

        # order_numが指定されている場合はそのまま
        if data["order_num"]:
            problem_dict["order_num"] = data["order_num"]
        # 指定されていない場合は最後に追加
        else:
            problem_dict["order_num"] = Problem.objects.all().count() + 1

        # Problemを作成
        created_problem = Problem.objects.create(**problem_dict, user_id=request.user.id)

        # Problemをシリアライズ
        problem_serializer = ProblemSerializer(data=problem_dict)

        # バリテーション
        if not problem_serializer.is_valid():
            print(problem_serializer.errors)
            return Response("validation error........2")

        result = problem_serializer.data

        return result, created_problem

    def create(self, request):
        """
         問題の作成
        """
        
        # Problemを作成
        result, created_problem = ProblemViewSet().create_problem(request.data, request)

        # Noteに作成したProblemを追加
        Note.objects.get(id=request.data["note_id"]).problem.add(created_problem)
        return Response(result)
    
    def update(self, request, pk):
        """
         問題の更新 (order_numの更新)
        """
        # 更新するProblemを取得
        problem = Problem.objects.get(id=pk)

        # 更新するProblemのorder_numを更新
        problem.order_num = request.data["order_num"]
        problem.save()

        return Response("success")
    
