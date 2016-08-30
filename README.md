# Logly Lift Mobile SDK (作成中)
[![CocoaPods](https://img.shields.io/cocoapods/v/LoglyLift.svg?maxAge=2592000)]()  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 概要
* iOS SDK: https://github.com/logly/LiftSDK-iOS
* Android SDK: https://github.com/logly/LiftSDK-Android

このLogly Lift Mobile SDKは、iOS & Androidのモバイル・アプリケーション向けに、Loglyのliftレコメンデーション・システムを使用するためのSDKです。

liftシステムではページに対するレコメンドを行うので、モバイル・アプリ内で擬似的なページを作り、その内容に対するレコメンド結果を取得します。

このSDKでliftレコメンデーション・システムを使用するためには、以下のように行います。（注：logly Lift システムの登録ユーザーである必要があります。）

１. ページデータをliftシステムへ登録
　liftシステムでは、あらかじめページデータをシステムへ登録し、そのページデータに基づいたレコメンド（中間）結果をシステム上で計算します。注：これはアプリ外での作業です（参照：「ページデータの登録」）

２. アプリへのSDK組み込み
　SDK内のシンプルなwidgetを使って簡単に作成する方法と、SDKからAPIを呼び出してその結果を独自に処理・表示する方法があります

３. アプリからliftシステムへアクセスしてレコメンド結果を取得
　SDKのwidget（もしくはAPI）を使用して、ページに対するレコメンド結果をliftシステムから取得します

ページの識別にはMDL（Mobile Deep Link)をキーにしたURIを使用してページを識別します。これは、擬似的なページ識別用のリンクで、アプリケーションはこのリンクを開けるようにしておく必要があります。もちろん、擬似的ではない、実際のページがweb上にある場合には、そのURLを使用することも可能です。(その場合にはブラウザ等でリンクを開く事も可能です。)

## 必要システム・ヴァージョン
* iOS: 7 以上
* Android: SDK 15 (Android 4.0.3)以上

## インストール: iOS
iOS版のSDKのライブラリをインストールするには、cocoapodsを使います。https://cocoapods.org/
組み込むアプリケーションのPodfileに、以下の行を追加してください。

```
pod “LoglyLift”
```
そしてコンソールから以下のコマンドを実行してください
```sh
pod install
```

## インストール: Android
Android版のSDKライブラリをインストールするには、jCenterのmavenリポジトリを使います。https://jcenter.bintray.com/
組み込むアプリケーションのbuild.gradleのdependenciesセクションに以下を追加してください。

```
dependencies {
    compile 'jp.co.logly:lift-sdk:0.9.3'
}
```

もしAndroidManifestにネットアクセスの設定がない場合には、app/AndroidManifest.xmlに以下を追加

```xml
<uses-permission android:name="android.permission.INTERNET"></uses-permission>
```

## SDK: シンプル widget　＆　サンプルアプリ
このモバイルSDKには、iOS, Android それぞれに、シンプルなレコメンド表示用widget(View)が付属しています。このwidgetは内部でAPIを呼び出しその結果をwidget上に表示します。そのwidgetを使用したサンプルアプリがSDKに入っています。SDKユーザーはこのサンプルアプリを参考に、組み込みを行うことができます。

### シンプル widget : iOS
1. storybord / xib (あるいはコード）等で、UIViewのサブクラスとしてLGLiftWidgetを画面に配置
2. その画面のViewController#viewDidLoad()などから、そのLGLiftWidgetにASyncリクエストをrequestByURL()でスタートさせる

#### objective-c

```objective-c
[self.liftWidget requestByURL:detail[@"url"]
                     adspotId:@(3777016)
                     widgetId:@(1684)
                          ref:@"http://blog.logly.co.jp/"];
```

#### swift

```swift
liftWidget.requestByURL( detail["url"],
                         adspotId:NSNumber(longLong: 3777016),
                         widgetId:NSNumber(int: 1684),
                         ref:"http://blog.logly.co.jp/")
```
その際、そのページのURL(MDL)と、adspotID, widgetID, refが必要。

### シンプル widget : Android
1. layoutリソースや、コード上で、jp.co.logly.Lift.WidgetViewを画面上に配置
2. その画面のActivity/FragmentのonCreateView()などから、WidgetViewにAsyncリクエストをrequestByURL()でスタートさせる。

```java
            liftWidget.requestByURL(mItem.url, new BigDecimal(3777016), new BigDecimal(1684), "http://blog.logly.co.jp/", new BigDecimal(1));
```
その際、そのページのURL(MDL)と、adspotID, widgetID, refが必要。


### サンプルアプリの実行方法
#### iOS (Swift or Objective-C)

```
cd examples/LiftSample-{swift,objc}
pod install
open LiftSample-{swift,objc}.xcworkspace
```
Xcodeが開くので、Run.

#### Android

Android StudioでSDKのディレクトリを開く
Run

## SDK: API client
SDKのAPI clientを使用して直接lift APIへアクセスし、レコメンド結果を取得することで、独自のビューなどで表示することなどもできます。
シンプルwidgetの内部でもこのAPI clientを使用しています。SDKのソースコードも公開していますので、widgetのコードも参考にしてください。
API clientの仕様については、別ファイルのAPIドキュメント(API.html)を参照してください。

## ページデータの登録
liftシステムでは、あらかじめページデータをシステムへ登録し、そのページデータに基づいたレコメンド（中間）結果をシステム上で計算します。
ページデータの登録方法は、Amazon AWS S3へ登録用データのJSONファイルをアップロードすることで、自動的に処理されます。

注：アップロードしたJSONファイルはすぐに処理され、エラーなく登録された場合には、すぐに消去されます。アップロードした直後にファイルがなくなっていた場合には、正常に処理されたと考えられます。逆にファイルが残っていた場合には、何らかのエラーが起こったと考えられます。その際にはアップロードされたデータは全く、登録されません。修正したファイルをアップロードするか、Loglyのサポートまでご連絡ください。

前準備：Amazon AWSのアカウントを持っている必要があります。そのアカウントをLogly側へお知らせください。Logly側からはアップロードすべきにbucket名とフォルダ名、そしてユーザーIDをおしらせします。

### JSONファイル・フォーマット
ファイル名：“任意の名前.json”

サンプル：

```json
{
	"user": "user1",
	"items": [{
		"url": "http://www.excite.co.jp/News/fashion/20151110/Fashion_headline_12904.html",
		"title": "1-南青山の花屋「Le Vesuve」店主・高橋郁代の最期1年間を見守った写真展",
		"summary": "東京・南青山の花屋ル・ベスベ（Le Vesuve）の店主である高橋郁代の眼差しを追った写真展「Regard Intense」が、11月10日から29日まで東京・港区のGallery 916 smallにて行われている。1955年に静岡で生まれた高橋郁代は、“毎日の暮らしに花を”という平凡な言葉を、非凡な感性で実行していたフラワーデザイナー。1998年に東京・南青山に、現・代表の松岡龍守と花屋ル・ベスベをオープン後、フラワーデザイナーとして独立。その飾らない人柄と独自のフラワースタイルで多くの人々を魅了し",
		"text": "東京・南青山の花屋ル・ベスベ（Le Vesuve）の店主である高橋郁代の眼差しを追った写真展「Regard Intense」が、11月10日から29日まで東京・港区のGallery 916 smallにて行われている。1955年に静岡で生まれた高橋郁代は、“毎日の暮らしに花を”という平凡な言葉を、非凡な感性で実行していたフラワーデザイナー。1998年に東京・南青山に、現・代表の松岡龍守と花屋ル・ベスベをオープン後、フラワーデザイナーとして独立。その飾らない人柄と独自のフラワースタイルで多くの人々を魅了していた。写真家たちとの18年に渡るダイアリープロジェクトを行っていたが、最後のダイアリーとなった『Regard intense- Le Vesuve Diary 2015』を残し、14年秋に急逝した。同展では、20点の写真作品とともに、ムービー作品『Variations I,II,III,IV,V& Aria』を出展。花とともに生きた高橋の特別な日常を体感出来る写真展となっている。また、11月28日、29日には、写真や動画で人々の心を捉えるために必要な思考や準備、そのプロセスなどを学ぶことが出来るワークショップを開催。1日目は、レクチャーと個別ポートフォリオの鑑賞、評価プロセスの共有を行い、2日目で、参加者が実際に撮影した作品を全員で鑑賞し、評価する。実際に花を撮影しながら、日常の時間を撮ることの意味が考えられる機会となっている。…",
		"image_size": "200x200",
		"image_url": "http://s.eximg.jp/exnews/www/img/apple-touch-icon_200.png",
		"pubdate": "2015-11-10T02:00:00Z"
	}]
}
```
内容(topレベル)：
* user : Loglyからあらかじめお知らせしたユーザーIDを入れてください。
* items : ページデーターの配列
内容(ページデータ):
* url : (required) キーとなるMDL。実際にweb上にページがある場合にはURLでも良い。
* title : (required) タイトル #MEMO: max何文字？
* summary : (optional) サマリー #MEMO: max何文字？titleとの違いは？
* text : (required) 本文テキスト
* image_size : (optional) サムネイル・イメージのサイズ。例：100x200
* image_url : (optional) サムネイル・イメージのURL。iOS9でのATSに抵触する可能性がある場合にはHTTPS上にイメージを置いてください。
* pubdate : (optional)ページ投稿日時。ISO 8601 フォーマット。例："2015-11-10T03:00:00Z"

### アップデート＆削除方法
登録と同様の方法で、同じページのアップデートや削除も行えます。
アップデートの時には、同じMDLを”url”フィールドに使い、新しい内容の他のデータを記述すればその内容にアップデートされます。
削除の場合には、同じMDLを”url”フィールドに使い、他のすべての項目に空データを入れておけば削除されます。（現状、判定にはtitleとtextを使っています。両方が空の場合に削除されます）

---
