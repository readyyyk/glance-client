# Glance App Deployment

Этот репозиторий содержит конфигурацию для развертывания приложения Glance на платформе Railway с использованием Docker и GitHub Actions.

## Структура проекта

- `Dockerfile` - Файл для создания Docker-образа
- `.github/workflows/railway-deploy.yml` - Конфигурация GitHub Actions для CI/CD
- `config/` - Конфигурационные файлы приложения
- `assets/` - Ресурсы приложения

## Локальное развертывание

Для локального запуска приложения с использованием Docker:

```bash
# Сборка Docker-образа
docker build -t glance-app .

# Запуск контейнера
docker run -p 8080:8080 glance-app

# Приложение будет доступно по адресу http://localhost:8080
```

## Настройка CI/CD для Railway

### Предварительные требования

1. Аккаунт на [Railway](https://railway.app/)
2. Аккаунт на GitHub с настроенным репозиторием

### Шаги настройки

1. Установите CLI Railway:
   ```bash
   npm i -g @railway/cli
   ```

2. Войдите в Railway:
   ```bash
   railway login
   ```

3. Создайте новый проект:
   ```bash
   railway init
   ```

4. Получите токен Railway:
   ```bash
   railway login --browserless
   ```

5. Добавьте токен как секрет в репозиторий GitHub:
   - Перейдите в настройки репозитория
   - Выберите "Secrets and variables" > "Actions"
   - Нажмите "New repository secret"
   - Имя: `RAILWAY_TOKEN`
   - Значение: (вставьте ваш токен Railway)

6. Убедитесь, что в файле `.github/workflows/railway-deploy.yml` указано правильное имя сервиса (по умолчанию "glance")

### Процесс развертывания

1. Отправьте изменения в ветку main вашего репозитория GitHub
2. GitHub Actions автоматически соберет Docker-образ и отправит его в GitHub Container Registry
3. Затем workflow развернет образ на Railway
4. Вы можете отслеживать процесс развертывания во вкладке GitHub Actions и в панели управления Railway

## Переменные окружения

Переменные окружения можно настроить:

1. В Dockerfile (для значений по умолчанию)
2. В панели управления Railway (для переопределения значений)

Текущие переменные окружения:
- `MY_SECRET_TOKEN` - Секретный токен для приложения

## Мониторинг и обслуживание

- Логи приложения доступны в панели управления Railway
- Обновления можно выполнять, просто отправляя изменения в ветку main
- При необходимости можно выполнить ручное развертывание с помощью Railway CLI:
```bash
railway up
```