# Generated by Django 4.2.5 on 2023-10-02 16:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_note_created_at_note_updated_at_problem_created_at_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Hirabun',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('hirabun', models.CharField(max_length=1000)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('note_id', models.IntegerField()),
            ],
        ),
        migrations.AlterField(
            model_name='problem',
            name='note',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='problem', to='api.note'),
        ),
    ]
