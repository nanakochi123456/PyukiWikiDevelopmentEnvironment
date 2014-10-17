######################################################################
# @@HEADER1@@
######################################################################
use strict;

######################################################################
# en:Default Language
# ja:デフォルトの言語
######################################################################
# en:Select Defualt Language
# ja:デフォルト言語選択
# @{ja:Japanese/en:English}
$::lang = "ja";

######################################################################
# ja:言語設定
######################################################################
# ja:漢字コード（日本語のみ）#utf8
# @{utf8:utf8 only}#utf8
$::kanjicode = "utf8";#utf8

# ja:キャラクターコード#utf8
# @{utf-8}#utf8
$::charset = "utf-8";#utf8

# ja:漢字コード（日本語のみ）#euc
# @ja{euc:EUC-JP/sjis:Shift-JIS/utf8:UTF-8}#euc
$::kanjicode = "euc";#euc

# ja:キャラクターコード#euc
# @{}#euc
$::charset = "";#euc

# ja:言語コード変換			# Jcode Only!!
# @ja{Jcode:Jcode.pm}
$::code_method{ja} = "Jcode";

######################################################################
# ja:データ格納ディレクトリ
######################################################################

# ja:CGIからのみアクセスするデータのディレクトリ
# @{.}
$::data_home = '.';

# ja:ブラウザから見れるデータのアドレス
# @{.}
$::data_pub = '.';

# ja:ブラウザからの絶対・相対ディレクトリ
# @{.}
$::data_url = '.';

# ja:システムの格納ディレクトリ　通常は変更しないで下さい
# @{.}
$::bin_home = '.';

## cgi-binが別のディレクトリの例
## for sourceforge.jp
## /home/groups/p/py/pyukiwiki/htdocs
## /home/groups/p/py/pyukiwiki/cgi-bin
#$::data_home = '.';
#$::data_pub = '../htdocs';
#$::data_url = '..';

## Windows NT Server (IIS+ActivePerl)の場合の例
#$::data_home = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_pub = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_url = '.';

# ja:ページデータ保存用ディレクトリ
# @{$::data_home/wiki}
$::data_dir    = "$::data_home/wiki";

# ja:バックアップ保存用ディレクトリ #nocompact
# @{$::data_home/backup}#nocompact
$::backup_dir  = "$::data_home/backup";

# ja:差分保存用ディレクトリ
# @{$::data_home/diff}
$::diff_dir    = "$::data_home/diff";

# ja:キャッシュ保存用ディレクトリ
# @{$::data_pub/cache}
$::cache_dir   = "$::data_pub/cache";

# ja:キャッシュ公開用アドレス
# @{$::data_url/cache}
$::cache_url   = "$::data_url/cache";

# ja:添付ファイル格納ディレクトリ
# @{$::data_pub/attach}
$::upload_dir  = "$::data_pub/attach";

# ja:添付ファイル公開用アドレス
# @{$::data_url/attach}
$::upload_url  = "$::data_url/attach";

# ja:アクセスカウンター格納用ディレクトリ
# @{$::data_url/counter}
$::counter_dir = "$::data_home/counter";

# ja:プラグイン格納ディレクトリ
# @{$::bin_home/plugin}
$::plugin_dir  = "$::bin_home/plugin";

# ja:Exプラグイン格納ディレクトリ
# @{$::bin_home/lib}
$::explugin_dir= "$::bin_home/lib";

# ja:スキン格納用ディレイクトリ
# @{$::data_pub/skin}
$::skin_dir    = "$::data_pub/skin";

# ja:スキン公開用ディレクトリ
# @{$::data_url/skin}
$::skin_url    = "$::data_url/skin";

# ja:画像格納用ディレクトリ
# @{$::data_pub/image}
$::image_dir   = "$::data_pub/image";

# ja:画像公開用URL
# @{$::data_url/image}
$::image_url   = "$::data_url/image";

# ja:文書情報格納ディレクトリ
# @{$::data_home/info}
$::info_dir    = "$::data_home/info";

# ja:リソース格納ディレクトリ
# @{$::bin_home/resource}
$::res_dir     = "$::bin_home/resource";

# ja:システム用ディレクトリ
# @{$::bin_home/lib}
$::sys_dir	   = "$::bin_home/lib";

# ja:XSモジュール用ディレクトリ
# @{$::bin_home/blib}
$::sysxs_dir   = "$::bin_home/blib";

######################################################################
# ja:スキン設定
######################################################################
# ja:スキン名称
# @{@list:$::skin_dir/*.skin.cgi}
$::skin_name   = "pyukiwiki";
$::use_blosxom = 0;	# blosxom.cssを使用するとき１にする


# ja:JavaScriptタグの位置
# @{0:head内/1:bodyの後ろ}
$::js_lasttag=1;

# for tdiary theme wrapper
#$::skin_name = "tdiary";
#$::skin_name{tdiary} = "tdiary_theme";
##$::skin_selector{tdiary} = "theme_id:alias name,theme_id:alias name";
##   setting.inc.cgi から選択できるようになる
##   件数が多すぎるとサンプルが表示できない可能性があります。

######################################################################
# 動的セットアップファイル
######################################################################
$::setup_file = "$::info_dir/setup.ini.cgi";
$::ngwords_file = "$::info_dir/setup_ngwords.ini.cgi";

