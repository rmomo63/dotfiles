# 参考
# http://tukaikta.blog135.fc2.com/blog-entry-251.html

# Sublime text と Atomのシンボリックリンク
sudo ln -s /Applications/Atom.app/Contents/MacOS/Atom /usr/local/bin/atom
sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

# スクリーンショット関連
## 影を含まない
defaults write com.apple.screencapture disable-shadow -boolean true

# Finder関連
## ライブラリを表示
chflags nohidden ~/Library

## 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles TRUE

## タイトルバーをフルパスに
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

## パスバー階層をhomeから
defaults write com.apple.finder PathBarRootAtHome -bool yes

## Quicklookでテキスト選択可能に
defaults write com.apple.finder QLEnableTextSelection -bool true

## ネットワークボリューム上に.DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
