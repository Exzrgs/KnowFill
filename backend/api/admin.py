from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Problem
#adminにProblemを登録
admin.site.register(Problem)