######################################################################
# ja:HTTPプロキシ設定　通常設定不要です。
######################################################################
# ja:プロキシサーバーのホスト名
# @{}
$::proxy_host = '';

# ja:プロキシサーバーのポート
# @{3128}
$::proxy_port = 3128;

######################################################################
# ja:wiki、修正者情報
# (各変数の言語名の連想配列にすると、言語別にできます）
######################################################################
# ja:サイト名
# @{PyukiWiki}
$::wiki_title = 'PyukiWiki';

# （英語時のタイトル）
#$::wiki_title{en} = 'PyukiWiki';

# ja:修正者名（サイト管理者名）
# @{anonymous}
$::modifier = 'anonymous';

# ja:修正者URL
# @{}
$::modifierlink = '';

# ja:修正者メールアドレス
# @{}
$::modifier_mail = '';

# ja:検索キーワード
# @{$::wiki_title}
$::meta_keyword = "$::wiki_title";

# ja:タイトルの親階層を省略する
# @ja{1:省略する/0省略しない}
$::short_title = 0;

######################################################################
# ja:ロゴ
######################################################################
# ja:ロゴのURL
# @{$::image_url/pyukiwiki.png}
$::logo_url = "$::image_url/pyukiwiki.png";

# ja:ロゴの横幅
# @{80}
$::logo_width = 80;

# ja:ロゴの高さ
# @{80}
$::logo_height = 80;

# ja:ロゴの代替文字
# @{[PyukiWiki]}
$::logo_alt = "[PyukiWiki]";

######################################################################
# スクリプト名の設定
######################################################################
# servererror、urlhackプラグインを使用する場合は、自動取得ではなく
# $::scriptを必ず指定して下さい。
#$::script			 =  'index.cgi';
# ja:スクリプト名の設定（入力なしで自動取得）
# @ja{:自動取得/index.cgi:index.cgi/nph-index.cgi:nph-index.cgi/index.xcg:index.xcg}
$::script			 =  '';

# ja:基準URL（入力なしで自動取得）
# @{}
$::basehref			 =  '';

# ja:自分自身のスクリプト名
# @{index\.cgi|nph\-index\.cgi|index\.xcg}
$::defaultindex		 =  'index\.cgi|nph\-index\.cgi|index\.xcg';

# ja:cookie用基準パス（入力なしで自動取得）
# @{}
$::basepath			 =  '';

######################################################################
# ja:デフォルトページ名
######################################################################

# ja:FrontPage　トップページ
# @{FrontPage}
$::FrontPage		 =  'FrontPage';

# ja:RecentChanges　変更履歴
# @{RecentChanges}
$::RecentChanges	 =  'RecentChanges';

# ja:MenuBar　左のメニュー
# @{MenuBar}
$::MenuBar			 =  'MenuBar';

# ja:SideBar　右のメニュー
# @{:SideBar}
$::SideBar			 =  ':SideBar';

# ja:TitleHeader　上部のバナー用
# @{:TitleHeader}
$::TitleHeader		 =  ':TitleHeader';

# ja:Header ページ上部に表示
# @{:Header}
$::Header			 =  ':Header';

# ja:BodyHeader　Headerより下に表示
# @{:BodyHeader}
$::BodyHeader		 =  ':BodyHeader';

# ja:Footer ページ下部に表示
# @{:Footer}
$::Footer			 =  ':Footer';

# ja:BodyFooter　Footerより上に表示
# @{:BodyFooter}
$::BodyFooter		 =  ':BodyFooter';

# ja:SkinFooter　PyukiWikiの著作権情報の部分に表示
# @{:SkinFooter}
$::SkinFooter		 =  ':SkinFooter';

# ja:SandBox　砂場（練習場）
# @{SandBox}
$::SandBox			 =  'SandBox';

# ja:InterWikiName　InterWiki定義
# @{InterWikiName}
$::InterWikiName	 =  'InterWikiName';

# ja:InterWikiSandBox　InterWiki練習場
# @{InterWikiSandBox}
$::InterWikiSandBox	 =  'InterWikiSandBox';

# ja:Template　新規作成時の自動テンプレート読み込み by idea by koyakei
# @{Template}
$::Template		 =  ":Template";

# ja:ErrorPage　エラー表示ページ
# @{ErrorPage}
$::ErrorPage		 =  "ErrorPage";

# ja:AdminPage　管理者用ページ（?cmd=admin)
# @{AdminPage}
$::AdminPage		 =  "AdminPage";

# ja:IndexPage　一覧のページ（?cmd=list)
# @{IndexPage}
$::IndexPage		 =  "IndexPage";

# ja:SearchPage　検索ページ（?cmd=search)
# @{SearchPage}
$::SearchPage		 =  "SearchPage";

# ja:CreatePage　新規作成ページ（?cmd=newpage)
# @{CreatePage}
$::CreatePage		 =  "CreatePage";

######################################################################
# ja:管理者パスワードの保存方法
######################################################################

# ja:管理者パスワードの暗号化方法
# @ja{AUTO:自動（通常は変更しないで下さい）/CRYPT:CRYPT/MD5:MD5/SHA1:SHA1/SHA256:SHA256/SHA384:SHA384/SHA512:SHA512/TEXT:生テキスト}
$::CryptMethod = "AUTO";

