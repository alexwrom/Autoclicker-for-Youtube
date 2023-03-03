


   class ListTranslate{

      static Map<String,List> codeListTranslate={

				//a
				'af':	['Afrikaans','Африкаанс'],
				'ak':	['Akan','Акан'],
				'sq':	['Albanian','Албанский'],
				'am':	['Amharic','Амхарский'],
				'ar':	['Arab','Арабский'],
				'hy':	['Armenian','Армянский'],
				'as':	['Assamese','Ассамский'],
				'ay':	['Aymara','Аймара'],
				'az':	['Azerbaijani','Азербайжанский'],

				//b
				'bm':	['Bambara','Бамбара'],
				'eu':	['Basque','Баскский'],
				'be':	['Belorussian','Белорусский'],
				'bn':	['Bengal','Бенгальский'],
				'bs':	['Bosnian','Боснийский'],
				'bg':	['Bulgarian','Болгарский'],
				'my':['Burmese','Бирманский'],

         //c
				'ca':	['Catalan','Каталанский'],
				'zh':	['Chinese','Китайский'],
				'co':	['Corsican','Корсиканский'],
				'hr':	['Croatian','Хорватский'],
				'cs':	['Czech','Чешский'],

				 //d
				'da':	['Danish','Датский'],
				'de':	['Deutsch','Немецкий'],
				'nl':	['Dutch (Dutch)','Нидерландский (Голландский)'],
				//e
				'en':	['English','Английский'],
				'eo':	['Esperanto','Эсперанто'],
				'et':	['Estonian','Эстонский'],
				'ee':	['Ewe','Эве'],

         //f
				'fi':	['Finnish Suomi','Финский (Suomi)'],
				'fr':	['French','Французский'],
				//g
				'gd':	['Gaelic','Гэльский'],
				'gl':	['Galician','Галисийский'],
				'lg':	['Ganda','Ганда'],
				'ka':	['Georgian','Грузинский'],
				'el':	['Greek (Modern Greek)','Греческий (новогреческий)'],
				'gn':	['Guarani', 'Гуарани'],
				'gu':	['Gujarati','Гуджарати'],
				//h
				'ha':	['Hausa','Хауса	'],
				'he':	['Hebrew','Иврит'],
				'hi':	['Hindi','Хинди'],
				'hu':	['Hungarian','Венгерский'],

				//i
				'is':	['Icelandic','Исландский'],
				'ig':	['Igbo','Игбо'],
				'id':	['Indonesian','Индонезийский'],
				'ga':	['Irish','Ирландский'],
				'it':	['Italian','Итальянский'],
        //j
				'jv':	['Javanese','Яванский'],
				'ja':	['Japanese','Японский'],
				//k
				'kn':	['Kannada','Каннада'],
				'kk':	['Kazakh','Казахский'],
				'km':	['Khmer','Кхмерский'],
				'ko':	['Korean','Корейский'],
				'ku':	['Kurdish','Курдский'],
				'ky':	['Kyrgyz','Киргизский'],
				//l
				'lo':	['Laotian','Лаосский'],
				'la':	['Latin','Латинский'],
				'lv':	['Latvian','Латышский'],
				'ln':	['Lingala','Лингала'],
				'lt':	['Lithuanian','Литовский'],
				'lb':	['Luxembourgish','Люксембургский'],
				//m
				'mk':	['Macedonian','Македонский'],
				'mg':	['Malagasy','Малагасийский'],
				'ms':	['Malay','Малайский'],
				'ml':	['Malayalam','Малаялам'],
				'mt':	['Maltese','Мальтийский'],
				'mi':	['Maori','Маори	'],
				'mr':	['Marathi','Маратхи'],
				'mn':	['Mongolian','Монгольский'],
				//n
				'ne':	['Nepali','Непальский'],
				'no':	['Norwegian','Норвежский'],
        //o
				'or':	['Oriya','Ория	'],
				'om':	['Oromo','Оромо'],
				//p
				'ps':	['Pashto','Пушту	'],
				'fa':	['Persian','Персидский'],
				'pl':	['Polish','Польский'],
				'pt':	['Portuguese','Португальский'],
				'pa':	['Punjabi','Пенджабский'],
				 //q
				'qu':	['Quechua','Кечуа'],
       //r
				'ro':	['Romanian','Румынский'],
				'ru':	['Russian','Русский'],
				//s
				'sm':	['Samoan','Самоанский'],
				'sa':	['Sanskrit','Санскрит'],
				'sr':	['Serbian','Сербский'],
				'sn':	['Shona','Шона'],
				'si':	['Sinhalese','Сингальский'],
				'sd':	['Sindhi','Синдхи'],
				'sk':	['Slovak','Словацкий'],
				'sl':	['Slovenian','Словенский'],
				'so':	['Somalia','Сомали'],
				'st':	['Soto south','Сото южный'],
				'es':	['Spanish','Испанский'],
				'xh':	['Spit','Коса'],
				'su':	['Sundanese','Сунданский'],
				'sw':	['Swahili','Суахили'],
				'sv':	['Swedish','Шведский'],
         //t
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
				//u
				'ug':	['Uigur','Уйгурский'],
				'uk':	['Ukrainian','Украинский'],
				'ur':	['Urdu','Урду'],
				'uz':	['Uzbek','Узбекский'],
				//v
				'vi':	['Vietnamese','Вьетнамский'],
				//w
				'cy':	['Welsh','Валлийский'],
				//y
				'yi':	['Yiddish','Идиш'],
				'yo':	['Yoruba','Йоруба'],
				//z
				'zu':	['Zulu','Зулу'],










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

