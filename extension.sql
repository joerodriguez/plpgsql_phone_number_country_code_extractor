CREATE FUNCTION extract_code_and_number(value TEXT)
  RETURNS TEXT [] AS
$$
DECLARE
  code        TEXT;
  number      TEXT;

  all_codes   TEXT [] := ARRAY [
  '3906698', --Vatican City,Vatican City State,Stato della Città del Vaticano,Vaticano,Status Civitatis Vaticanæ,Vaticanæ
  '5999', --Curaçao,Country of Curaçao,Country of Curaçao,Curaçao,Land Curaçao,Curaçao,Pais Kòrsou,Pais Kòrsou
  '4779', --Svalbard and Jan Mayen,Svalbard og Jan Mayen,Svalbard og Jan Mayen,Svalbard og Jan Mayen
  '1939', --Puerto Rico,Commonwealth of Puerto Rico,Commonwealth of Puerto Rico,Puerto Rico,Estado Libre Asociado de Puerto Rico,Puerto Rico
  '1876', --Jamaica,Jamaica,Jamaica,Jamaica,Jamaica,Jamaica
  '1869', --Saint Kitts and Nevis,Federation of Saint Christopher and Nevisa,Federation of Saint Christopher and Nevisa,Saint Kitts and Nevis
  '1868', --Trinidad and Tobago,Republic of Trinidad and Tobago,Republic of Trinidad and Tobago,Trinidad and Tobago
  '1849', --Dominican Republic,Dominican Republic,República Dominicana,República Dominicana
  '1829', --Dominican Republic,Dominican Republic,República Dominicana,República Dominicana
  '1809', --Dominican Republic,Dominican Republic,República Dominicana,República Dominicana
  '1787', --Puerto Rico,Commonwealth of Puerto Rico,Commonwealth of Puerto Rico,Puerto Rico,Estado Libre Asociado de Puerto Rico,Puerto Rico
  '1784', --Saint Vincent and the Grenadines,Saint Vincent and the Grenadines,Saint Vincent and the Grenadines,Saint Vincent and the Grenadines
  '1767', --Dominica,Commonwealth of Dominica,Commonwealth of Dominica,Dominica
  '1758', --Saint Lucia,Saint Lucia,Saint Lucia,Saint Lucia
  '1721', --Sint Maarten,Sint Maarten,Sint Maarten,Sint Maarten,Saint-Martin,Saint-Martin,Sint Maarten,Sint Maarten
  '1684', --American Samoa,American Samoa,American Samoa,American Samoa,Sāmoa Amelika,Sāmoa Amelika
  '1671', --Guam,Guam,Guåhån,Guåhån,Guam,Guam,Guam,Guam
  '1670', --Northern Mariana Islands,Commonwealth of the Northern Mariana Islands,Commonwealth of the Northern Mariana Islands,Northern Mariana Islands,Sankattan Siha Na Islas Mariånas,Na Islas Mariånas,Commonwealth of the Northern Mariana Islands,Northern Mariana Islands
  '1664', --Montserrat,Montserrat,Montserrat,Montserrat
  '1649', --Turks and Caicos Islands,Turks and Caicos Islands,Turks and Caicos Islands,Turks and Caicos Islands
  '1473', --Grenada,Grenada,Grenada,Grenada
  '1441', --Bermuda,Bermuda,Bermuda,Bermuda
  '1345', --Cayman Islands,Cayman Islands,Cayman Islands,Cayman Islands
  '1340', --United States Virgin Islands,Virgin Islands of the United States,Virgin Islands of the United States,United States Virgin Islands
  '1284', --British Virgin Islands,Virgin Islands,Virgin Islands,British Virgin Islands
  '1268', --Antigua and Barbuda,Antigua and Barbuda,Antigua and Barbuda,Antigua and Barbuda
  '1264', --Anguilla,Anguilla,Anguilla,Anguilla
  '1246', --Barbados,Barbados,Barbados,Barbados
  '1242', --Bahamas,Commonwealth of the Bahamas,Commonwealth of the Bahamas,Bahamas
  '998', --Uzbekistan,Republic of Uzbekistan,Республика Узбекистан,Узбекистан,O'zbekiston Respublikasi,O‘zbekiston
  '996', --Kyrgyzstan,Kyrgyz Republic,Кыргыз Республикасы,Кыргызстан,Кыргызская Республика,Киргизия
  '995', --Georgia,Georgia,საქართველო,საქართველო
  '994', --Azerbaijan,Republic of Azerbaijan,Azərbaycan Respublikası,Azərbaycan,Азербайджанская Республика,Азербайджан
  '993', --Turkmenistan,Turkmenistan,Туркменистан,Туркмения,Türkmenistan,Türkmenistan
  '992', --Tajikistan,Republic of Tajikistan,Республика Таджикистан,Таджикистан,Ҷумҳурии Тоҷикистон,Тоҷикистон
  '977', --Nepal,Federal Democratic Republic of Nepal,नेपाल संघीय लोकतान्त्रिक गणतन्त्र,नपल
  '976', --Mongolia,Mongolia,Монгол улс,Монгол улс
  '975', --Bhutan,Kingdom of Bhutan,འབྲུག་རྒྱལ་ཁབ་,འབྲུག་ཡུལ་
  '974', --Qatar,State of Qatar,دولة قطر,قطر
  '973', --Bahrain,Kingdom of Bahrain,مملكة البحرين,‏البحرين
  '972', --Israel,State of Israel,دولة إسرائيل,إسرائيل,מדינת ישראל,ישראל
  '971', --United Arab Emirates,United Arab Emirates,الإمارات العربية المتحدة,دولة الإمارات العربية المتحدة
  '970', --Palestine,State of Palestine,دولة فلسطين,فلسطين
  '968', --Oman,Sultanate of Oman,سلطنة عمان,عمان
  '967', --Yemen,Republic of Yemen,الجمهورية اليمنية,اليَمَن
  '966', --Saudi Arabia,Kingdom of Saudi Arabia,المملكة العربية السعودية,العربية السعودية
  '965', --Kuwait,State of Kuwait,دولة الكويت,الكويت
  '964', --Iraq,Republic of Iraq,جمهورية العراق,العراق,ܩܘܼܛܢܵܐ ܐܝܼܪܲܩ,ܩܘܼܛܢܵܐ,کۆماری عێراق,کۆماری
  '963', --Syria,Syrian Arab Republic,الجمهورية العربية السورية,سوريا
  '962', --Jordan,Hashemite Kingdom of Jordan,المملكة الأردنية الهاشمية,الأردن
  '961', --Lebanon,Lebanese Republic,الجمهورية اللبنانية,لبنان,République libanaise,Liban
  '960', --Maldives,Republic of the Maldives,ދިވެހިރާއްޖޭގެ ޖުމްހޫރިއްޔާ,ދިވެހިރާއްޖޭގެ
  '886', --Taiwan,Republic of China (Taiwan),中华民国,臺灣
  '880', --Bangladesh,People's Republic of Bangladesh,বাংলাদেশ গণপ্রজাতন্ত্রী,বাংলাদেশ
  '856', --Laos,Lao People's Democratic Republic,ສາທາລະນະ ຊາທິປະໄຕ ຄົນລາວ ຂອງ,ສປປລາວ
  '855', --Cambodia,Kingdom of Cambodia,ព្រះរាជាណាចក្រកម្ពុជា,Kâmpŭchéa
  '853', --Macau,Macao Special Administrative Region of the People's Republic of China,Região Administrativa Especial de Macau da República Popular da China,Macau,澳门特别行政区中国人民共和国,澳門
  '852', --Hong Kong,Hong Kong Special Administrative Region of the People's Republic of China,Hong Kong Special Administrative Region of the People's Republic of China,Hong Kong,香港中国特别行政区的人民共和国,香港
  '850', --North Korea,Democratic People's Republic of Korea,조선 민주주의 인민 공화국,북한
  '692', --Marshall Islands,Republic of the Marshall Islands,Republic of the Marshall Islands,Marshall Islands,Republic of the Marshall Islands,M̧ajeļ
  '691', --Micronesia,Federated States of Micronesia,Federated States of Micronesia,Micronesia
  '690', --Tokelau,Tokelau,Tokelau,Tokelau,Tokelau,Tokelau,Tokelau,Tokelau
  '689', --French Polynesia,French Polynesia,Polynésie française,Polynésie française
  '688', --Tuvalu,Tuvalu,Tuvalu,Tuvalu,Tuvalu,Tuvalu
  '687', --New Caledonia,New Caledonia,Nouvelle-Calédonie,Nouvelle-Calédonie
  '686', --Kiribati,Independent and Sovereign Republic of Kiribati,Independent and Sovereign Republic of Kiribati,Kiribati,Ribaberiki Kiribati,Kiribati
  '685', --Samoa,Independent State of Samoa,Independent State of Samoa,Samoa,Malo Saʻoloto Tutoʻatasi o Sāmoa,Sāmoa
  '683', --Niue,Niue,Niue,Niue,Niuē,Niuē
  '682', --Cook Islands,Cook Islands,Cook Islands,Cook Islands,Kūki 'Āirani,Kūki 'Āirani
  '681', --Wallis and Futuna,Territory of the Wallis and Futuna Islands,Territoire des îles Wallis et Futuna,Wallis et Futuna
  '680', --Palau,Republic of Palau,Republic of Palau,Palau,Beluu er a Belau,Belau
  '679', --Fiji,Republic of Fiji,Republic of Fiji,Fiji,Matanitu Tugalala o Viti,Viti,रिपब्लिक ऑफ फीजी,फिजी
  '678', --Vanuatu,Republic of Vanuatu,Ripablik blong Vanuatu,Vanuatu,Republic of Vanuatu,Vanuatu,République de Vanuatu,Vanuatu
  '677', --Solomon Islands,Solomon Islands,Solomon Islands,Solomon Islands
  '676', --Tonga,Kingdom of Tonga,Kingdom of Tonga,Tonga,Kingdom of Tonga,Tonga
  '675', --Papua New Guinea,Independent State of Papua New Guinea,Independent State of Papua New Guinea,Papua New Guinea,Independen Stet bilong Papua Niugini,Papua Niu Gini,Independen Stet bilong Papua Niugini,Papua Niugini
  '674', --Nauru,Republic of Nauru,Republic of Nauru,Nauru,Republic of Nauru,Nauru
  '673', --Brunei,Nation of Brunei, Abode of Peace,Nation of Brunei, Abode Damai,Negara Brunei Darussalam
  '672', --Norfolk Island,Territory of Norfolk Island,Territory of Norfolk Island,Norfolk Island,Teratri of Norf'k Ailen,Norf'k Ailen
  '670', --Timor-Leste,Democratic Republic of Timor-Leste,República Democrática de Timor-Leste,Timor-Leste,Repúblika Demokrátika Timór-Leste,Timór-Leste
  '598', --Uruguay,Oriental Republic of Uruguay,República Oriental del Uruguay,Uruguay
  '597', --Suriname,Republic of Suriname,Republiek Suriname,Suriname
  '596', --Martinique,Martinique,Martinique,Martinique
  '595', --Paraguay,Republic of Paraguay,Tetã Paraguái,Paraguái,República de Paraguay,Paraguay
  '594', --French Guiana,Guiana,Guyanes,Guyane française
  '593', --Ecuador,Republic of Ecuador,República del Ecuador,Ecuador
  '592', --Guyana,Co-operative Republic of Guyana,Co-operative Republic of Guyana,Guyana
  '591', --Bolivia,Plurinational State of Bolivia,Wuliwya Suyu,Wuliwya,Tetã Volívia,Volívia,Buliwya Mamallaqta,Buliwya,Estado Plurinacional de Bolivia,Bolivia
  '590', --Saint Barthélemy,Collectivity of Saint Barthélemy,Collectivité de Saint-Barthélemy,Saint-Barthélemy
  '590', --Guadeloupe,Guadeloupe,Guadeloupe,Guadeloupe
  '590', --Saint Martin,Saint Martin,Saint-Martin,Saint-Martin
  '509', --Haiti,Republic of Haiti,République d'Haïti,Haïti,Repiblik Ayiti,Ayiti
  '508', --Saint Pierre and Miquelon,Saint Pierre and Miquelon,Collectivité territoriale de Saint-Pierre-et-Miquelon,Saint-Pierre-et-Miquelon
  '507', --Panama,Republic of Panama,República de Panamá,Panamá
  '506', --Costa Rica,Republic of Costa Rica,República de Costa Rica,Costa Rica
  '505', --Nicaragua,Republic of Nicaragua,República de Nicaragua,Nicaragua
  '504', --Honduras,Republic of Honduras,República de Honduras,Honduras
  '503', --El Salvador,Republic of El Salvador,República de El Salvador,El Salvador
  '502', --Guatemala,Republic of Guatemala,República de Guatemala,Guatemala
  '501', --Belize,Belize,Belize,Belize,Belize,Belize,Belice,Belice
  '500', --Falkland Islands,Falkland Islands,Falkland Islands,Falkland Islands
  '500', --South Georgia,South Georgia and the South Sandwich Islands,South Georgia and the South Sandwich Islands,South Georgia
  '423', --Liechtenstein,Principality of Liechtenstein,Fürstentum Liechtenstein,Liechtenstein
  '421', --Slovakia,Slovak Republic,Slovenská republika,Slovensko
  '420', --Czech Republic,Czech Republic,česká republika,Česká republika,Česká republika,Česká republika
  '389', --Macedonia,Republic of Macedonia,Република Македонија,Македонија
  '387', --Bosnia and Herzegovina,Bosnia and Herzegovina,Bosna i Hercegovina,Bosna i Hercegovina,Bosna i Hercegovina,Bosna i Hercegovina,Боснa и Херцеговина,Боснa и Херцеговина
  '386', --Slovenia,Republic of Slovenia,Republika Slovenija,Slovenija
  '385', --Croatia,Republic of Croatia,Republika Hrvatska,Hrvatska
  '383', --Kosovo,Republic of Kosovo,Republika e Kosovës,Kosova,Република Косово,Косово
  '382', --Montenegro,Montenegro,Црна Гора,Црна Гора
  '381', --Serbia,Republic of Serbia,Република Србија,Србија
  '380', --Ukraine,Ukraine,Украина,Украина,Україна,Україна
  '379', --Vatican City,Vatican City State,Stato della Città del Vaticano,Vaticano,Status Civitatis Vaticanæ,Vaticanæ
  '378', --San Marino,Most Serene Republic of San Marino,Serenissima Repubblica di San Marino,San Marino
  '377', --Monaco,Principality of Monaco,Principauté de Monaco,Monaco
  '376', --Andorra,Principality of Andorra,Principat d'Andorra,Andorra
  '375', --Belarus,Republic of Belarus,Рэспубліка Беларусь,Белару́сь,Республика Беларусь,Белоруссия
  '374', --Armenia,Republic of Armenia,Հայաստանի Հանրապետություն,Հայաստան,Республика Армения,Армения
  '373', --Moldova,Republic of Moldova,Republica Moldova,Moldova
  '372', --Estonia,Republic of Estonia,Eesti Vabariik,Eesti
  '371', --Latvia,Republic of Latvia,Latvijas Republikas,Latvija
  '370', --Lithuania,Republic of Lithuania,Lietuvos Respublikos,Lietuva
  '359', --Bulgaria,Republic of Bulgaria,Република България,България
  '358', --Åland Islands,Åland Islands,Landskapet Åland,Åland
  '358', --Finland,Republic of Finland,Suomen tasavalta,Suomi,Republiken Finland,Finland
  '357', --Cyprus,Republic of Cyprus,Δημοκρατία της Κύπρος,Κύπρος,Kıbrıs Cumhuriyeti,Kıbrıs
  '356', --Malta,Republic of Malta,Republic of Malta,Malta,Repubblika ta ' Malta,Malta
  '355', --Albania,Republic of Albania,Republika e Shqipërisë,Shqipëria
  '354', --Iceland,Iceland,Ísland,Ísland
  '353', --Ireland,Republic of Ireland,Republic of Ireland,Ireland,Poblacht na hÉireann,Éire
  '352', --Luxembourg,Grand Duchy of Luxembourg,Großherzogtum Luxemburg,Luxemburg,Grand-Duché de Luxembourg,Luxembourg,Groussherzogtum Lëtzebuerg,Lëtzebuerg
  '351', --Portugal,Portuguese Republic,República português,Portugal
  '350', --Gibraltar,Gibraltar,Gibraltar,Gibraltar
  '299', --Greenland,Greenland,Kalaallit Nunaat,Kalaallit Nunaat
  '298', --Faroe Islands,Faroe Islands,Færøerne,Færøerne,Føroyar,Føroyar
  '297', --Aruba,Aruba,Aruba,Aruba,Aruba,Aruba
  '291', --Eritrea,State of Eritrea,دولة إرتريا,إرتريا‎,State of Eritrea,Eritrea,ሃገረ ኤርትራ,ኤርትራ
  '269', --Comoros,Union of the Comoros,الاتحاد القمري,القمر‎,Union des Comores,Comores,Udzima wa Komori,Komori
  '268', --Swaziland,Kingdom of Swaziland,Kingdom of Swaziland,Swaziland,Kingdom of Swaziland,Swaziland
  '267', --Botswana,Republic of Botswana,Republic of Botswana,Botswana,Lefatshe la Botswana,Botswana
  '266', --Lesotho,Kingdom of Lesotho,Kingdom of Lesotho,Lesotho,Kingdom of Lesotho,Lesotho
  '265', --Malawi,Republic of Malawi,Republic of Malawi,Malawi,Chalo cha Malawi, Dziko la Malaŵi,Malaŵi
  '264', --Namibia,Republic of Namibia,Republiek van Namibië,Namibië,Republik Namibia,Namibia,Republic of Namibia,Namibia,Republic of Namibia,Namibia,Republic of Namibia,Namibia,Republic of Namibia,Namibia,Republic of Namibia,Namibia,Republic of Namibia,Namibia,Lefatshe la Namibia,Namibia
  '263', --Zimbabwe,Republic of Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe,Republic of Zimbabwe,Zimbabwe
  '262', --Mayotte,Department of Mayotte,Département de Mayotte,Mayotte
  '262', --Réunion,Réunion Island,Ile de la Réunion,La Réunion
  '261', --Madagascar,Republic of Madagascar,République de Madagascar,Madagascar,Repoblikan'i Madagasikara,Madagasikara
  '260', --Zambia,Republic of Zambia,Republic of Zambia,Zambia
  '258', --Mozambique,Republic of Mozambique,República de Moçambique,Moçambique
  '257', --Burundi,Republic of Burundi,République du Burundi,Burundi,Republika y'Uburundi ,Uburundi
  '256', --Uganda,Republic of Uganda,Republic of Uganda,Uganda,Republic of Uganda,Uganda
  '255', --Tanzania,United Republic of Tanzania,United Republic of Tanzania,Tanzania,Jamhuri ya Muungano wa Tanzania,Tanzania
  '254', --Kenya,Republic of Kenya,Republic of Kenya,Kenya,Republic of Kenya,Kenya
  '253', --Djibouti,Republic of Djibouti,جمهورية جيبوتي,جيبوتي‎,République de Djibouti,Djibouti
  '252', --Somalia,Federal Republic of Somalia,جمهورية الصومال‎‎,الصومال‎‎,Jamhuuriyadda Federaalka Soomaaliya,Soomaaliya
  '251', --Ethiopia,Federal Democratic Republic of Ethiopia,የኢትዮጵያ ፌዴራላዊ ዲሞክራሲያዊ ሪፐብሊክ,ኢትዮጵያ
  '250', --Rwanda,Republic of Rwanda,Republic of Rwanda,Rwanda,République rwandaise,Rwanda,Repubulika y'u Rwanda,Rwanda
  '249', --Sudan,Republic of the Sudan,جمهورية السودان,السودان,Republic of the Sudan,Sudan
  '248', --Seychelles,Republic of Seychelles,Repiblik Sesel,Sesel,Republic of Seychelles,Seychelles,République des Seychelles,Seychelles
  '246', --British Indian Ocean Territory,British Indian Ocean Territory,British Indian Ocean Territory,British Indian Ocean Territory
  '245', --Guinea-Bissau,Republic of Guinea-Bissau,República da Guiné-Bissau,Guiné-Bissau
  '244', --Angola,Republic of Angola,República de Angola,Angola
  '243', --DR Congo,Democratic Republic of the Congo,République démocratique du Congo,RD Congo,Repubilika ya Kongo Demokratiki,Repubilika ya Kongo Demokratiki,Republiki ya Kongó Demokratiki,Republiki ya Kongó Demokratiki,Ditunga dia Kongu wa Mungalaata,Ditunga dia Kongu wa Mungalaata,Jamhuri ya Kidemokrasia ya Kongo,Jamhuri ya Kidemokrasia ya Kongo
  '242', --Republic of the Congo,Republic of the Congo,République du Congo,République du Congo,Repubilika ya Kongo,Repubilika ya Kongo,Republíki ya Kongó,Republíki ya Kongó
  '241', --Gabon,Gabonese Republic,République gabonaise,Gabon
  '240', --Equatorial Guinea,Republic of Equatorial Guinea,République de la Guinée Équatoriale,Guinée équatoriale,República da Guiné Equatorial,Guiné Equatorial,República de Guinea Ecuatorial,Guinea Ecuatorial
  '239', --São Tomé and Príncipe,Democratic Republic of São Tomé and Príncipe,República Democrática do São Tomé e Príncipe,São Tomé e Príncipe
  '238', --Cape Verde,Republic of Cabo Verde,República de Cabo Verde,Cabo Verde
  '237', --Cameroon,Republic of Cameroon,Republic of Cameroon,Cameroon,République du Cameroun,Cameroun
  '236', --Central African Republic,Central African Republic,République centrafricaine,République centrafricaine,Ködörösêse tî Bêafrîka,Bêafrîka
  '235', --Chad,Republic of Chad,جمهورية تشاد,تشاد‎,République du Tchad,Tchad
  '234', --Nigeria,Federal Republic of Nigeria,Federal Republic of Nigeria,Nigeria
  '233', --Ghana,Republic of Ghana,Republic of Ghana,Ghana
  '232', --Sierra Leone,Republic of Sierra Leone,Republic of Sierra Leone,Sierra Leone
  '231', --Liberia,Republic of Liberia,Republic of Liberia,Liberia
  '230', --Mauritius,Republic of Mauritius,Republic of Mauritius,Mauritius,République de Maurice,Maurice,Republik Moris,Moris
  '229', --Benin,Republic of Benin,République du Bénin,Bénin
  '228', --Togo,Togolese Republic,République togolaise,Togo
  '227', --Niger,Republic of Niger,République du Niger,Niger
  '226', --Burkina Faso,Burkina Faso,République du Burkina,Burkina Faso
  '225', --Ivory Coast,Republic of Côte d'Ivoire,République de Côte d'Ivoire,Côte d'Ivoire
  '224', --Guinea,Republic of Guinea,République de Guinée,Guinée
  '223', --Mali,Republic of Mali,République du Mali,Mali
  '222', --Mauritania,Islamic Republic of Mauritania,الجمهورية الإسلامية الموريتانية,موريتانيا
  '221', --Senegal,Republic of Senegal,République du Sénégal,Sénégal
  '220', --Gambia,Republic of the Gambia,Republic of the Gambia,Gambia
  '218', --Libya,State of Libya,الدولة ليبيا,‏ليبيا
  '216', --Tunisia,Tunisian Republic,الجمهورية التونسية,تونس
  '213', --Algeria,People's Democratic Republic of Algeria,الجمهورية الديمقراطية الشعبية الجزائرية,الجزائر
  '212', --Western Sahara,Sahrawi Arab Democratic Republic,Sahrawi Arab Democratic Republic,Western Sahara,الجمهورية العربية الصحراوية الديمقراطية,الصحراء الغربية,República Árabe Saharaui Democrática,Sahara Occidental
  '212', --Morocco,Kingdom of Morocco,المملكة المغربية,المغرب,ⵜⴰⴳⵍⴷⵉⵜ ⵏ ⵍⵎⵖⵔⵉⴱ,ⵍⵎⴰⵖⵔⵉⴱ
  '211', --South Sudan,Republic of South Sudan,Republic of South Sudan,South Sudan
  '98', --Iran,Islamic Republic of Iran,جمهوری اسلامی ایران,ایران
  '95', --Myanmar,Republic of the Union of Myanmar,ပြည်ထောင်စု သမ္မတ မြန်မာနိုင်ငံတော်,မြန်မာ
  '94', --Sri Lanka,Democratic Socialist Republic of Sri Lanka,ශ්‍රී ලංකා ප්‍රජාතාන්ත්‍රික සමාජවාදී ජනරජය,ශ්‍රී ලංකාව,இலங்கை சனநாயக சோசலிசக் குடியரசு,இலங்கை
  '93', --Afghanistan,Islamic Republic of Afghanistan,جمهوری اسلامی افغانستان,افغانستان,د افغانستان اسلامي جمهوریت,افغانستان,Owganystan Yslam Respublikasy,Owganystan
  '92', --Pakistan,Islamic Republic of Pakistan,Islamic Republic of Pakistan,Pakistan,اسلامی جمہوریۂ پاكستان,پاكستان
  '91', --India,Republic of India,Republic of India,India,भारत गणराज्य,भारत,இந்தியக் குடியரசு,இந்தியா
  '90', --Turkey,Republic of Turkey,Türkiye Cumhuriyeti,Türkiye
  '86', --China,People's Republic of China,中华人民共和国,中国
  '84', --Vietnam,Socialist Republic of Vietnam,Cộng hòa xã hội chủ nghĩa Việt Nam,Việt Nam
  '82', --South Korea,Republic of Korea,한국,대한민국
  '81', --Japan,Japan,日本,日本
  '77', --Kazakhstan,Republic of Kazakhstan,Қазақстан Республикасы,Қазақстан,Республика Казахстан,Казахстан
  '76', --Kazakhstan,Republic of Kazakhstan,Қазақстан Республикасы,Қазақстан,Республика Казахстан,Казахстан
  '66', --Thailand,Kingdom of Thailand,ราชอาณาจักรไทย,ประเทศไทย
  '65', --Singapore,Republic of Singapore,新加坡共和国,新加坡,Republic of Singapore,Singapore,Republik Singapura,Singapura,சிங்கப்பூர் குடியரசு,சிங்கப்பூர்
  '64', --New Zealand,New Zealand,New Zealand,New Zealand,Aotearoa,Aotearoa,New Zealand,New Zealand
  '64', --Pitcairn Islands,Pitcairn Group of Islands,Pitcairn Group of Islands,Pitcairn Islands
  '63', --Philippines,Republic of the Philippines,Republic of the Philippines,Philippines,Republic of the Philippines,Pilipinas
  '62', --Indonesia,Republic of Indonesia,Republik Indonesia,Indonesia
  '61', --Australia,Commonwealth of Australia,Commonwealth of Australia,Australia
  '61', --Cocos (Keeling) Islands,Territory of the Cocos (Keeling) Islands,Territory of the Cocos (Keeling) Islands,Cocos (Keeling) Islands
  '61', --Christmas Island,Territory of Christmas Island,Territory of Christmas Island,Christmas Island
  '60', --Malaysia,Malaysia,Malaysia,Malaysia,مليسيا,مليسيا
  '58', --Venezuela,Bolivarian Republic of Venezuela,República Bolivariana de Venezuela,Venezuela
  '57', --Colombia,Republic of Colombia,República de Colombia,Colombia
  '56', --Chile,Republic of Chile,República de Chile,Chile
  '55', --Brazil,Federative Republic of Brazil,República Federativa do Brasil,Brasil
  '54', --Argentina,Argentine Republic,Argentine Republic,Argentina,República Argentina,Argentina
  '53', --Cuba,Republic of Cuba,República de Cuba,Cuba
  '52', --Mexico,United Mexican States,Estados Unidos Mexicanos,México
  '51', --Peru,Republic of Peru,Piruw Suyu,Piruw,Piruw Ripuwlika,Piruw,República del Perú,Perú
  '49', --Germany,Federal Republic of Germany,Bundesrepublik Deutschland,Deutschland
  '48', --Poland,Republic of Poland,Rzeczpospolita Polska,Polska
  '47', --Norway,Kingdom of Norway,Kongeriket Noreg,Noreg,Kongeriket Norge,Norge,Norgga gonagasriika,Norgga
  '46', --Sweden,Kingdom of Sweden,Konungariket Sverige,Sverige
  '45', --Denmark,Kingdom of Denmark,Kongeriget Danmark,Danmark
  '44', --United Kingdom,United Kingdom of Great Britain and Northern Ireland,United Kingdom of Great Britain and Northern Ireland,United Kingdom
  '44', --Guernsey,Bailiwick of Guernsey,Bailiwick of Guernsey,Guernsey,Bailliage de Guernesey,Guernesey,Dgèrnésiais,Dgèrnésiais
  '44', --Isle of Man,Isle of Man,Isle of Man,Isle of Man,Ellan Vannin or Mannin,Mannin
  '44', --Jersey,Bailiwick of Jersey,Bailiwick of Jersey,Jersey,Bailliage de Jersey,Jersey,Bailliage dé Jèrri,Jèrri
  '43', --Austria,Republic of Austria,Republik Österreich,Österreich
  '41', --Switzerland,Swiss Confederation,Confédération suisse,Suisse,Schweizerische Eidgenossenschaft,Schweiz,Confederazione Svizzera,Svizzera,Confederaziun svizra,Svizra
  '40', --Romania,Romania,România,România
  '39', --Italy,Italian Republic,Italienische Republik,Italien,Repubblica italiana,Italia,Repubbricanu Italia,Italia
  '36', --Hungary,Hungary,Magyarország,Magyarország
  '34', --Spain,Kingdom of Spain,Regne d'Espanya,Espanya,Espainiako Erresuma,Espainia,Reino de España,Reialme d'Espanha,Espanha,Reino de España,España
  '33', --France,French Republic,République française,France
  '32', --Belgium,Kingdom of Belgium,Königreich Belgien,Belgien,Royaume de Belgique,Belgique,Koninkrijk België,België
  '31', --Netherlands,Netherlands,Nederland,Nederland
  '30', --Greece,Hellenic Republic,Ελληνική Δημοκρατία,Ελλάδα
  '27', --South Africa,Republic of South Africa,Republiek van Suid-Afrika,South Africa,Republic of South Africa,South Africa,IRiphabliki yeSewula Afrika,Sewula Afrika,Rephaboliki ya Afrika-Borwa ,Afrika-Borwa,Rephaboliki ya Afrika Borwa,Afrika Borwa,IRiphabhulikhi yeNingizimu Afrika,Ningizimu Afrika,Rephaboliki ya Aforika Borwa,Aforika Borwa,Riphabliki ra Afrika Dzonga,Afrika Dzonga,Riphabuḽiki ya Afurika Tshipembe,Afurika Tshipembe,IRiphabliki yaseMzantsi Afrika,Mzantsi Afrika,IRiphabliki yaseNingizimu Afrika,Ningizimu Afrika
  '20', --Egypt,Arab Republic of Egypt,جمهورية مصر العربية,مصر
  '7' --Russia,Russian Federation,Русская Федерация,Россия
  ];
  c           TEXT;
  digits_only TEXT;
BEGIN
  digits_only := regexp_replace(value, '[^\d]*', '', 'g');

  IF char_length(digits_only) = 10
  THEN
    code := '1';
    number := digits_only;
  ELSEIF char_length(digits_only) = 11 AND substring(digits_only FROM 1 FOR 1) = '1'
    THEN
      code := '1';
      number := substring(digits_only FROM 2 FOR 10);
  ELSE

    IF char_length(digits_only) < 8
    THEN
      RETURN NULL;
    END IF;

    FOR i IN 1 .. array_upper(all_codes, 1) LOOP
      c := all_codes [i];
      IF substring(digits_only FROM 1 FOR char_length(c)) = c
      THEN
        code := c;
        number := substring(digits_only FROM char_length(c) + 1 FOR char_length(digits_only));
      END IF;
    END LOOP;
  END IF;

  IF code IS NOT NULL AND number IS NOT NULL
  THEN
    RETURN ARRAY [code, number];
  END IF;

  RETURN NULL;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE
SECURITY DEFINER
COST 10;