######################################################################
# パスワード設定
######################################################################

# [pass] of cross MD5
#$::adminpass = '{MD5}21a37805a1e67cd6142d30ef780ce771';

# [pass] of text
$::adminpass = '{TEXT}pass';

# [pass] of plain crypt
#$::adminpass = crypt("pass", "AA");

# パスワードを別にする場合
#（全共通パスワードでも認証します。全共通を使用しない場合推測困難なパスを入力）
#$::adminpass = 'aetipaesgyaigygoqyiwgorygaeta';# デフォルトを使用時用デコード不能パス
#$::adminpass{admin} = '{TEXT}admin';		# 管理者用パスワード、全共通
#$::adminpass{frozen} = '{TEXT}frozen'	;	# 凍結用パスワード
#$::adminpass{attach} = '{TEXT}attach'	;	# 添付用パスワード

######################################################################
# ja:パスワードのセキュリティー設定
######################################################################
# ja:パスワードを簡易暗号化して送信する。
# @{1:簡易暗号化をする(要JavaScript)/0:生テキストで送信する}
$::Use_CryptPass = 0;						

######################################################################
# 言語リスト
######################################################################

#$::lang_list = "ja en";
#$::lang_list = "ja en cn";

######################################################################
# ja:RSS設定
######################################################################

# ja:RSSの出力凝集
# @{1:1/2:2/3:3/4:4/5:5/6:6/7:7/8:8/9:9/10:10/15:15/20:20/25:25/30:30}
$::rss_lines = 15;

# ja:RSSのdescriptionの行数を指定する
# @{1:1/2:2/3:3/4:4/5:5/6:6/7:7/8:8/9:9/10:10}
$::rss_description_line = 1;

# RSS情報 (各変数の言語名の連想配列にすると、言語別にできます）# ja:RSSの表題
# @{$::wiki_title}
$::modifier_rss_title = $::wiki_title;

# ja:RSSのリンク先（指定なしで自動取得）
# @{}
$::modifier_rss_link = '';

# ja:RSSの説明
# @{Modified by $::modifier}
$::modifier_rss_description = "Modified by $::modifier";

#$::modifier_rss_title = "PyukiWiki $::version";
#$::modifier_rss_link = '@@PYUKI_URL@@';
#$::modifier_rss_description = 'This is PyukiWiki.';

%::rssenable;							# RSS/ATOM/OPMLの有効無効

# ja:RSS1.0を有効にする
# @{1:有効/0:無効}
$::rssenable{rss10} = 1;

# ja:RSS2.0を有効にする
# @{1:有効/0:無効}
$::rssenable{rss20} = 1;

# ja:ATOMを有効にする
# @{1:有効/0:無効}
$::rssenable{atom} = 1;

# ja:OPMLを有効にする
# @{1:有効/0:無効}
$::rssenable{opml} = 1;

######################################################################
# プラグイン設定
######################################################################
$::plugin_disable{pluginname} = 1;	# pluginnameを無効にする
#$::plugin_disable{bugtrack} = 1;	# bugtrackを無効にする

######################################################################
# ja:Exプラグイン設定
######################################################################
# ja:expluginの使用
# @ja{1:使用する/0:使用しない}
$::useExPlugin = 1;

######################################################################
# ja:HTML出力モード
######################################################################

# ja:PCの出力モード
# @ja{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5（未実装）}
$::htmlmode = "html4";

# ja:スマートフォンの出力モード（未実装）
# @{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5（未実装）}
$::htmlmode{sp} = "html5";

# ja:モバイルの出力モード（未実装）
# @{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5（未実装）}
$::htmlmode{mobile} = "xhtml10t";

###################################################################### #nocompact
# バックアップの使用#nocompact
###################################################################### #nocompact
# ja:バックアップを使用する#nocompact
# @{1:使用する/0:使用しない} #nocompact
$::useBackUp = 1;#nocompact

######################################################################
# ja:表示設定
######################################################################
# ja:フェイスマーク
# @{1:使う/0:使わない}
$::usefacemark = 1;

# ja:ポップアップ
# @{0:普通にリンクする/1:ポップアップをする/2:サーバー名(HTTP_HOST)を比較して、同一なら普通にリンクする/3:アドレス($basehref)を比較して同一なら普通に（動作しないサーバーあり）}
$::use_popup = 1;

# ja:wiki文書をデフォルトで改行させる
# @{0:しない/1:する}
$::line_break = 0;

# ja:最終更新日の表示位置
# @{0:表示しない/1:上部に表示する/2:下部に表示する}
$::last_modified = 2;

# ja:最終更新日のプロンプト
# @{Last-modified:}
$::lastmod_prompt = 'Last-modified:';

# ja:全ての画面で、Header、MenuBar、Footerを表示する
# @{1:する/0:しない}
$::allview = 1;	

# ja:注釈の表示位置
# @{0:$bodyの下に表示/1:footerの上に表示/2:footerの下に表示}
$::notesview = 0;

# ja:ページフッターの情報表示（perlバージョン）
# @{1:する/0:しない}
$::enable_last = 1;

