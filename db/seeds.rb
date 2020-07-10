# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Sake.create!(
  name: "", # 必須。空文字不可。
  kura: "",
  photo: nil,
  bindume_date: DateTime.new(2020, 6, 1),
  brew_year: DateTime.new(2020, 6, 1),
  todouhuken: "",
  taste_value: nil, # integer 0 - 10
  aroma_value: nil, # integer 0 - 10
  nihonshudo: nil,
  sando: nil,
  aroma_impression: "",
  color: "",
  taste_impression: "",
  nigori: "",
  awa: "",
  tokutei_meisho: nil,
  #   nothing: 0,
  #   honjozo: 1,
  #   ginjo: 2,
  #   daiginjo: 3,
  #   junmai: 4,
  #   junmai_ginjo: 5,
  #   junmai_daiginjo: 6,
  #   tokubetsu_honjozo: 7,
  #   tokubetsu_junmai: 8,
  genryoumai: "",
  kakemai: "",
  koubo: "",
  alcohol: nil,
  aminosando: nil,
  season: "",
  is_genshu: nil, # true or false
  moto: nil,
  #   unknown: 0,
  #   kimoto: 1,
  #   yamahai: 2,
  #   sokujo: 3,
  seimai_buai: nil,
  roka: "",
  shibori: "",
  note: "",
  bottle_state: nil,
  #   sealed: 0,
  #   opened: 1,
  #   empty: 2,
  hiire_state: nil,
  #   unknown: 0,
  #   namanama: 1,
  #   mae_hiire: 2,
  #   ato_hiire: 3,
  #   nido_hiire: 4,
  price: nil
)
