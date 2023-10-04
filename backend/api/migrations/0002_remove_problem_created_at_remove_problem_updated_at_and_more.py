# Generated by Django 4.2.5 on 2023-10-01 07:52

import django.contrib.postgres.fields
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='problem',
            name='created_at',
        ),
        migrations.RemoveField(
            model_name='problem',
            name='updated_at',
        ),
        migrations.AlterField(
            model_name='note',
            name='title',
            field=models.CharField(max_length=10),
        ),
        migrations.AlterField(
            model_name='problem',
            name='mondaibun_list',
            field=django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=200), blank=True, null=True, size=None),
        ),
        migrations.AlterField(
            model_name='problem',
            name='note',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='problems', to='api.note'),
        ),
    ]
