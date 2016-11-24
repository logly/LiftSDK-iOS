# logly lift Mobile SDK
[![CocoaPods](https://img.shields.io/cocoapods/v/LoglyLift.svg?maxAge=2592000)](https://cocoapods.org/?q=loglylift)  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 概要
* iOS SDK: https://github.com/logly/LiftSDK-iOS
* Android SDK: https://github.com/logly/LiftSDK-Android

このlogly lift Mobile SDKは、iOS & Androidのモバイル・アプリケーション向けに、loglyのliftレコメンデーション・システムを使用するためのSDKです。

liftシステムではページに対するレコメンドを行うので、モバイル・アプリ内で擬似的なページを作り、その内容に対するレコメンド結果を取得します。

このSDKでliftレコメンデーション・システムを使用するためには、以下のように行います。（注：logly lift システムの登録ユーザーである必要があります。）

１. ページデータをliftシステムへ登録
　liftシステムでは、あらかじめページデータをシステムへ登録する必要があります。これにはAWS S3にjsonファイルをアップロードすることで行います。注：これはアプリ外での作業です（参照：「ページデータの登録」）

２. アプリへのSDK組み込み
　SDK内のシンプルなwidgetを使って簡単に作成する方法と、SDKからAPIを呼び出してその結果を独自に処理・表示する方法があります

３. アプリからliftシステムへアクセスしてレコメンド結果を取得
　SDKのwidget（もしくはAPI）を使用して、ページに対するレコメンド結果をliftシステムから取得します

ページの識別にはMDL（Mobile Deep Link)をキーにしたURIを使用してページを識別します。これは、擬似的なページ識別用のリンクで、アプリケーションはこのリンクを開けるようにしておく必要があります。もちろん、擬似的ではない、実際のページがweb上にある場合には、そのURLを使用することも可能です。(その場合にはブラウザ等でリンクを開く事も可能です。)

---

## 必要システム・ヴァージョン
* iOS: 8.1 以上
* Android: SDK 15 (Android 4.0.3)以上

## インストール: iOS
iOS版のSDKのライブラリをインストールするには、cocoapodsを使います。https://cocoapods.org/
組み込むアプリケーションのPodfileに、以下の`use_frameworks!`と`pod “LoglyLift”`の行を追加してください。

```
use_frameworks!
...
target ...
  pod “LoglyLift”
```
そしてコンソールから以下のコマンドを実行してください

```shell-session
pod install
```

## インストール: Android
Android版のSDKライブラリをインストールするには、jCenterのmavenリポジトリを使います。https://jcenter.bintray.com/
組み込むアプリケーションのbuild.gradleのdependenciesセクションに以下を追加してください。

```
dependencies {
    compile 'jp.co.logly:lift-sdk:'
}
```

もしAndroidManifestにネットアクセスの設定がない場合には、app/AndroidManifest.xmlに以下を追加

```xml
<uses-permission android:name="android.permission.INTERNET"></uses-permission>
```

---

## SDKの内容:
このモバイルSDKには、iOS, Android それぞれに、シンプルなレコメンド表示用widget(View)が付属しています。このwidgetは内部でAPIを呼び出しその結果をwidget上に表示し、（正しい計測に必要な）ビーコン＆トラキングURLにアクセスします。そのwidgetを使用したサンプルアプリがSDKに入っています。SDKユーザーはこのサンプルアプリを参考に、組み込みを行うことができます。その他、SDKにはLiftサービスに低レベルアクセスをするためのAPI-clientも入っています。独自のwidgetを作成する場合にはこれを使って作ることができます。

### ○　シンプル widgetの使い方 : iOS
1. storybord / xib (あるいはコード）等で、UIViewのサブクラスとしてLGLiftWidgetを画面に配置
2. その画面のViewController#viewDidLoad()などから、そのLGLiftWidgetにリクエストをrequestByURL()でスタートさせます。実際のアクセスは別スレッド等で行われ、このメソッドはすぐに戻ります。
3. レコメンドの表示数はwidgetの大きさで決まります。一つのレコメンドセルの大きさは300x72（マージン込みで302x74。ヘッダ・フッタの高さは34）なので、それを単位に変更すると良いでしょう。（注：最大数は、Liftコンソールの側でも設定できます）

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

### ○　シンプル widgetの使い方 : Android
1. layoutリソースや、コード上で、jp.co.logly.Lift.WidgetViewを画面上に配置
2. その画面のActivity/FragmentのonCreateView()などから、WidgetViewにリクエストをrequestByURL()でスタートさせます。実際のアクセスは別スレッド等で行われ、このメソッドはすぐに戻ります。
3. レコメンドの表示数はwidgetの大きさで決まります。一つのレコメンドセルの大きさは300x72なので、それを単位に変更すると良いでしょう。（注：最大数は、Liftコンソールの側でも設定できます）

```java
liftWidget.requestByURL(mItem.url, 3777016, 1684, "http://blog.logly.co.jp/", 1);
```

### requestByURLのパラメータ

* url: キーとなる、ページURL(MDL)
* adspotID: Loglyが発行したadspotID
* widgetID: Loglyが発行したwidgetID
* ref: リファラーURL(通常、モバイル版では必要なし)

### Clickコールバック : iOS

* swift

```swift
liftWidget.onWigetItemClickCallback = {(widget, url, item) -> Bool in
    // do something useful.
    return true; // we handled click. do not need to open in browser.
}
```

* Objective-C

```objc
self.liftWidget.onWigetItemClickCallback = ^(LGLiftWidget *widget, NSString *url, LGInlineResponse200Items *item) {
    // do something useful.
    return YES; // we handled click. do not need to open in browser.
};
```
このonWigetItemClickCallbackにコールバックを登録しておくと、レコメンドのアイテムがクリックされた時に、このコールバックが呼ばれます。このコールバック関数の戻り値としてtrueを返すと、widgetはその先の処理をやめます。（ブラウザでURLをオープンしない）


### Clickコールバック : Android

```java
liftWidget.mOnWigetItemClickListener = new WidgetView.OnWigetItemClickListener() {
                @Override
                public boolean onItemClick(WidgetView widget, String url, InlineResponse200Items item) {
                    /* do something useful. */
                    return true; /* we handled click. do not need to open in browser. */
                }
            };
```
このmOnWigetItemClickListenerにコールバックのListnerを登録しておくと、レコメンドのアイテムがクリックされた時に、このListnerが呼ばれます。このListnerの戻り値としてtrueを返すと、widgetはその先の処理をやめます。（ブラウザでURLをオープンしない）


### ○　サンプルアプリについて
#### iOS (Swift or Objective-C)版サンプルアプリの実行方法

```
cd examples/LiftSample-{swift,objc}
pod install
open LiftSample-{swift,objc}.xcworkspace
```
* Xcodeが開くので、Run.

#### Android版サンプルアプリの実行方法

* Android StudioでSDKのディレクトリを開く
* Run

### ○　SDK: API client
SDKのAPI clientを使用して直接lift APIへアクセスし、レコメンド結果を取得することで、独自のビューなどで表示することなどもできます。
シンプルwidgetの内部でもこのAPI clientを使用しています。SDKのソースコードも公開していますので、widgetのコードも参考にしてください。
API clientの仕様については、別ファイルのAPIドキュメント[API.html](//:./API.html)を参照してください。

---

## ページデータの登録
liftシステムでは、あらかじめページデータをシステムへ登録し、そのページデータに基づいたレコメンド（中間）結果をシステム上で計算します。
ページデータの登録方法は、Amazon AWS S3へ登録用データのJSONファイルをアップロードすることで、自動的に処理されます。

注：アップロードしたJSONファイルはすぐに処理され、エラーなく登録された場合には、すぐに消去されます。アップロードした直後にファイルがなくなっていた場合には、正常に処理されたと考えられます。逆にファイルが残っていた場合には、何らかのエラーが起こったと考えられます。その際にはアップロードされたデータは全く、登録されません。修正したファイルをアップロードするか、loglyのサポートまでご連絡ください。

前準備：loglyからあらかじめ、Amazon AWS S3にアクセスするときの認証情報、アップロードすべきbucket名とフォルダ名を取得してください。

### JSONファイル・フォーマット
ファイル名：“任意の名前.json”

サンプル：

```json
{
	"user": "user1",
	"items": [{
    "url": "logly-liftmobilesdk-sample://jp.co.logly.liftmobilesdk.sample/page/1",
    "title": "NYタイムズがソーシャル・インフルエンサーを活用、ブランドコンテンツのクリエイティブのためにマーケティング会社を買収",
    "text": "NYタイムズは今月上旬から、外部のメディアサイトのネイティブ広告を利用し始めています。同社は年初からネイティブ広告の提供を開始していたので、ネイティブ広告メディアとして今後の展開に注目していました。そのNYタイムズが立場を変えて、「広告主」として他サイトのネイティブ広告にコンテンツを出稿したのです。そこで、どのようなコンテンツを配信しているかを見ていきましょう。　NYタイムズが利用したネイティブ広告提供メディアは「Mashable」です。Mashableはインターネット分野をカバーしたオンライン・ニュー",
    "image_size": "128x128",
    "image_url": "http://blog.logly.co.jp/system/attachments/images/000/016/896/large_thumb/1.png",
    "pubdate": "2015-11-10T02:00:00Z"
	}]
}
```
内容(topレベル)：

* user : loglyからあらかじめお知らせしたユーザーIDを入れてください。
* items : ページデーターの配列

内容(ページデータ):

* url : (**required**) キーとなるMDL。実際にweb上にページがある場合にはURLでも良い。
* title : (**required**) タイトル
* summary : (optional) サマリー
* text : (**required**) 本文テキスト
* image_size : (**required**) サムネイル・イメージのサイズ。例：100x200
* image_url : (**required**) サムネイル・イメージのURL。iOS9でのATSに抵触する可能性がある場合にはHTTPS上にイメージを置いてください。
* pubdate : (optional)ページ投稿日時。ISO 8601 フォーマット。例："2015-11-10T03:00:00Z"

### アップデート＆削除方法
登録と同様の方法で、同じページのアップデートや削除も行えます。
アップデートの時には、同じMDLを”url”フィールドに使い、新しい内容の他のデータを記述すればその内容にアップデートされます。
削除の場合には、同じMDLを”url”フィールドに使い、他のすべての項目に空データを入れておけば削除されます。（現状、判定にはtitleとtextを使っています。両方が空の場合に削除されます）