# ja:ページフッターに稼働中OSも表示する
# @{1:する/0:しない}
$::enable_last_os = 0;

# ja:ページ表示時間を表示する
# @{1:する/0:しない}
$::enable_convtime = 1;

# ja:圧縮転送をしているか表示する
# @{1:する/0:しない}
$::enable_compress = 1;

# ja:右上の↑
# @{&dagger;}
$::_symbol_anchor = '&dagger;';

######################################################################
# ja:メールアドレス保護
######################################################################

# ja:diffプラグインにおいてメールアドレスを隠す。#compact
# ja:diffプラグイン及びバックアッププラグインにおいてメールアドレスを隠す。#nocompact
# @{1:隠す/0:隠さない}
$::diff_disable_email = 1;

# ja:バックアッププラグインのソース表示にてメールアドレスを隠す。#nocompact
# @{1:隠す/0:隠さない}#nocompact
$::backup_disable_email = 1;

######################################################################
# ja:日時フォーマット
######################################################################
# ja:日付のフォーマット
# @{Y-m-d:yyyy-mm-dd/Y-n-j:yyyy-m-d/y-m-d:yy-mm-dd/y-n-j:yy-m-d/M d Y:Mon d yyyy/d M Y:d Mon yyyy/M d y:Mon d yy/d M y/d Mon yy}
$::date_format = "Y-m-d";

# ja:時刻のフォーマット
# @{H\:i\:s:23\:05\:05/A h\:i\:s:PM 11\:05\:05/h\:i\:s/11\:05\:05}
$::time_format = "H:i:s";

# ja:&now;の日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::now_format = "Y-m-d(lL) H:i:s";

# ja:lastmodの日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::lastmod_format = "Y-m-d(lL) H:i:s";

# ja:recentの日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::recent_format = "Y-m-d(lL) H:i:s";

# ja:バックアップの日時フォーマット#nocompact
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}#nocompact
$::backup_format = "Y-m-d(lL) H:i:s";#nocompact

# ja:attachプラグインでの添付ファイルの日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::attach_format = "Y-m-d(lL) H:i:s";

# ja:refプラグインでの添付ファイルの日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::ref_format = "Y-m-d(lL) H:i:s";

# ja:downloadプラグインでのURLの日時フォーマット
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::download_format = "Y-m-d(lL) H:i:s";

#$::lastmod_format = "y年n月j日(lL) ALg時k分S秒";	# 日本語表示の例

	# 年  :Y:西暦(4桁)/y:西暦(2桁)
	# 月  :n:1-12/m:01-12/M:Jan-Dec/F:January-December
	# 日  :j:1-31/J:01-31
	# 曜日:l:Sunday-Saturday/D:Sun-Sat/DL:日曜日-土曜日/lL:日-土
	# ampm:a:am or pm/A:AM or PM/AL:午前 or 午後
	# 時  : g:1-12/G:0-23/h:01-12/H/00-23
	# 分  : k:0-59/i:00-59
	# 秒  : S:0-59/s:00-59
	# O   : グリニッジとの時間差
	# r RFC 822 フォーマットされた日付 例: Thu, 21 Dec 2000 16:01:07 +0200 
	# Z タイムゾーンのオフセット秒数。 -43200 から 43200 
	# L 閏年であるかどうかを表す論理値。 1なら閏年。0なら閏年ではない。 
	# lL:現在のロケールの言語での曜日（短）
	# DL:現在のロケールの言語での曜日（長）
	# aL:現在のロケールの言語での午前午後（大文字）
	# AL:現在のロケールの言語での午前午後（小文字）
	# t 指定した月の日数。 28 から 31 
	# B Swatch インターネット時間 000 から 999 
	# U Unix 時(1970年1月1日0時0分0秒)からの秒数 See also time() 

######################################################################
# ja:文字変換
######################################################################
# ja:表示文字自動置換
# @{80}
# format : before/after(space)before/after
$::replace{ja}='\\\\/&yen;';

######################################################################
# ja:ページ編集
######################################################################
# ja:テキストエリアのカラム数
# @{80}
$::cols = 80;

# テキストエリアの行数
# @{25}
$::rows = 25;

# 拡張機能(JavaScript)
# @{1:使用する/0:使用しない}
$::extend_edit = 1;

# ja:PukiWikiライクの編集画面
# @{0:PyukiWikiオリジナル/1:PukiWiki互換/2:PukiWiki＋雛形読み込み機能/3:PukiWiki＋新規作成のみ雛形読み込み機能}
$::pukilike_edit = 3;

# ja:プレビューの表示位置
# @{0:編集画面の上/1:編集画面の下}
$::edit_afterpreview = 1;

# ja:新規作成の場合、関連ページのリンクを初期値として表示する
# @{[[$1]]}
$::new_refer = '[[$1]]';

# ja:新規ページ作成画面で、どのページの下層に来るか選択できるようにする
# @{1:使用する/0:使用しない}
$::new_dirnavi = 1;

# ja:ページ編集後、locationで移動する。誤ってリロードボタンを押した時に、警告を表示しない効果がありますが、無料サーバーでは動作しなくなる可能性があります。
# @{1:locationで移動する/0:locationを使用しない}
$::write_location = 1;

