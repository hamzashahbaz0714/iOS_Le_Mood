//
//  Constants.swift
//  Waldaa
//
//  Created by Malik Javed Iqbal on 07/12/2020.
//

import UIKit
import AVKit

let TO_NOTIF_NTOFICATION_RECIEVED = Notification.Name("utifUserDataChanged")
let TO_NOTIF_BOOKING_DATA_DID_CHANGE = Notification.Name("utifBookingDataChanged")
let TO_NOTIF_RATING_DATA_DID_CHANGE = Notification.Name("utifRatingDataChanged")

let placeHolderLeage = UIImage(named: "bet_icon")
let placeHolderArtistImage = UIImage(named: "2")
let menuArr = [["image": UIImage(named: "icon_user_profile")!,"name":"Profile"],["image": UIImage(named: "icon_transactions")!,"name":"Transactions"],["image": UIImage(named: "icon_settings")!,"name":"Settings"]]
let sportArray = [["name": "NBA-Basketball", "image": UIImage(named: "icon_basketball")!],["name": "MLB-Baseball", "image": UIImage(named: "icon_baseball")!],["name": "NFL-Football", "image": UIImage(named: "icon_football")!],["name": "FIFA-Soccer", "image": UIImage(named: "icon_football")!],["name": "NHL-Ice Hockey", "image": UIImage(named: "icon_hockey")!]]

typealias CompletionHandlerWithError = (_ success: Bool, _ error: Error?) -> ()
typealias CompletionHandler = (_ success: Bool) -> ()

var placeHolderImage = UIImage(named: "user_placeholder")

enum albumType: String {
    case newAlbum = "get-new-albums"
    case allAlbum = "get-all-albums"
    case weeklyCollection = "weekly-selection"

}

func getCurrentYear() -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return (formatter.string(from: Date()))
}

func getTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return (formatter.string(from: Date()))
}

func getCurrentDate() -> String{
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return (formatter.string(from: currentDateTime))
}
func getUniqueId(length: Int = 20) -> String {
   let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
   var randomString: String = ""

   for _ in 0..<length {
       let randomValue = arc4random_uniform(UInt32(base.count))
       randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
   }
   return randomString
}

func currentdateToaddOnday() -> String{
    let currentDate = Date()
    var dateComponent = DateComponents()
    dateComponent.day = 1
    let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
   return ((formatter.string(from: futureDate!)))
}

func getCurrentDateWithTime() -> String{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return (formatter.string(from: Date()))
}
func getCurrentTime() -> Int{
    let time = Date().timeIntervalSince1970
    print(Int(time))
    return Int(time)
}

struct Currency {

    private static let formatter: NumberFormatter = {
        let formatter         = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static func stringFrom(_ decimal: Decimal, currency: String? = nil) -> String {
        return self.formatter.string(from: decimal as NSDecimalNumber)!
    }
}

func getdatefromUNixTimes(time: Double) -> String{
    let unixTimeStamp = time
    let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
    let dateFormatt = DateFormatter()
    dateFormatt.dateFormat = "dd/MM/yyy hh:mm a"
    return dateFormatt.string(from: exactDate as Date)

}

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}


