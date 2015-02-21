#Rubyのサンドボックス

##add_tag_dash_lib
dashのスニペットのsyntaxに応じて、titleの先頭に[Obj-C]みたいなタグを付与

##newest_gitignore
https://github.com/github/gitignore

にあるgitignoreを指定すると、取ってきて結合してglobalなgitignoreを作成する

##twitter_api_key_token
`TwitterAPIKeys.toml`からkeyやtokenを読み込んで返す  
もし`TwitterAPIKeys.toml`が無ければ新しく生成する

keyやらtokenは https://apps.twitter.com/ からgenerate

##twitter_favo_image_getter
指定したユーザのFavoriteを取得し、そこに掲載されている画像を収集する  
API的に最大200favoまで  
Parallelでマルチタスクにした場合、多すぎる(8以上？or未指定の時？)とバッファエラーになる？

##suddenly_death
任意の文字列を入力すると

 ＿人人人人人人＿  
＞　突然の死　＜  
￣Y^Y^Y^Y^Y￣  
を生成するだけ