# ja:部分編集
# @{0:使用しない/1:使用する/2:凍結ページも使用する}
$::partedit = 1;


# ja:部分編集で、最初の見出しより前の部分を1番目の見出しとみなす
# @{0:見なさない/1:見なす}
$::partfirstblock = 0;

# ja:PukiWiki書式
# @{0:使用しない/1:使用する}
$::usePukiWikiStyle = 1;

# ja:掲示板等、凍結されているページでもプラグインから書き込めるようにする
# @{1:使用する/0:使用しない}
$::writefrozenplugin = 1;

# ja:新規ページ作成の認証
# @{0:誰でも作成できる/1:凍結パスワードが必要}
$::newpage_auth = 0;

# ja:エスケープキーの動作
# @{0:なにもしない/1:入力した内容を消失するのを防止する/2:エスケープキーが押されたら、フォームを消去するか確認する}
$::use_escapeoff = 2;

# ja:フォームの自動バックアップ#nocompact
# @{0:バックアップする/1:バックアップしない}#nocompact
$::use_formbackup = 1;#nocompact

# ja:掲示板等の名前の保存（setting.inc.cgi有効時のみ）
# @{0:保存しない/1:デフォルトで有効にする}
$::setting_savename = 0;

######################################################################
# ja:自動リンク
######################################################################

# ja:WikiNameの自動リンク
# @{0:自動リンクする/1:自動リンクしない}
$::nowikiname = 0;

# ja:URLの自動リンク
# @{1:自動リンクする/0:自動リンクしない}
$::autourllink = 1;

# ja:メールアドレスの自動リンク
# @{1:自動リンクする/0:自動リンクしない}
$::automaillink = 1;

# ja:リンク先のロボットのフォロー#nocompact
# @{0:フォローしない/1:自サイトのみフォロー/2:全てフォローする}#nocompact
$::follow = 2;#nocompact
#nocompact
# ja:article等に書かれたURLのフォロー#nocompact
# @{0:フォローしない/1:デフォルト/2:全てフォローする}#nocompact
$::postfollow = 0;#nocompact

# ja:file://のスキーマを有効にする（イントラネット向け）
# @{0:通常/1:有効にする}
$::useFileScheme = 0;

# ja:イントラネット向けにドットなしのメールアドレスを有効にする
# @{0:通常/1:有効にする}
$::IntraMailAddr = 0;

# ja:URLに画像のものを指定されたら、無条件にimgタグでリンクをする。
# @{0:リンクのみする/1:画像を表示する}
$::use_autoimg = 1;

# ja:記載できないURL（正規表現）
# @{(\/\/|\.exe|\.scr|\.bat|\.pif|\.com|\.jpe?g|\.gif|\.png)$';}
$::ignoreurl = '(\/\/|\.exe|\.scr|\.bat|\.pif|\.com|\.jpe?g|\.gif|\.png)$';

######################################################################
# ja:クッキー
######################################################################
# ja:保存cookieの有効期限（3ヶ月）
# @{7776000}
$::cookie_expire = 3*30*86400;

# ja:保存cookiのリフレッシュ間隔（1日）
# @{86400}
$::cookie_refresh = 86400;

######################################################################
# ja:アクセスカウンター
######################################################################

# ja:アクセスカウンターの種類
# @ja{1:クラシックカウンター（今日と昨日のみ保存）/2:拡張カウンター/3:高速カウンター（１アクセスあるごとに１バイト消費します）}
$::CounterVersion = 1;

# ja:保存する日数（最大1000日）
# @{365}
$::CounterDates = 365;

# ja:カウンターのリモートホストをチェックする
# @{1:リモートホストをチェックする/0:リロードでも無条件でカウントする}
$::CounterHostCheck = 1;

######################################################################
# ja:アクセスカウンター
######################################################################

# ja:添付の使用
# @ja{0:使用しない/1:使用する/2:認証付で使用する/3:削除のみ認証付で使用する}
$::file_uploads = 2;

# ja:アップロードファイルの最大容量
# @{5000000}
$::max_filesize = 5000000;

# ja:添付ファイルの簡易内容監査を行なう
# @{1:行なう/0:行わない}
$::AttachFileCheck = 0;

# ja:添付ファイルのダウンロードカウントを行なう
# @{0:カウントを行なわない/1:カウントを行なう/2:ダウンロード表示画面で表示もする}
$::AttachCounter = 0;

######################################################################
# ja:ヘルプ
######################################################################

# ja:ヘルプをプラグインで実行する
# @{1:プラグインから実行する/0:ページとして表示する}
$::use_HelpPlugin = 1;	# ヘルプをプラグインで実行する（ナビゲータが変化します）

# ヘルプページを編集する場合は
# ?cmd = adminedit&mypage = %a5%d8%a5%eb%a5%d7 で
# UTF-8版であれば
# ?cmd = adminedit&mypage = ?%e3%83%98%e3%83%ab%e3%83%97 で

# ja:ヘルプのリンクを表示しない
# @{0:表示する/1:表示しない}
$::no_HelpLink = 0;

######################################################################
# ja:検索
######################################################################
# ja:あいまい検索の利用
# @ja{0:通常検索/1:日本語簡易あいまい検索を使用する}
$::use_FuzzySearch = 1;

