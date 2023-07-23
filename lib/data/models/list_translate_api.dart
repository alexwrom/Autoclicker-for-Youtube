


   class ListTranslate{

      static Map<String,List> codeListTranslate={

				"af": ["Afrikaans"],
				"ak": ["Akan"],
				"sq": ["Albanian"],
				"am": ["Amharic"],
				"ar": ["Arabic"],
				"hy": ["Armenian"],
				"as": ["Assamese"],
				"ay": ["Aymara"],
				"az": ["Azerbaijani"],
				"bm": ["Bambara"],
				"eu": ["Basque"],
				"be": ["Belarusian"],
				"bn": ["Bengali"],
				"bs": ["Bosnian"],
				"bg": ["Bulgarian"],
				"my": ["Burmese"],
				"ca": ["Catalan"],
				"zh": ["Chinese"],
				"co": ["Corsican"],
				"hr": ["Croatian"],
				"cs": ["Czech"],
				"da": ["Danish"],
				"nl": ["Dutch"],
				"en": ["English"],
				"eo": ["Esperanto"],
				"et": ["Estonian"],
				"ee": ["Ewe"],
				"fi": ["Finnish"],
				"fr": ["French"],
				"gd": ["Gaelic"],
				"gl": ["Galician"],
				"ka": ["Georgian"],
				"de": ["German"],
				"el": ["Greek"],
				"gn": ["Guarani"],
				"gu": ["Gujarati"],
				"ha": ["Hausa"],
				"he": ["Hebrew"],
				"hi": ["Hindi"],
				"hu": ["Hungarian"],
				"is": ["Icelandic"],
				"ig": ["Igbo"],
				"id": ["Indonesian"],
				"ga": ["Irish"],
				"it": ["Italian"],
				"ja": ["Japanese"],
				"jv": ["Javanese"],
				"kn": ["Kannada"],
				"kk": ["Kazakh"],
				"km": ["Khmer"],
				"ko": ["Korean"],
				"ku": ["Kurdish"],
				"ky": ["Kyrgyz"],
				"lo": ["Lao"],
				"la": ["Latin"],
				"lv": ["Latvian"],
				"ln": ["Lingala"],
				"lt": ["Lithuanian"],
				"lg": ["Luganda"],
				"lb": ["Luxembourgish"],
				"mk": ["Macedonian"],
				"mg": ["Malagasy"],
				"ms": ["Malay"],
				"ml": ["Malayalam"],
				"mt": ["Maltese"],
				"mi": ["Maori"],
				"mr": ["Marathi"],
				"mn": ["Mongolian"],
				"ne": ["Nepali"],
				"no": ["Norwegian"],
				"or": ["Oriya"],
				"om": ["Oromo"],
				"ps": ["Pashto"],
				"fa": ["Persian"],
				"pl": ["Polish"],
				"pt": ["Portuguese"],
				"pa": ["Punjabi"],
				"qu": ["Quechua"],
				"ro": ["Romanian"],
				"ru": ["Russian"],
				"sm": ["Samoan"],
				"sa": ["Sanskrit"],
				"sr": ["Serbian"],
				"st": ["Sesotho"],
				"sn": ["Shona"],
				"sd": ["Sindhi"],
				"si": ["Sinhalese"],
				"sk": ["Slovak"],
				"sl": ["Slovenian"],
				"so": ["Somali"],
				"es": ["Spanish"],
				"su": ["Sundanese"],
				"sw": ["Swahili"],
				"sv": ["Swedish"],
				"tg": ["Tajik"],
				"ta": ["Tamil"],
				"tt": ["Tatar"],
				"te": ["Telugu"],
				"th": ["Thai"],
				"ti": ["Tigrinya"],
				"ts": ["Tsonga"],
				"tr": ["Turkish"],
				"tk": ["Turkmen"],
				"uk": ["Ukrainian"],
				"ur": ["Urdu"],
				"ug": ["Uyghur"],
				"uz": ["Uzbek"],
				"vi": ["Vietnamese"],
				"cy": ["Welsh"],
				"xh": ["Xhosa"],
				"yi": ["Yiddish"],
				"yo": ["Yoruba"],
				"zu": ["Zulu"],
      };



      static String  langName(int index){
         final String key=codeListTranslate.keys.elementAt(index);
         return codeListTranslate[key]![0];
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

