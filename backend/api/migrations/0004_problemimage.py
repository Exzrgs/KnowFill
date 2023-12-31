# Generated by Django 4.2.5 on 2023-10-14 00:49

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("api", "0003_alter_problem_note"),
    ]

    operations = [
        migrations.CreateModel(
            name="ProblemImage",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("problem_image", models.ImageField(upload_to="problem_images/")),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                ("note_id", models.IntegerField()),
                ("order_num", models.IntegerField(blank=True, null=True)),
            ],
        ),
    ]