# ja:検索時、強調表示をする#nocompact
# @ja{0:何もしない/1:強調表示をする}#nocompact
$::use_Highlight = 1;

######################################################################
# ja:サイトマップ
######################################################################

# ja:サイトマップの使用
# @ja{0:リストのみ/1:リスト、サイトマップの両方を利用する}
$::use_Sitemap = 0;

######################################################################
# ja:XMLサイトマップ
######################################################################
# ja:検索エンジンに送信するサイトマップの使用
# @ja{0:使用しない/1:使用する}
$::use_Sitemaps = 1;
# ?cmd = sitemapsのXML

######################################################################
# ja:ナビゲータの配列
######################################################################
# ja:ナビゲートの表示
# @ja{0:表示する/1:表示しない}
$::disable_navigator = 0;

# ja:ナビゲータの表示順番
# @ja{0:リロード〜/1:トップ〜}
$::naviindex = 1;

######################################################################
# ja:自動リカバリー
######################################################################

# @ja{0:OFF/1:ON}
$::auto_recovery = 1;

######################################################################
# ja:ページ名、表示
######################################################################

# ja:ページ名の下のtopicpath（パンくずリスト）の使用
# @ja{0:使用しない/1:使用する}
$::useTopicPath = 1;

# ja:階層指定用セパレータ
# @{/}
$::separator = '/';

# ja:ドット
# @{.}
$::dot = '.';

# ja:下の画像ツールバー
# @ja{0:表示しない/1:RSS等のみ表示/2:すべて表示する}
$::toolbar = 2;

######################################################################
# ja:setting.inc.pl/cgi
######################################################################
# ja:閲覧者環境設定機能を使う
# @{0:使用しない/1:使用する}
$::use_Setting = 1;

# ja:スキンセレクタを使う
# @{0:使用しない/1:使用する}
$::use_SkinSel = 1;

######################################################################
# ja:更新
######################################################################

# ja:更新履歴の最大保存数
# @{50}
$::maxrecent = 50;

# ja:一覧・更新一覧に含めないページ名(正規表現で)
# @{(^\:|$::separator\:)}
$::non_list = qq((^\:|$::separator\:));
#$::non_list = qq((^\:));
#$::non_list = qq((^\:|$::MenuBar\$)); # example of MenuBar

# ja:添付ファイルの全ページ一覧を、non_listで指定したページを除く
# @ja{0:除外しない/1:除外する}
$::attach_nonlist = 1;

######################################################################
# ja:gzip圧縮送信
######################################################################

# ja:gzipパスの指定
# @ja{:自動認識/nouse:gzipを使用しない/\/bin\/gzip -1:\/bin\/gzip -1 (高速)/\/usr\/bin\/gzip -1 -f:\/usr\/bin\/gzip -1 -f (高速)/\/usr\/local\/bin\/pigz -1 -f:\/usr\/local\/bin\/pigz -1 -f (非常に高速ですが、非標準ツールです)/\/bin\/gzip -9:\/bin\/gzip -9 (最高圧縮)/\/usr\/bin\/gzip -9 -f:\/usr\/bin\/gzip -9 -f (最高圧縮)/zlib:zlib(perl標準ライブラリですが、低速です)}
$::gzip_path = '';

#$::gzip_path = '/bin/gzip -1';			# fast
#$::gzip_path = '/usr/bin/gzip -1 -f';	# fast
#$::gzip_path = '/usr/local/bin/pigz -1 -f';	# very fast
#$::gzip_path = '/bin/gzip -9';			# max compress
#$::gzip_path = '/usr/bin/gzip -9 -f';	# max compress

# gzipを使用しない場合
#$::gzip_path = 'nouse';				# 使用しない場合
										# 動かない場合コメントアウト

######################################################################
# ja:メール通知の設定
######################################################################

# ja:Wiki更新通知を管理人に知らせる
# @{0:何もしない/1:知らせる}
$::sendmail_to_admin = 0;

# ja:Wiki更新通知を知らせる追加メールアドレス
# @{$::modifier_mail\n}
$::addmodifier_mail = '';

# ja:更新通知のメールのヘッド
# @{[Wiki]}
$::mail_head = "[Wiki]";

# do not change
$::mail_head_plus = "";

# ja:フォームメールのヘッド
# @{Form}
$::mail_head{form} = "Form";

# ja:新規作成のヘッド
# @{New}
$::mail_head{new} = "New";

# ja:更新のヘッド
# @{Modify}
$::mail_head{modify} = "Modify";

# ja:削除のヘッド
# @{Delete}
$::mail_head{delete} = "Delete";

# ja:pingのヘッド
# @{Ping}
$::mail_head{ping} = "Ping";

# ja:スパムのヘッド
# @{Spam}
$::mail_head{spam} = "Spam";

# ja:拒否のヘッド
# @{Deny}
$::mail_head{deny} = "Deny";

# ja:添付ファイルアップロードのヘッド
# @{AttachUpload}
$::mail_head{attachupload} = "AttachUpload";

# ja:添付ファイル削除のヘッド
# @{AttachDelete}
$::mail_head{attachdelete} = "AttachDelete";

# ja:投稿通知メールのヘッド
# @{Post}
$::mail_head{post} = "Post";

