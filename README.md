# Тестовое задание: PostgreSQL + SQLAlchemy + Jupyter Lab

## 📌 Описание
Репозиторий демонстрирует:
- запуск PostgreSQL в Docker через docker-compose,
- инициализацию схемы БД из файла [`init.sql`](./init.sql),
- подключение к базе из Jupyter Notebook (`test_task.ipynb`) через SQLAlchemy,
- генерацию мок-данных с фиксированным random seed,
- выполнение аналитических SQL-запросов (хранятся в папке [`query/`](./query)).

## 🚀 Запуск проекта

1. Запуск всех сервисов и окружения одной командой:
```bash
./start.sh
```
Скрипт автоматически:
- поднимает контейнер с PostgreSQL,
- создаёт и активирует виртуальное окружение,
- устанавливает зависимости из `requirements.txt`,
- запускает Jupyter Lab.

2. Ручной запуск (альтернатива):
```bash
docker compose up -d
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
jupyter lab
```

## 📊 Структура проекта

- `test_task.ipynb` — основной Jupyter Notebook с кодом генерации данных, подключением к БД и выполнением SQL-запросов.
- `query/` — сохранённые SQL-запросы:
	- `query_1.sql`, ..., `query_5.sql`
- `init.sql` — SQL-скрипт для инициализации схемы БД при старте контейнера.
- `docker-compose.yml` — конфигурация сервиса PostgreSQL.
- `requirements.txt` — список Python-зависимостей.
- `start.sh` — скрипт для автоматического запуска всех компонентов.

🛠 Используемые технологии

- PostgreSQL (в Docker)
- Python (SQLAlchemy, Pandas, Faker)
- Jupyter Lab
- Docker Compose

✅ Генерация данных

Мок-данные создаются с помощью библиотеки Faker.
Используется фиксированный random seed → при каждом запуске генерируются одинаковые данные.

📑 Запросы
Все ключевые SQL-запросы сохранены в директорию query
Каждый файл соответствует одной задаче из тестового задания.
