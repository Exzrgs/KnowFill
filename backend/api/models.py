from django.db import models

# Create your models here.
class Problem(models.Model):
    title = models.CharField(max_length=50)
    content = models.CharField(max_length=400)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
