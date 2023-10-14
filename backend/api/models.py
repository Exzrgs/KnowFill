from django.db import models
from django.contrib.postgres.fields import ArrayField
from django.contrib.auth.models import User
# Create your models here.


class Note(models.Model):
    """
    書籍ごとの問題を持つノートクラス
    """

    title = models.CharField(max_length=10)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    order_num = models.IntegerField(null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    # sumnail


class Problem(models.Model):
    """
    穴埋め問題クラス
    """
    mondaibun_list = ArrayField(models.CharField(max_length=2000, blank=True))
    ana = ArrayField(models.CharField(max_length=2000))
    note = models.ForeignKey(
        Note, related_name="problem", on_delete=models.CASCADE, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    order_num = models.IntegerField(null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)


class Hirabun(models.Model):
    """
    問題の生の文字列
    """

    hirabun = models.CharField(max_length=100000)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    note_id = models.IntegerField()
    order_num = models.IntegerField(null=True, blank=True)
