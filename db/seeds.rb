# frozen_string_literal: true

# Idempotent seeds: safe to run `bin/rails db:seed` several times.

Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
end

authors = [
  { name: 'Михайло Коцюбинський', active: true,
    bio: 'Український письменник-імпресіоніст, автор повістей і новел.',
    books: [
      { title: 'Intermezzo', year: 1908,
        description: 'Новела про втомленого митця, який відновлює сили на природі.' },
      { title: 'Fata morgana', year: 1910,
        description: 'Повість про життя українського села на початку XX століття.' },
      { title: 'Тіні забутих предків', year: 1911,
        description: 'Повість про кохання Івана та Марічки на тлі гуцульських традицій і вірувань.' }
    ] },
  { name: 'Леся Українка', active: true,
    bio: 'Українська поетеса і драматургиня.',
    books: [
      { title: 'Лісова пісня', year: 1911,
        description: 'Драма-феєрія про мавку та людину, що поєднує фольклор і філософію.' },
      { title: 'Камінний господар', year: 1912,
        description: 'Драма на сюжет легенди про Дон Жуана.' }
    ] },
  { name: 'Іван Багряний', active: true,
    bio: 'Український письменник, публіцист і політичний діяч.',
    books: [
      { title: 'Тигролови', year: 1944,
        description: 'Пригодницький роман про втечу засланця на Далекому Сході.' },
      { title: 'Сад Гетсиманський', year: 1950,
        description: 'Автобіографічний роман про ув\'язнення в радянських тюрмах.' }
    ] },
  { name: 'Олесь Гончар', active: true,
    bio: 'Український письменник, автор романів і новел.',
    books: [
      { title: 'Прапороносці', year: 1948,
        description: 'Трилогія про шлях піхотного полку в останні роки Другої світової війни.' },
      { title: 'Собор', year: 1968,
        description: 'Роман про збереження історичної пам\'яті та духовних цінностей.' }
    ] },
  { name: "Валер'ян Підмогильний", active: false,
    bio: 'Український прозаїк і перекладач, представник «Розстріляного відродження».',
    books: [
      { title: 'Місто', year: 1928,
        description: 'Перший український урбаністичний роман про юнака з села у великому місті.' }
    ] },
  { name: 'Andrew Hunt, David Thomas', active: false,
    bio: 'Автори книжок про практики професійної розробки програмного забезпечення.',
    books: [
      { title: 'The Pragmatic Programmer', year: 1999,
        description: 'Практичні поради щодо професійної розробки програмного забезпечення.' }
    ] }
]

authors.each do |attrs|
  author = Author.find_or_initialize_by(name: attrs[:name])
  author.update!(bio: attrs[:bio], active: attrs[:active])

  attrs[:books].each do |book_attrs|
    book = Book.find_or_initialize_by(title: book_attrs[:title])
    book.author ||= author
    if book.new_record?
      book.year = book_attrs[:year]
      book.description = book_attrs[:description]
    end
    book.save!
  end
end

puts "Seeded: #{Admin.count} admin(s), #{Author.count} author(s) " \
     "(#{Author.active.count} active), #{Book.count} book(s)"
