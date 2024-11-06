# HN Submission

## Migrations

To create a new migration, use `poetry` + `alembic`:

```bash
poetry run alembic revision --autogenerate -m "Add a new table"
```

To run the migrations to the latest version:

```bash
poetry run alembic upgrade head
```
