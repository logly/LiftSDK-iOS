//
//  MasterViewController.swift
//  LiftSample-swift
//
//  Created by Logly on H28/07/22.
//  Copyright © 平成28年 Logly. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = [[
        "url": "logly-liftmobilesdk-sample://jp.co.logly.liftmobilesdk.sample/page/1",
        "title": "NYタイムズがソーシャル・インフルエンサーを活用、ブランドコンテンツのクリエイティブのためにマーケティング会社を買収",
        "text": "NYタイムズは今月上旬から、外部のメディアサイトのネイティブ広告を利用し始めています。同社は年初からネイティブ広告の提供を開始していたので、ネイティブ広告メディアとして今後の展開に注目していました。そのNYタイムズが立場を変えて、「広告主」として他サイトのネイティブ広告にコンテンツを出稿したのです。そこで、どのようなコンテンツを配信しているかを見ていきましょう。　NYタイムズが利用したネイティブ広告提供メディアは「Mashable」です。Mashableはインターネット分野をカバーしたオンライン・ニュー"
        ],[
        "url": "logly-liftmobilesdk-sample://jp.co.logly.liftmobilesdk.sample/page/2",
        "title": "世界のネイティブ広告費、今後3年間で倍増し約600億ドルに、日本市場も同じく倍増",
        "text": "世界各国のネイティブ広告費はどれくらいの規模で、今後どれくらい成長するのでしょうか。大雑把でいいから知りたいなと思っていると、つい最近、ネイティブ広告プラットフォームの大手事業者Adyoulikeが、世界の主要国でのネイティブ広告費を予測していました。それによると、今年のネイティブ広告費は世界全体で309億ドルで、2018年には593.5億ドルに達すると予測しています。3年間でほぼ倍増ですから、すごい急成長ですね。身内のネイティブ広告プレイヤーの予測なので、少し割り引いて見たほうが良さそうですが、伸びるのは間違いないでしょう。ただ、ネイティブ広告の市場と言っても、どれがネイティブ広告であるかという、共通の線引きが固まっていないのが現状です。米国の業界団体IABもネイティブ広告の範囲を定義していますが、そこでは検索連動広告もネイティブ広告に含むとしています。でも広告市場調査では、一般に検索広告をネイティブ広告から外しています。このため、ネイティブ広告の市場規模があいまいなままになっていました。それでもこれまで、比較的よく引用されていたのがBusiness Insiderが出していた次の図（図1）のグラフです。昨年の半ばあたりにから販売している有料資料の中で使っているグラフで、資料の販促のために何度も繰り返し、このグラフを載せた記事をBusiness Insiderが発信していたので、ご覧になった方もおられるでしょう。"
    ],[
        "url": "logly-liftmobilesdk-sample://jp.co.logly.liftmobilesdk.sample/page/3",
        "title": "CNNが広告向けコンテンツスタジオを立ち上げ、ニュース価値のあるスポンサード動画を制作",
        "text": "メディアサイトでは、編集コンテンツだけではなくて広告でも、動画がやたらに増えてきました。フェイスブックのニュースフィードでも最近、動画コンテンツと頻繁に出会うようになってきました。ソーシャル系サイトでも、SnapchatやVineのような動画ベースのSNSが、若い人を中心に人気急上昇です。動画広告の市場も図1で示すように急伸しています。eMarketerの調査によりますと、2014年の動画広告費は米国で59億ドルと、前年比でプラス56%も急上昇しています。今年も前年比30.4%増の高成長を続け、78億ドル近くに達すると予測されています。ネイティブ広告のコンテンツでも、動画の採用が一段と盛んになっています。"
    ]]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let index = appDelegate.detailNumByOpenURL {
                controller.detailItem = objects[index - 1]
                appDelegate.detailNumByOpenURL = nil
            }
            
            if controller.detailItem == nil {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    controller.detailItem = objects[indexPath.row]
                }
            }
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

