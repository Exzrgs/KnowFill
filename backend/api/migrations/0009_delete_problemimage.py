# Generated by Django 4.2.5 on 2023-10-14 04:00

from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("api", "0008_alter_problemimage_problem_image"),
    ]

    operations = [
        migrations.DeleteModel(
            name="ProblemImage",
        ),
    ]
