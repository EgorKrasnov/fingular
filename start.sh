#!/bin/bash
set -e  # прерывать выполнение при ошибке

# 1. Запускаем docker-контейнер с Postgres
echo "🚀 Запускаем Docker Compose..."
docker compose up -d

# 2. Создаём виртуальное окружение
if [ ! -d "venv" ]; then
  echo "🌀 Создаём виртуальное окружение..."
  python3 -m venv venv
fi

# 3. Активируем окружение
echo "✅ Активируем окружение..."
source venv/bin/activate

# 4. Обновляем pip и ставим зависимости
echo "📦 Устанавливаем зависимости..."
python3 -m pip install --upgrade pip
if [ -f "requirements.txt" ]; then
  python3 -m pip install -r requirements.txt
fi

# 5. Запускаем Jupyter Lab
echo "📓 Запускаем Jupyter Lab..."
jupyter lab

