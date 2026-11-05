# frozen_string_literal: true

# Idempotent seeds: safe to run `bin/rails db:seed` several times.

Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
end

books = [
  { title: 'Тіні забутих предків', author: 'Михайло Коцюбинський', year: 1911,
    description: 'Повість про кохання Івана та Марічки на тлі гуцульських традицій і вірувань.' },
  { title: 'Лісова пісня', author: 'Леся Українка', year: 1911,
    description: 'Драма-феєрія про мавку та людину, що поєднує фольклор і філософію.' },
  { title: 'Місто', author: "Валер'ян Підмогильний", year: 1928,
    description: 'Перший український урбаністичний роман про юнака з села у великому місті.' },
  { title: 'Тигролови', author: 'Іван Багряний', year: 1944,
    description: 'Пригодницький роман про втечу засланця на Далекому Сході.' },
  { title: 'Собор', author: 'Олесь Гончар', year: 1968,
    description: 'Роман про збереження історичної пам\'яті та духовних цінностей.' },
  { title: 'The Pragmatic Programmer', author: 'Andrew Hunt, David Thomas', year: 1999,
    description: 'Практичні поради щодо професійної розробки програмного забезпечення.' }
]

books.each do |attrs|
  Book.find_or_create_by!(title: attrs[:title], author: attrs[:author]) do |book|
    book.year = attrs[:year]
    book.description = attrs[:description]
  end
end

puts "Seeded: #{Admin.count} admin(s), #{Book.count} book(s)"
