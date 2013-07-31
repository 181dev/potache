Potache
==========================

ぽたっしゅと読みます。簡単なドキュメント指向DBアプリを作ることが出来ます。Webブラウザ経由でテンプレートを編集できるエディタが内蔵されており、外部エディタは必要ありません。アプリ自体を書き換えながら開発することが出来る「自己書き換え型フレームワーク」です。

セキュリティも何もありませんが、ローカルでゆるく開発し、エディタ部分を除去してデプロイすることを念頭に置いています。


Create simple DB app on Heroku and use it on your iPhone.

MongoDB + Mustache + Sinatra + ACE Editor

Get started:

    MongoLab等でデータベースを作成し、DBの読み書きのできるユーザを作成後、URIを取得しておく。

    $ bundle install
    $ echo "export MONGODB_URI=MongoDBのURI" >> .bashrc
    $ rackup


