# Bookshelf

Лабораторні роботи з дисципліни «Сучасні методи WEB-програмування» (Поліський національний університет).
Проєкт створено на основі темплейту [hborysov/Template](https://github.com/hborysov/Template) (Rails 8, PostgreSQL, тема AppStack).

| Лабораторна | Тема | Тег |
|---|---|---|
| ЛР2 | Ініціалізація проєкту, MVC і CRUD | `lab-2` |
| ЛР3 | Моделі, зв'язки, міграції, scope'и, пошук/сортування | `lab-3` |
| ЛР4 | JSON API, тестування та документація API у Postman | `lab-4` |
| ЛР5 | Shrine (обкладинки), Active Job (імпорт CSV), Action Mailer (звіт) | `lab-5` |
| ЛР6 | GraphQL API: типи, query, mutation, GraphiQL | `lab-6` |

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

## JSON API v1

Колекція Postman: [`docs/postman/bookshelf.postman_collection.json`](docs/postman/bookshelf.postman_collection.json).

| Метод | Шлях | Параметри | Опис |
|---|---|---|---|
| GET | `/api/v1/books` | `page` (≥1, за замовч. 1), `per_page` (1–100, за замовч. 10), `title` (частина назви), `author_id` | Список книг з пагінацією та фільтрами |
| GET | `/api/v1/books/:id` | – | Одна книга |

Приклад відповіді `GET /api/v1/books?per_page=1`:

```json
{
  "data": [
    {
      "id": 1,
      "title": "Тіні забутих предків",
      "year": 1911,
      "description": "...",
      "author": { "id": 1, "name": "Михайло Коцюбинський" },
      "created_at": "2026-11-05T14:00:00.000Z",
      "updated_at": "2026-11-05T14:00:00.000Z"
    }
  ],
  "meta": { "page": 1, "per_page": 1, "total_count": 12, "total_pages": 12 }
}
```

Помилки: `400 Bad Request` (некоректні `page`, `per_page`, `author_id`), `404 Not Found` (книги не існує):

```json
{ "errors": [{ "status": 404, "title": "Not found", "detail": "Book with id=0 not found" }] }
```

## Тести

```bash
bin/rails db:test:prepare
bundle exec rspec
```

## ЛР5: обкладинки, імпорт CSV і e-mail звіт

- Обкладинка книги завантажується через Shrine (`app/uploaders/cover_uploader.rb`), файли – у `public/uploads`.
  Завантажувати обкладинку може лише адміністратор (`/admins/sign_in`, admin@example.com / password).
- Імпорт книг: `/admin/imports/new`, приклад файлу – `public/samples/books_import.csv`
  (колонки `title,author_name,year,description`). Імпорт виконує `ImportBooksJob`,
  результат зберігається в таблиці `imports`.
- Після імпорту `UserMailer#import_report` надсилає звіт адміністратору.
  У development листи переглядаються на `/letter_opener`.

## ЛР6: GraphQL

- Endpoint: `POST /graphql`, IDE GraphiQL (development): `/graphiql`.
- Типи: `BookType`, `AuthorType` (`app/graphql/types`).
- Query: `books(title, authorId, limit, offset)`, `book(id)`, `authors(activeOnly)`.
- Mutation: `createBook(input: { title, authorId, year, description })` → `{ book, errors }`.

```graphql
mutation {
  createBook(input: { title: "Берег любові", authorId: 4, year: 1976 }) {
    book { id title year author { name } }
    errors
  }
}
```