let languageArr = [["code":"ab","name":"Abkhaz","nativeName":"аҧсуа"],["code":"aa","name":"Afar","nativeName":"Afaraf"],["code":"af","name":"Afrikaans","nativeName":"Afrikaans"],["code":"ak","name":"Akan","nativeName":"Akan"],["code":"sq","name":"Albanian","nativeName":"Shqip"],["code":"am","name":"Amharic","nativeName":"አማርኛ"],["code":"ar","name":"Arabic","nativeName":"العربية"],["code":"an","name":"Aragonese","nativeName":"Aragonés"],["code":"hy","name":"Armenian","nativeName":"Հայերեն"],["code":"as","name":"Assamese","nativeName":"অসমীয়া"],["code":"av","name":"Avaric","nativeName":"авар мацӀ, магӀарул мацӀ"],["code":"ae","name":"Avestan","nativeName":"avesta"],["code":"ay","name":"Aymara","nativeName":"aymar aru"],["code":"az","name":"Azerbaijani","nativeName":"azərbaycan dili"],["code":"bm","name":"Bambara","nativeName":"bamanankan"],["code":"ba","name":"Bashkir","nativeName":"башҡорт теле"],["code":"eu","name":"Basque","nativeName":"euskara, euskera"],["code":"eu","name":"Basque","nativeName":"euskara, euskera"],["code":"be","name":"Belarusian","nativeName":"Беларуская"],["code":"bn","name":"Bengali","nativeName":"বাংলা"],["code":"bh","name":"Bihari","nativeName":"भोजपुरी"],["code":"bi","name":"Bislama","nativeName":"Bislama"],["code":"bs","name":"Bosnian","nativeName":"bosanski jezik"],["code":"br","name":"Breton","nativeName":"brezhoneg"],["code":"my","name":"Burmese","nativeName":"ဗမာစာ"],["code":"my","name":"Burmese","nativeName":"ဗမာစာ"],["code":"ca","name":"Catalan; Valencian","nativeName":"Català"],["code":"ch","name":"Chamorro","nativeName":"Chamoru"],["code":"ce","name":"Chechen","nativeName":"нохчийн мотт"],["code":"ny","name":"Chichewa; Chewa; Nyanja","nativeName":"chiCheŵa, chinyanja"],["code":"zh","name":"Chinese","nativeName":"中文 (Zhōngwén), 汉语, 漢語"],["code":"cv","name":"Chuvash","nativeName":"чӑваш чӗлхи"],["code":"kw","name":"Cornish","nativeName":"Kernewek"],["code":"co","name":"Corsican","nativeName":"corsu, lingua corsa"],["code":"cr","name":"Cree","nativeName":"ᓀᐦᐃᔭᐍᐏᐣ"],["code":"hr","name":"Croatian","nativeName":"hrvatski"],["code":"cs","name":"Czech","nativeName":"česky, čeština"],["code":"da","name":"Danish","nativeName":"dansk"],["code":"dv","name":"Divehi; Dhivehi; Maldivian;","nativeName":"ދިވެހި"],["code":"nl","name":"Dutch","nativeName":"Nederlands, Vlaams"],["code":"en","name":"English","nativeName":"English"],["code":"eo","name":"Esperanto","nativeName":"Esperanto"],["code":"et","name":"Estonian","nativeName":"eesti, eesti keel"],["code":"ee","name":"Ewe","nativeName":"Eʋegbe"],["code":"fo","name":"Faroese","nativeName":"føroyskt"],["code":"fj","name":"Fijian","nativeName":"vosa Vakaviti"],["code":"fi","name":"Finnish","nativeName":"suomi, suomen kieli"],["code":"fr","name":"French","nativeName":"français, langue française"],["code":"ff","name":"Fula; Fulah; Pulaar; Pular","nativeName":"Fulfulde, Pulaar, Pular"],["code":"gl","name":"Galician","nativeName":"Galego"],["code":"ka","name":"Georgian","nativeName":"ქართული"],["code":"de","name":"German","nativeName":"Deutsch"],["code":"el","name":"Greek, Modern","nativeName":"Ελληνικά"],["code":"gn","name":"Guaraní","nativeName":"Avañeẽ"],["code":"gu","name":"Gujarati","nativeName":"ગુજરાતી"],["code":"ht","name":"Haitian; Haitian Creole","nativeName":"Kreyòl ayisyen"],["code":"ha","name":"Hausa","nativeName":"Hausa, هَوُسَ"],["code":"he","name":"Hebrew (modern)","nativeName":"עברית"],["code":"hz","name":"Herero","nativeName":"Otjiherero"],["code":"hi","name":"Hindi","nativeName":"हिन्दी, हिंदी"],["code":"ho","name":"Hiri Motu","nativeName":"Hiri Motu"],["code":"hu","name":"Hungarian","nativeName":"Magyar"],["code":"ia","name":"Interlingua","nativeName":"Interlingua"],["code":"id","name":"Indonesian","nativeName":"Bahasa Indonesia"],["code":"ie","name":"Interlingue","nativeName":"Originally called Occidental; then Interlingue after WWII"],["code":"ga","name":"Irish","nativeName":"Gaeilge"],["code":"ig","name":"Igbo","nativeName":"Asụsụ Igbo"],["code":"ik","name":"Inupiaq","nativeName":"Iñupiaq, Iñupiatun"],["code":"io","name":"Ido","nativeName":"Ido"],["code":"is","name":"Icelandic","nativeName":"Íslenska"],["code":"it","name":"Italian","nativeName":"Italiano"],["code":"iu","name":"Inuktitut","nativeName":"ᐃᓄᒃᑎᑐᑦ"],["code":"ja","name":"Japanese","nativeName":"日本語 (にほんご／にっぽんご)"],["code":"jv","name":"Javanese","nativeName":"basa Jawa"],["code":"kl","name":"Kalaallisut, Greenlandic","nativeName":"kalaallisut, kalaallit oqaasii"],["code":"kn","name":"Kannada","nativeName":"ಕನ್ನಡ"],["code":"kr","name":"Kanuri","nativeName":"Kanuri"],["code":"ks","name":"Kashmiri","nativeName":"कश्मीरी, كشميري‎"],["code":"kk","name":"Kazakh","nativeName":"Қазақ тілі"],["code":"km","name":"Khmer","nativeName":"ភាសាខ្មែរ"],["code":"ki","name":"Kikuyu, Gikuyu","nativeName":"Gĩkũyũ"],["code":"rw","name":"Kinyarwanda","nativeName":"Ikinyarwanda"],["code":"ky","name":"Kirghiz, Kyrgyz","nativeName":"кыргыз тили"],["code":"kv","name":"Komi","nativeName":"коми кыв"],["code":"kg","name":"Kongo","nativeName":"KiKongo"],["code":"ko","name":"Korean","nativeName":"한국어 (韓國語), 조선말 (朝鮮語)"],["code":"ku","name":"Kurdish","nativeName":"Kurdî, كوردی‎"],["code":"kj","name":"Kwanyama, Kuanyama","nativeName":"Kuanyama"],["code":"la","name":"Latin","nativeName":"latine, lingua latina"],["code":"lb","name":"Luxembourgish, Letzeburgesch","nativeName":"Lëtzebuergesch"],["code":"lg","name":"Luganda","nativeName":"Luganda"],["code":"li","name":"Limburgish, Limburgan, Limburger","nativeName":"Limburgs"],["code":"ln","name":"Lingala","nativeName":"Lingála"],["code":"lo","name":"Lao","nativeName":"ພາສາລາວ"],["code":"lt","name":"Lithuanian","nativeName":"lietuvių kalba"],["code":"lv","name":"Latvian","nativeName":"latviešu valoda"],["code":"gv","name":"Manx","nativeName":"Gaelg, Gailck"],["code":"mk","name":"Macedonian","nativeName":"македонски јазик"],["code":"mg","name":"Malagasy","nativeName":"Malagasy fiteny"],["code":"ms","name":"Malay","nativeName":"bahasa Melayu, بهاس ملايو‎"],["code":"ml","name":"Malayalam","nativeName":"മലയാളം"],["code":"mt","name":"Maltese","nativeName":"Malti"],["code":"mi","name":"Māori","nativeName":"te reo Māori"],["code":"mr","name":"Marathi (Marāṭhī)","nativeName":"मराठी"],["code":"mh","name":"Marshallese","nativeName":"Kajin M̧ajeļ"],["code":"mn","name":"Mongolian","nativeName":"монгол"],["code":"na","name":"Nauru","nativeName":"Ekakairũ Naoero"],["code":"nv","name":"Navajo, Navaho","nativeName":"Diné bizaad, Dinékʼehǰí"],["code":"nb","name":"Norwegian Bokmål","nativeName":"Norsk bokmål"],["code":"nd","name":"North Ndebele","nativeName":"isiNdebele"],["code":"ne","name":"Nepali","nativeName":"नेपाली"],["code":"ng","name":"Ndonga","nativeName":"Owambo"],["code":"nn","name":"Norwegian Nynorsk","nativeName":"Norsk nynorsk"],["code":"no","name":"Norwegian","nativeName":"Norsk"],["code":"ii","name":"Nuosu","nativeName":"ꆈꌠ꒿ Nuosuhxop"],["code":"nr","name":"South Ndebele","nativeName":"isiNdebele"],["code":"oc","name":"Occitan","nativeName":"Occitan"],["code":"oj","name":"Ojibwe, Ojibwa","nativeName":"ᐊᓂᔑᓈᐯᒧᐎᓐ"],["code":"cu","name":"Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic","nativeName":"ѩзыкъ словѣньскъ"],["code":"om","name":"Oromo","nativeName":"Afaan Oromoo"],["code":"or","name":"Oriya","nativeName":"ଓଡ଼ିଆ"],["code":"os","name":"Ossetian, Ossetic","nativeName":"ирон æвзаг"],["code":"pa","name":"Panjabi, Punjabi","nativeName":"ਪੰਜਾਬੀ, پنجابی‎"],["code":"pi","name":"Pāli","nativeName":"पाऴि"],["code":"fa","name":"Persian","nativeName":"فارسی"],["code":"pl","name":"Polish","nativeName":"polski"],["code":"ps","name":"Pashto, Pushto","nativeName":"پښتو"],["code":"pt","name":"Portuguese","nativeName":"Português"],["code":"qu","name":"Quechua","nativeName":"Runa Simi, Kichwa"],["code":"rm","name":"Romansh","nativeName":"rumantsch grischun"],["code":"rn","name":"Kirundi","nativeName":"kiRundi"],["code":"ro","name":"Romanian, Moldavian, Moldovan","nativeName":"română"],["code":"ru","name":"Russian","nativeName":"русский язык"],["code":"sa","name":"Sanskrit (Saṁskṛta)","nativeName":"संस्कृतम्"],["code":"sc","name":"Sardinian","nativeName":"sardu"],["code":"sc","name":"Sardinian","nativeName":"sardu"],["code":"sd","name":"Sindhi","nativeName":"सिन्धी, سنڌي، سندھی‎"],["code":"se","name":"Northern Sami","nativeName":"Davvisámegiella"],["code":"sm","name":"Samoan","nativeName":"gagana faa Samoa"],["code":"sg","name":"Sango","nativeName":"yângâ tî sängö"],["code":"sr","name":"Serbian","nativeName":"српски језик"],["code":"gd","name":"Scottish Gaelic; Gaelic","nativeName":"Gàidhlig"],["code":"sn","name":"Shona","nativeName":"chiShona"],["code":"si","name":"Sinhala, Sinhalese","nativeName":"සිංහල"],["code":"sk","name":"Slovak","nativeName":"slovenčina"],["code":"sl","name":"Slovene","nativeName":"slovenščina"],["code":"so","name":"Somali","nativeName":"Soomaaliga, af Soomaali"],["code":"st","name":"Southern Sotho","nativeName":"Sesotho"],["code":"es","name":"Spanish; Castilian","nativeName":"español, castellano"],["code":"su","name":"Sundanese","nativeName":"Basa Sunda"],["code":"sw","name":"Swahili","nativeName":"Kiswahili"],["code":"ss","name":"Swati","nativeName":"SiSwati"],["code":"sv","name":"Swedish","nativeName":"svenska"],["code":"ta","name":"Tamil","nativeName":"தமிழ்"],["code":"te","name":"Telugu","nativeName":"తెలుగు"],["code":"tg","name":"Tajik","nativeName":"тоҷикӣ, toğikī, تاجیکی‎"],["code":"th","name":"Thai","nativeName":"ไทย"],["code":"ti","name":"Tigrinya","nativeName":"ትግርኛ"],["code":"bo","name":"Tibetan Standard, Tibetan, Central","nativeName":"བོད་ཡིག"],["code":"tk","name":"Turkmen","nativeName":"Türkmen, Түркмен"],["code":"tl","name":"Tagalog","nativeName":"Wikang Tagalog, ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔"],["code":"tn","name":"Tswana","nativeName":"Setswana"],["code":"to","name":"Tonga (Tonga Islands)","nativeName":"faka Tonga"],["code":"tr","name":"Turkish","nativeName":"Türkçe"],["code":"ts","name":"Tsonga","nativeName":"Xitsonga"],["code":"tt","name":"Tatar","nativeName":"татарча, tatarça, تاتارچا‎"],["code":"tw","name":"Twi","nativeName":"Twi"],["code":"ty","name":"Tahitian","nativeName":"Reo Tahiti"],["code":"ug","name":"Uighur, Uyghur","nativeName":"Uyƣurqə, ئۇيغۇرچە‎"],["code":"uk","name":"Ukrainian","nativeName":"українська"],["code":"ur","name":"Urdu","nativeName":"اردو"],["code":"uz","name":"Uzbek","nativeName":"zbek, Ўзбек, أۇزبېك‎"],["code":"ve","name":"Venda","nativeName":"Tshivenḓa"],["code":"vi","name":"Vietnamese","nativeName":"Tiếng Việt"],["code":"vo","name":"Volapük","nativeName":"Volapük"],["code":"wa","name":"Walloon","nativeName":"Walon"],["code":"cy","name":"Welsh","nativeName":"Cymraeg"],["code":"wo","name":"Wolof","nativeName":"Wollof"],["code":"fy","name":"Western Frisian","nativeName":"Frysk"],["code":"xh","name":"Xhosa","nativeName":"isiXhosa"],["code":"yi","name":"Yiddish","nativeName":"ייִדיש"],["code":"yo","name":"Yoruba","nativeName":"Yorùbá"],["code":"za","name":"Zhuang, Chuang","nativeName":"Saɯ cueŋƅ, Saw cuengh"]]
