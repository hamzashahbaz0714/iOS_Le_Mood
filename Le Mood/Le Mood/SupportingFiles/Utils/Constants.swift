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
func getCurrentDateWithDash() -> String{
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
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


let languageArr = [["code":"ab","name":"Abkhaz","nativeName":"??????????"],["code":"aa","name":"Afar","nativeName":"Afaraf"],["code":"af","name":"Afrikaans","nativeName":"Afrikaans"],["code":"ak","name":"Akan","nativeName":"Akan"],["code":"sq","name":"Albanian","nativeName":"Shqip"],["code":"am","name":"Amharic","nativeName":"????????????"],["code":"ar","name":"Arabic","nativeName":"??????????????"],["code":"an","name":"Aragonese","nativeName":"Aragon??s"],["code":"hy","name":"Armenian","nativeName":"??????????????"],["code":"as","name":"Assamese","nativeName":"?????????????????????"],["code":"av","name":"Avaric","nativeName":"???????? ????????, ???????????????? ????????"],["code":"ae","name":"Avestan","nativeName":"avesta"],["code":"ay","name":"Aymara","nativeName":"aymar aru"],["code":"az","name":"Azerbaijani","nativeName":"az??rbaycan dili"],["code":"bm","name":"Bambara","nativeName":"bamanankan"],["code":"ba","name":"Bashkir","nativeName":"?????????????? ????????"],["code":"eu","name":"Basque","nativeName":"euskara, euskera"],["code":"eu","name":"Basque","nativeName":"euskara, euskera"],["code":"be","name":"Belarusian","nativeName":"????????????????????"],["code":"bn","name":"Bengali","nativeName":"???????????????"],["code":"bh","name":"Bihari","nativeName":"?????????????????????"],["code":"bi","name":"Bislama","nativeName":"Bislama"],["code":"bs","name":"Bosnian","nativeName":"bosanski jezik"],["code":"br","name":"Breton","nativeName":"brezhoneg"],["code":"my","name":"Burmese","nativeName":"???????????????"],["code":"my","name":"Burmese","nativeName":"???????????????"],["code":"ca","name":"Catalan; Valencian","nativeName":"Catal??"],["code":"ch","name":"Chamorro","nativeName":"Chamoru"],["code":"ce","name":"Chechen","nativeName":"?????????????? ????????"],["code":"ny","name":"Chichewa; Chewa; Nyanja","nativeName":"chiChe??a, chinyanja"],["code":"zh","name":"Chinese","nativeName":"?????? (Zh??ngw??n), ??????, ??????"],["code":"cv","name":"Chuvash","nativeName":"?????????? ??????????"],["code":"kw","name":"Cornish","nativeName":"Kernewek"],["code":"co","name":"Corsican","nativeName":"corsu, lingua corsa"],["code":"cr","name":"Cree","nativeName":"?????????????????????"],["code":"hr","name":"Croatian","nativeName":"hrvatski"],["code":"cs","name":"Czech","nativeName":"??esky, ??e??tina"],["code":"da","name":"Danish","nativeName":"dansk"],["code":"dv","name":"Divehi; Dhivehi; Maldivian;","nativeName":"????????????"],["code":"nl","name":"Dutch","nativeName":"Nederlands, Vlaams"],["code":"en","name":"English","nativeName":"English"],["code":"eo","name":"Esperanto","nativeName":"Esperanto"],["code":"et","name":"Estonian","nativeName":"eesti, eesti keel"],["code":"ee","name":"Ewe","nativeName":"E??egbe"],["code":"fo","name":"Faroese","nativeName":"f??royskt"],["code":"fj","name":"Fijian","nativeName":"vosa Vakaviti"],["code":"fi","name":"Finnish","nativeName":"suomi, suomen kieli"],["code":"fr","name":"French","nativeName":"fran??ais, langue fran??aise"],["code":"ff","name":"Fula; Fulah; Pulaar; Pular","nativeName":"Fulfulde, Pulaar, Pular"],["code":"gl","name":"Galician","nativeName":"Galego"],["code":"ka","name":"Georgian","nativeName":"?????????????????????"],["code":"de","name":"German","nativeName":"Deutsch"],["code":"el","name":"Greek, Modern","nativeName":"????????????????"],["code":"gn","name":"Guaran??","nativeName":"Ava??e???"],["code":"gu","name":"Gujarati","nativeName":"?????????????????????"],["code":"ht","name":"Haitian; Haitian Creole","nativeName":"Krey??l ayisyen"],["code":"ha","name":"Hausa","nativeName":"Hausa, ????????????"],["code":"he","name":"Hebrew (modern)","nativeName":"??????????"],["code":"hz","name":"Herero","nativeName":"Otjiherero"],["code":"hi","name":"Hindi","nativeName":"??????????????????, ???????????????"],["code":"ho","name":"Hiri Motu","nativeName":"Hiri Motu"],["code":"hu","name":"Hungarian","nativeName":"Magyar"],["code":"ia","name":"Interlingua","nativeName":"Interlingua"],["code":"id","name":"Indonesian","nativeName":"Bahasa Indonesia"],["code":"ie","name":"Interlingue","nativeName":"Originally called Occidental; then Interlingue after WWII"],["code":"ga","name":"Irish","nativeName":"Gaeilge"],["code":"ig","name":"Igbo","nativeName":"As???s??? Igbo"],["code":"ik","name":"Inupiaq","nativeName":"I??upiaq, I??upiatun"],["code":"io","name":"Ido","nativeName":"Ido"],["code":"is","name":"Icelandic","nativeName":"??slenska"],["code":"it","name":"Italian","nativeName":"Italiano"],["code":"iu","name":"Inuktitut","nativeName":"??????????????????"],["code":"ja","name":"Japanese","nativeName":"????????? (??????????????????????????????)"],["code":"jv","name":"Javanese","nativeName":"basa Jawa"],["code":"kl","name":"Kalaallisut, Greenlandic","nativeName":"kalaallisut, kalaallit oqaasii"],["code":"kn","name":"Kannada","nativeName":"???????????????"],["code":"kr","name":"Kanuri","nativeName":"Kanuri"],["code":"ks","name":"Kashmiri","nativeName":"?????????????????????, ???????????????"],["code":"kk","name":"Kazakh","nativeName":"?????????? ????????"],["code":"km","name":"Khmer","nativeName":"???????????????????????????"],["code":"ki","name":"Kikuyu, Gikuyu","nativeName":"G??k??y??"],["code":"rw","name":"Kinyarwanda","nativeName":"Ikinyarwanda"],["code":"ky","name":"Kirghiz, Kyrgyz","nativeName":"???????????? ????????"],["code":"kv","name":"Komi","nativeName":"???????? ??????"],["code":"kg","name":"Kongo","nativeName":"KiKongo"],["code":"ko","name":"Korean","nativeName":"????????? (?????????), ????????? (?????????)"],["code":"ku","name":"Kurdish","nativeName":"Kurd??, ?????????????"],["code":"kj","name":"Kwanyama, Kuanyama","nativeName":"Kuanyama"],["code":"la","name":"Latin","nativeName":"latine, lingua latina"],["code":"lb","name":"Luxembourgish, Letzeburgesch","nativeName":"L??tzebuergesch"],["code":"lg","name":"Luganda","nativeName":"Luganda"],["code":"li","name":"Limburgish, Limburgan, Limburger","nativeName":"Limburgs"],["code":"ln","name":"Lingala","nativeName":"Ling??la"],["code":"lo","name":"Lao","nativeName":"?????????????????????"],["code":"lt","name":"Lithuanian","nativeName":"lietuvi?? kalba"],["code":"lv","name":"Latvian","nativeName":"latvie??u valoda"],["code":"gv","name":"Manx","nativeName":"Gaelg, Gailck"],["code":"mk","name":"Macedonian","nativeName":"???????????????????? ??????????"],["code":"mg","name":"Malagasy","nativeName":"Malagasy fiteny"],["code":"ms","name":"Malay","nativeName":"bahasa Melayu, ???????? ?????????????"],["code":"ml","name":"Malayalam","nativeName":"??????????????????"],["code":"mt","name":"Maltese","nativeName":"Malti"],["code":"mi","name":"M??ori","nativeName":"te reo M??ori"],["code":"mr","name":"Marathi (Mar?????h??)","nativeName":"???????????????"],["code":"mh","name":"Marshallese","nativeName":"Kajin M??aje??"],["code":"mn","name":"Mongolian","nativeName":"????????????"],["code":"na","name":"Nauru","nativeName":"Ekakair?? Naoero"],["code":"nv","name":"Navajo, Navaho","nativeName":"Din?? bizaad, Din??k??eh????"],["code":"nb","name":"Norwegian Bokm??l","nativeName":"Norsk bokm??l"],["code":"nd","name":"North Ndebele","nativeName":"isiNdebele"],["code":"ne","name":"Nepali","nativeName":"??????????????????"],["code":"ng","name":"Ndonga","nativeName":"Owambo"],["code":"nn","name":"Norwegian Nynorsk","nativeName":"Norsk nynorsk"],["code":"no","name":"Norwegian","nativeName":"Norsk"],["code":"ii","name":"Nuosu","nativeName":"????????? Nuosuhxop"],["code":"nr","name":"South Ndebele","nativeName":"isiNdebele"],["code":"oc","name":"Occitan","nativeName":"Occitan"],["code":"oj","name":"Ojibwe, Ojibwa","nativeName":"????????????????????????"],["code":"cu","name":"Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic","nativeName":"?????????? ????????????????????"],["code":"om","name":"Oromo","nativeName":"Afaan Oromoo"],["code":"or","name":"Oriya","nativeName":"???????????????"],["code":"os","name":"Ossetian, Ossetic","nativeName":"???????? ??????????"],["code":"pa","name":"Panjabi, Punjabi","nativeName":"??????????????????, ???????????????"],["code":"pi","name":"P??li","nativeName":"????????????"],["code":"fa","name":"Persian","nativeName":"??????????"],["code":"pl","name":"Polish","nativeName":"polski"],["code":"ps","name":"Pashto, Pushto","nativeName":"????????"],["code":"pt","name":"Portuguese","nativeName":"Portugu??s"],["code":"qu","name":"Quechua","nativeName":"Runa Simi, Kichwa"],["code":"rm","name":"Romansh","nativeName":"rumantsch grischun"],["code":"rn","name":"Kirundi","nativeName":"kiRundi"],["code":"ro","name":"Romanian, Moldavian, Moldovan","nativeName":"rom??n??"],["code":"ru","name":"Russian","nativeName":"?????????????? ????????"],["code":"sa","name":"Sanskrit (Sa???sk???ta)","nativeName":"???????????????????????????"],["code":"sc","name":"Sardinian","nativeName":"sardu"],["code":"sc","name":"Sardinian","nativeName":"sardu"],["code":"sd","name":"Sindhi","nativeName":"??????????????????, ?????????? ?????????????"],["code":"se","name":"Northern Sami","nativeName":"Davvis??megiella"],["code":"sm","name":"Samoan","nativeName":"gagana faa Samoa"],["code":"sg","name":"Sango","nativeName":"y??ng?? t?? s??ng??"],["code":"sr","name":"Serbian","nativeName":"???????????? ??????????"],["code":"gd","name":"Scottish Gaelic; Gaelic","nativeName":"G??idhlig"],["code":"sn","name":"Shona","nativeName":"chiShona"],["code":"si","name":"Sinhala, Sinhalese","nativeName":"???????????????"],["code":"sk","name":"Slovak","nativeName":"sloven??ina"],["code":"sl","name":"Slovene","nativeName":"sloven????ina"],["code":"so","name":"Somali","nativeName":"Soomaaliga, af Soomaali"],["code":"st","name":"Southern Sotho","nativeName":"Sesotho"],["code":"es","name":"Spanish; Castilian","nativeName":"espa??ol, castellano"],["code":"su","name":"Sundanese","nativeName":"Basa Sunda"],["code":"sw","name":"Swahili","nativeName":"Kiswahili"],["code":"ss","name":"Swati","nativeName":"SiSwati"],["code":"sv","name":"Swedish","nativeName":"svenska"],["code":"ta","name":"Tamil","nativeName":"???????????????"],["code":"te","name":"Telugu","nativeName":"??????????????????"],["code":"tg","name":"Tajik","nativeName":"????????????, to??ik??, ???????????????"],["code":"th","name":"Thai","nativeName":"?????????"],["code":"ti","name":"Tigrinya","nativeName":"????????????"],["code":"bo","name":"Tibetan Standard, Tibetan, Central","nativeName":"?????????????????????"],["code":"tk","name":"Turkmen","nativeName":"T??rkmen, ??????????????"],["code":"tl","name":"Tagalog","nativeName":"Wikang Tagalog, ??????????????? ??????????????????"],["code":"tn","name":"Tswana","nativeName":"Setswana"],["code":"to","name":"Tonga (Tonga Islands)","nativeName":"faka Tonga"],["code":"tr","name":"Turkish","nativeName":"T??rk??e"],["code":"ts","name":"Tsonga","nativeName":"Xitsonga"],["code":"tt","name":"Tatar","nativeName":"??????????????, tatar??a, ?????????????????"],["code":"tw","name":"Twi","nativeName":"Twi"],["code":"ty","name":"Tahitian","nativeName":"Reo Tahiti"],["code":"ug","name":"Uighur, Uyghur","nativeName":"Uy??urq??, ???????????????????"],["code":"uk","name":"Ukrainian","nativeName":"????????????????????"],["code":"ur","name":"Urdu","nativeName":"????????"],["code":"uz","name":"Uzbek","nativeName":"zbek, ??????????, ???????????????"],["code":"ve","name":"Venda","nativeName":"Tshiven???a"],["code":"vi","name":"Vietnamese","nativeName":"Ti???ng Vi???t"],["code":"vo","name":"Volap??k","nativeName":"Volap??k"],["code":"wa","name":"Walloon","nativeName":"Walon"],["code":"cy","name":"Welsh","nativeName":"Cymraeg"],["code":"wo","name":"Wolof","nativeName":"Wollof"],["code":"fy","name":"Western Frisian","nativeName":"Frysk"],["code":"xh","name":"Xhosa","nativeName":"isiXhosa"],["code":"yi","name":"Yiddish","nativeName":"????????????"],["code":"yo","name":"Yoruba","nativeName":"Yor??b??"],["code":"za","name":"Zhuang, Chuang","nativeName":"Sa?? cue????, Saw cuengh"]]