# ja:投票通知メールのヘッド
# @{Vote}
$::mail_head{vote} = "Vote";

# ja:設定ファイル変更通知のヘッド
# @{SetupEdit}
$::mail_head{setupedit} = "SetupEdit";

# ja:設定ファイル削除通知のヘッド
# @{SetupDelete}
$::mail_head{setupdel} = "SetupDelete";

# ja:トラックバック通知のヘッド
# @{TrackBack}
$::mail_head{trackback} = "TrackBack";

# UTF-8メールの送信  MIME::Base64が必要
# @ja{0:ISO-2022-JPで送信する/1:UTF8で送信する MIME::Base64が必要}
$::send_utf8_mail = 0;

# ja:sendmailパスの指定
# @{/usr/sbin/sendmail -t\n/usr/bin/sendmail -t\n/usr/lib/sendmail -t\n/var/qmail/bin/sendmail -t}
$::modifier_sendmail = <<EOM;
/usr/sbin/sendmail -t
/usr/bin/sendmail -t
/usr/lib/sendmail -t
/var/qmail/bin/sendmail -t
EOM

# ja:上級者向け：PGP暗号化の為のプログラムのパスとオプション
# @{}
$::modifier_pgp = "";
#$::modifier_pgp = "/usr/local/bin/gpg --always-trust";

# ja:上級者向け：PGP暗号化のメール送信先（氏名またはメールアドレス）
# @{}
$::modifier_pgp_name = "";

# ja:クラッシュ通知を管理人に知らせる
# @{0:通知しない/1:通知する}
$::sendmail_crash_to_admin = 0;	# compact
$::sendmail_crash_to_admin = 0;	# release
$::sendmail_crash_to_admin = 1;	# devel

# ja:作者にクラッシュ通知を送信する
# @{0:通知しない/1:通知する}
$::sendmail_crash_to_author = 1;	# compact
$::sendmail_crash_to_author = 1;	# release
$::sendmail_crash_to_author = 1;	# devel

# ja:作者の送信先（変更しないで下さい。ただし予告なく変更あり）
# @{pyukiwiki-crash@daiba.cx}
$::sendmail_crash_to_author_mail = 'pyukiwiki-crash@daiba.cx';

######################################################################
# P3Pのコンパクトポリシー http://fs.pics.enc.or.jp/p3pwiz/p3p_ja.html
# 必要であれば /w3c以下ディレクトリにも適切にファイルを設置し、有効にします
######################################################################
#$::P3P = "NON DSP COR CURa ADMa DEVa IVAa IVDa OUR SAMa PUBa IND ONL UNI COM NAV INT CNT STA";

######################################################################
# ナビゲータにリンクを追加するサンプル
######################################################################
#push(@::addnavi,"link:help");		# helpの前に追加
##push(@::addnavi,"link::help");	# helpの後ろに追加
#$::navi{"link_title"} = "リンク集";
#$::navi{"link_url"} = "$::script?%a5%ea%a5%f3%a5%af";	# page of 'リンク'
#$::navi{"link_name"} = "リンク集";
#$::navi{"link_type"} = "page";
#$::navi{"link_height"} = 14;
#$::navi{"link_width"} = 16;

######################################################################
# データベースエンジン
######################################################################
$::modifier_dbtype = 'Nana::YukiWikiDB';
#$::modifier_dbtype = 'Nana::GDBM';
#$::modifier_dbtype = 'Nana::SQLite';
# this is obsoleted
#$::modifier_dbtype = 'Yuki::YukiWikiDB';

######################################################################
# ja:スパムフィルター
######################################################################

# ja:スパムフィルターを有効にする
# @{0:無効/1:有効}
$::filter_flg = 1;
$::chk_uri_count = 10;				# 旧オプション

# ja:Wiki編集画面でのURL制限個数
# @{10}
$::chk_wiki_uri_count = 10;	

# ja:掲示板等でのURL制限個数
# @{1}
$::chk_article_uri_count = 1;

# ja:掲示板等でのメールアドレスの制限個数
# @{1}
$::chk_article_mail_count = 1;

# ja:編集画面に日本語が存在しない場合、スパムとみなす
# @{0}
$::chk_write_jp_only = 0;

# ja:掲示板、コメント等に日本語が一時も入っていないと、スパムとみなす
# @{1}
$::chk_jp_only = $::lang eq "ja" ? 1 : 0;

# ja:ログファイル
# @{$::cache_dir/deny-log.deny}
$::deny_log = "$::cache_dir/deny-log.deny";

# ja:フィルターフラグの付いているときのログ出力先
# @{$::cache_dir/black-lst.deny}
$::black_log = "$::cache_dir/black-lst.deny";

# ja:拒否リスト
# @{$::cache_dir/denylist.deny}
$::deny_list = "$::cache_dir/denylist.deny";

# ja:自動的に拒否リストに登録される回数
# @{3}
$::auto_add_deny = 3;

# ja:拒否の有効期限（1ヶ月）
# @{2678400}
$::deny_expire = 24*60*60*31;

# 書き込み禁止キーワード
$::ngwords="ngwords.ini.cgi" if($::ngwords eq "");
require $::ngwords if(-f $::ngwords);
require $::ngwords_file if(-f $::ngwords_file);

