# Bookshelf

Лабораторні роботи з дисципліни «Сучасні методи WEB-програмування» (Поліський національний університет).
Проєкт створено на основі темплейту [hborysov/Template](https://github.com/hborysov/Template) (Rails 8, PostgreSQL, тема AppStack).

| Лабораторна | Тема | Тег |
|---|---|---|
| ЛР2 | Ініціалізація проєкту, MVC і CRUD | `lab-2` |

## Вимоги

* Ruby 3.4.2
* PostgreSQL (локально, автентифікація через системного користувача)

## Запуск (Ubuntu)

```bash
sudo apt install -y postgresql libpq-dev
sudo -u postgres createuser -s $USER

bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
bin/rails server -b 0.0.0.0
```

Застосунок доступний за адресою `http://<IP>:3000/`. Головна сторінка — список книг.

Адмін-панель: `/admin`, вхід `admin@example.com` / `password`.
