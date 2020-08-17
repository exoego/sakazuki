# Sakazuki

自宅の酒を管理するアプリケーション

# Requirements

- Ruby >= 2.7.1
- Rails >= 6.0.3.2
- Yarn🐈 >= 1.22.4
- PostgreSQL >= 12.0

# How to use

- 依存関係のインストール
    - `bundle install`
    - `yarn install --check-files`
- メーラの設定
    - ユーザのメールアドレスに通知するために使われる
```yaml
# config/setting.local.yml
mail:
     smtp: "smtp.gmail.com"
     domain: "gmail.com"
     port: 587
     user_name: "your_mail_address@gmail.com"
     password: "your_gmail_password"
```
- PostgreSQLのユーザの設定
    - PostgreSQLへの接続に使われる
```yaml
# config/database.yml
development:
  <<: *default
  database: sakazuki_development
  username: <your postgresql login name> # この2行を
  password: <your postgresql password>   # 追記する

```
- 最初のユーザの設定
    - `bundle exec rails db:seed`
- サーバの起動
    - `bundle exec rails server`
- http://localhost:3000/ へアクセスする
- 最初の管理者ユーザの設定（オプション）
    - Sakazukiへのログインに使われる
```ruby
# db/seed.rb
User.create!(
  email: "<your emacs address>",      # この2行を
  password: "your account password>", # 編集する
  admin: true,
)
```
- ログイン
    - メールアドレス: `example@example.com`
    - パスワード: `rootroot`
    - または前項で書き換えた内容でログイン
- localユーザの設定
    - まだ

# How to Contribute

- まだ
