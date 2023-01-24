


   class ListTranslate{

      static Map<String,List> codeListTranslate={
         'az':	['Azerbaijani','Азербайжанский'],
        'ay':	['Aymara','Аймара'],
      	'ak':	['Akan','Акан'],
      	'sq':	['Albanian','Албанский'],
      	'am':	['Amharic','Амхарский'],
      	'en':	['English','Английский'],
      	'ar':	['Arab','Арабский'],
      	'hy':	['Armenian','Армянский'],
      	'as':	['Assamese','Ассамский'],
      	'af':	['Afrikaans','Африкаанс'],
      	'bm':	['Bambara','Бамбара'],
      	'eu':	['Basque','Баскский'],
      	'be':	['Belorussian','Белорусский'],
      	'bn':	['Bengal','Бенгальский Бирманский'],
      	'bg':	['Bulgarian','Болгарский'],
      	'bs':	['Bosnian','Боснийский'],
      	'cy':	['Welsh','Валлийский'],
      	'hu':	['Hungarian','Венгерский'],
      	'vi':	['Vietnamese','Вьетнамский'],
      	'gl':	['Galician','Галисийский'],
      	'lg':	['Ganda','Ганда'],
      	'el':	['Greek (Modern Greek)','Греческий (новогреческий)'],
      	'ka':	['Georgian','Грузинский'],
       	'gn':	['Guarani', 'Гуарани'],
      	'gu':	['Gujarati','Гуджарати'],
      	'gd':	['Gaelic','Гэльский'],
      	'da':	['Danish','Датский'],
      	'dv':	['Dhivehi (Maldives)','Дивехи (Мальдивский)'],
      	'zu':	['Zulu','Зулу'],
      	'he':	['Hebrew','Иврит'],
      	'ig':	['Igbo','Игбо'],
      	'yi':	['Yiddish','Идиш'],
      	'id':	['Indonesian','Индонезийский'],
      	'ga':	['Irish','Ирландский'],
      	'is':	['Icelandic','Исландский'],
      	'es':	['Spanish','Испанский'],
      	'it':	['Italian','Итальянский'],
      	'yo':	['Yoruba','Йоруба'],
      	'kk':	['Kazakh','Казахский'],
      	'kn':	['Kannada','Каннада'],
      	'ca':	['Catalan','Каталанский'],
        'qu':	['Quechua','Кечуа'],
      	'ky':	['Kyrgyz','Киргизский'],
      	'zh':	['Chinese','Китайский'],
      	'ko':	['Korean','Корейский'],
      	'co':	['Corsican','Корсиканский'],
      	'xh':	['Spit','Коса'],
      	'ku':	['Kurdish','Курдский'],
      	'km':	['Khmer','Кхмерский'],
      	'lo':	['Laotian','Лаосский'],
      	'la':	['Latin','Латинский'],
      	'lv':	['Latvian','Латышский'],
      	'ln':	['Lingala','Лингала'],
      	'lt':	['Lithuanian','Литовский'],
      	'lb':	['Luxembourgish','Люксембургский'],
      	'mk':	['Macedonian','Македонский'],
      	'mg':	['Malagasy','Малагасийский'],
      	'ms':	['Malay','Малайский'],
      	'ml':	['Malayalam','Малаялам'],
      	'mt':	['Maltese','Мальтийский'],
        'mi':	['Maori','Маори	'],
      	'mr':	['Marathi','Маратхи'],
      	'me':	['Meryansky','Мерянский'],
      	'mo':	['Moldavian','Молдавский'],
      	'mn':	['Mongolian','Монгольский'],
      	'de':	['Deutsch','Немецкий'],
      	'ne':	['Nepali','Непальский'],
      	'nl':	['Dutch (Dutch)','Нидерландский (Голландский)'],
      	'no':	['Norwegian','Норвежский'],
      	'ny':	['Nyanja','Ньянджа'],
        'or':	['Oriya','Ория	'],
      	'om':	['Oromo','Оромо'],
      	'pa':	['Punjabi','Пенджабский'],
      	'fa':	['Persian','Персидский'],
      	'pl':	['Polish','Польский'],
      	'pt':	['Portuguese','Португальский'],
        'ps':	['Pashto','Пушту	'],
      	'rw':	['Rwanda','Руанда'],
      	'ro':	['Romanian','Румынский'],
      	'ru':	['Russian','Русский'],
      	'sm':	['Samoan','Самоанский'],
      	'sa':	['Sanskrit','Санскрит'],
      	'sr':	['Serbian','Сербский'],
      	'si':	['Sinhalese','Сингальский'],
      	'sd':	['Sindhi','Синдхи'],
      	'sk':	['Slovak','Словацкий'],
      	'sl':	['Slovenian','Словенский'],
      	'so':	['Somalia','Сомали'],
      	'st':	['soto south','Сото южный'],
      	'sw':	['Swahili','Суахили'],
      	'su':	['Sundanese','Сунданский'],
      	'tl':	['Tagalog','Тагальский'],
      	'tg':	['Tajik','Таджикский'],
      	'th':	['Thai','Тайский'],
      	'ta':	['Tamil','Тамильский'],
      'tt':	['Tatar','Татарский'],
      'tw':	['Twi','Тви	'],
      	'te':	['Telugu','Телугу'],
      	'ti':	['Tigrinya','Тигринья'],
      	'ts':	['Tsonga','Тсонга'],
      	'tr':	['Turkish','Турецкий'],
      	'tk':	['Turkmen','Туркменский'],
      	'uz':	['Uzbek','Узбекский'],
      	'ug':	['Uigur','Уйгурский'],
      	'uk':	['Ukrainian','Украинский'],
      	'ur':	['Urdu','Урду'],
      	'fl':	['Philippine','Филиппинский'],
      	'fi':	['Finnish Suomi','Финский (Suomi)'],
      	'fr':	['French','Французский'],
      	'fy':	['Frisian','Фризский'],
        'ha':	['Hausa','Хауса	'],
      	'hi':	['Hindi','Хинди'],
      	'hr':	['Croatian','Хорватский'],
      	'cs':	['Czech','Чешский'],
      	'sv':	['Swedish','Шведский'],
      	'sn':	['Shona','Шона'],
      	'ee':	['Ewe','Эве'],
      	'eo':	['Esperanto','Эсперанто'],
      	'et':	['Estonian','Эстонский'],
      	'jv':	['Javanese','Яванский'],
      	'ja':	['Japanese','Японский']


      };



      static String  langName(int index,Local local){
         final String key=codeListTranslate.keys.elementAt(index);
         int language=local==Local.ru?1:0;
         return codeListTranslate[key]![language];
      }

      static String  langCode(int index){
         final String key=codeListTranslate.keys.elementAt(index);
         return key;
      }


   }

   enum Local{
     ru,
      en
   }