# ja:書き込み禁止ワードを有効にする
# @{0}
$::use_disablewords = 0;

######################################################################
# ja:タイムゾーン設定
######################################################################

# ja:タイムゾーン(GMTとの時間差）
# @{:自動取得/-12:GMT-12\:00 エニウェトク、クエジェリン/-11:GMT-11\:00 ミッドウェー島、サモア/-10:GMT-10\:00 ハワイ/-9:GMT-09\:00 アラスカ/-8:GMT-08\:00 太平洋標準時（米国、カナダ）、ティファナ/-7:GMT-07\:00 アリゾナ/-7:GMT-07\:00 山地標準時（米国、カナダ）/-6:GMT-06\:00 サスカチュワン/-6:GMT-06\:00 メキシコシティ/-6:GMT-06\:00 中央アメリカ/-6:GMT-06\:00 中部標準時（米国、カナダ）/-5:GMT-05\:00 インディアナ東部/-5:GMT-05\:00 ボゴタ、リマ、キト/-5:GMT-05\:00 東部標準時（米国、カナダ）/-4:GMT-04\:00 カラカス、ラパス/-4:GMT-04\:00 サンティアゴ/-4:GMT-04\:00 大西洋標準時 (カナダ)/-3.5:GMT-03\:30 ニューファンドランド/-3:GMT-03\:00 グリーンランド/-3:GMT-03\:30 ブエノスアイレス、ジョージタウン/-3:GMT-03\:00 ブラジリア/-2:GMT-02\:00 中央大西洋/-1:GMT-01\:00 アゾレス諸島/-1:GMT-01\:00 ガーボベルデ諸島/0:GMT+00\:00 カサブランカ、モンロビア/0:GMT+00\:00 グリニッジ標準時/0:GMT+00\:00 ダブリン、エジンバラ、リスボン、ロンドン/1:GMT+01\:00 アムステルダム、ベルリン、ベルン、ローマ、ストックホルム/1:GMT+01\:00 サラエボ、スコピエ、ソフィア、ビリニュス、ワルシャワ、ザグレブ/1:GMT+01\:00 ブリュッセル、マドリード、コペンハーゲン、パリ/1:GMT+01\:00 ベオグラード、プラチスラバ、ブダペスト、リュブリャナ、プラハ/1:GMT+01\:00 西中央アフリカ/2:GMT+02\:00 アテネ、イスタンブール、ミンスク/2:GMT+02\:00 エルサレム/2:GMT+02\:00 カイロ/2:GMT+02\:00 ハラーレ、プレトリア/2:GMT+02\:00 ブカレスト/2:GMT+02\:00 ヘルシンキ、リガ、タリン/3:GMT+03\:00 クウェート、リヤド/3:GMT+03\:00 ナイロビ/3:GMT+03\:00 バクダット/3:GMT+03\:00 モスクワ、ボルゴグラード、サンクトペテルブルグ/3.5:GMT+03\:30 テヘラン/4:GMT+04\:00 アブダビ、マスカット/4:GMT+04\:00 バグ、トビリシ、エレバン/4.5:GMT+04\:30 カブール/5:GMT+05\:00 イスラマバード、カラチ、タシケント/5:GMT+05\:00 エカテリンバーグ/5.5:GMT+05\:30 カルカッタ、チェンナイ、ムンバイ、ニューデリー/5.75:GMT+05\:45 カトマンズ/6:GMT+06\:00 アスタナ、ダッカ/6:GMT+06\:00 アルマティ、ノボシビルスク /6:GMT+06\:00 スリ、ジャヤワルダナプラ/6.5:GMT+06\:30 ラングール/7:GMT+07\:00 クラスノヤルスク/7:GMT+07\:00 バンコク、ハノイ、ジャカルタ/8:GMT+08\:00 イルクーツク、ウランバートル/8:GMT+08\:00 クアラルンプール、シンガポール/8:GMT+08\:00 パース/8:GMT+08\:00 台北/8:GMT+08\:00 北京、重慶、香港、ウルムチ/9:GMT+09\:00 ソウル/9:GMT+09\:00 ヤクーツク/9:GMT+09\:00大阪、札幌、東京/9.5:GMT+09\:30 アデレード/9.5:GMT+09\:30 ダーウィン/10:GMT+10\:00 ウラジオストク/10:GMT+10\:00 キャンベラ、メルボルン、シドニー/10:GMT+10\:00 グアム、ポートモレスビー/10:GMT+10\:00 ブリスベン/10:GMT+10\:00 ホバート/11:GMT+11\:00 マガダン、ソロモン諸島、ニューカレドニア/12:GMT+12\:00 オークランド、ウェリントン/12:GMT+12\:00 フィジー、カムチャッカ、マーシャル諸島/13:GMT+13\:00 ヌクアロファ}
$::TZ = '';
#$::TZ = '9';		# こちらのが処理はやいかも？（日本用）


######################################################################
# スキンの設定
######################################################################
$::disable_wiki_title = 0;
$::disable_wiki_page_title = 0;


######################################################################
1;

__END__
=head1 NAME

pyukiwiki.ini.cgi - This is pyukiwiki setting file

=head1 DESCRIPTION

This file is a configuration file of PyukiWiki.
Please carry out a suitable setup before setting up CGI.

=cut
