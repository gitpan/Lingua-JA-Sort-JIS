package Lingua::JA::Sort::JIS;

use strict;

use Carp;

use vars qw($VERSION $PACKAGE @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

require Exporter;

@ISA = qw(Exporter);

my @Sort = qw/jsort fsort msort xsort bsort/;
my @Cmp  = qw/jcmp karr kcmp/;
my @Get  = qw/getorder getkanji/;

@EXPORT = qw();

@EXPORT_OK = (@Sort, @Cmp, @Get);

%EXPORT_TAGS = (
  sort => \@Sort,
  cmp  => \@Cmp,
  get  => \@Get,
);

$VERSION = '0.02';

$PACKAGE = __PACKAGE__;

my $Level = 4;
my $Kanji = 2;

sub new {
  my $coderef = undef;
  my $class = shift;
  if(ref $_[0] eq 'CODE'){ $coderef = shift }
  my $level = shift || $Level;
  my $kanji = shift || $Kanji;
  return bless {
    code  => $coderef,
    level => $level,
    kanji => $kanji,
  }, $class;
}

my $Char = 
   '\xEF\xBD[\xB3\xB6-\xBF]\xEF\xBE\x9E|'
 . '\xEF\xBE[\x80-\x84]\xEF\xBE\x9E|'
 . '\xEF\xBE[\x8A-\x8E]\xEF\xBE[\x9E\x9F]|'
 . '[\x00-\x7F]|[\xC2-\xDF][\x80-\xBF]|'
 . '\xE0[\xA0-\xBF][\x80-\xBF]|'
 . '[\xE1-\xEF][\x80-\xBF][\x80-\xBF]|'
 . '\xF0[\x90-\xBF][\x80-\xBF][\x80-\xBF]|'
 . '[\xF1-\xF3][\x80-\xBF][\x80-\xBF][\x80-\xBF]|'
 . '\xF4[\x80-\x8F][\x80-\xBF][\x80-\xBF]';
my $CJK = '\xE4[\xB8-\xBF][\x80-\xBF]|[\xE5-\xE9][\x80-\xBF][\x80-\xBF]';

my $JISkanji = <<'EOF';
亜唖娃阿哀愛挨姶逢葵茜穐悪握渥旭葦芦鯵梓圧斡扱宛姐虻飴絢綾鮎
或粟袷安庵按暗案闇鞍杏以伊位依偉囲夷委威尉惟意慰易椅為畏異移
維緯胃萎衣謂違遺医井亥域育郁磯一壱溢逸稲茨芋鰯允印咽員因姻引
飲淫胤蔭院陰隠韻吋右宇烏羽迂雨卯鵜窺丑碓臼渦嘘唄欝蔚鰻姥厩浦
瓜閏噂云運雲荏餌叡営嬰影映曳栄永泳洩瑛盈穎頴英衛詠鋭液疫益駅
悦謁越閲榎厭円園堰奄宴延怨掩援沿演炎焔煙燕猿縁艶苑薗遠鉛鴛塩
於汚甥凹央奥往応押旺横欧殴王翁襖鴬鴎黄岡沖荻億屋憶臆桶牡乙俺
卸恩温穏音下化仮何伽価佳加可嘉夏嫁家寡科暇果架歌河火珂禍禾稼
箇花苛茄荷華菓蝦課嘩貨迦過霞蚊俄峨我牙画臥芽蛾賀雅餓駕介会解
回塊壊廻快怪悔恢懐戒拐改魁晦械海灰界皆絵芥蟹開階貝凱劾外咳害
崖慨概涯碍蓋街該鎧骸浬馨蛙垣柿蛎鈎劃嚇各廓拡撹格核殻獲確穫覚
角赫較郭閣隔革学岳楽額顎掛笠樫橿梶鰍潟割喝恰括活渇滑葛褐轄且
鰹叶椛樺鞄株兜竃蒲釜鎌噛鴨栢茅萱粥刈苅瓦乾侃冠寒刊勘勧巻喚堪
姦完官寛干幹患感慣憾換敢柑桓棺款歓汗漢澗潅環甘監看竿管簡緩缶
翰肝艦莞観諌貫還鑑間閑関陥韓館舘丸含岸巌玩癌眼岩翫贋雁頑顔願
企伎危喜器基奇嬉寄岐希幾忌揮机旗既期棋棄機帰毅気汽畿祈季稀紀
徽規記貴起軌輝飢騎鬼亀偽儀妓宜戯技擬欺犠疑祇義蟻誼議掬菊鞠吉
吃喫桔橘詰砧杵黍却客脚虐逆丘久仇休及吸宮弓急救朽求汲泣灸球究
窮笈級糾給旧牛去居巨拒拠挙渠虚許距鋸漁禦魚亨享京供侠僑兇競共
凶協匡卿叫喬境峡強彊怯恐恭挟教橋況狂狭矯胸脅興蕎郷鏡響饗驚仰
凝尭暁業局曲極玉桐粁僅勤均巾錦斤欣欽琴禁禽筋緊芹菌衿襟謹近金
吟銀九倶句区狗玖矩苦躯駆駈駒具愚虞喰空偶寓遇隅串櫛釧屑屈掘窟
沓靴轡窪熊隈粂栗繰桑鍬勲君薫訓群軍郡卦袈祁係傾刑兄啓圭珪型契
形径恵慶慧憩掲携敬景桂渓畦稽系経継繋罫茎荊蛍計詣警軽頚鶏芸迎
鯨劇戟撃激隙桁傑欠決潔穴結血訣月件倹倦健兼券剣喧圏堅嫌建憲懸
拳捲検権牽犬献研硯絹県肩見謙賢軒遣鍵険顕験鹸元原厳幻弦減源玄
現絃舷言諺限乎個古呼固姑孤己庫弧戸故枯湖狐糊袴股胡菰虎誇跨鈷
雇顧鼓五互伍午呉吾娯後御悟梧檎瑚碁語誤護醐乞鯉交佼侯候倖光公
功効勾厚口向后喉坑垢好孔孝宏工巧巷幸広庚康弘恒慌抗拘控攻昂晃
更杭校梗構江洪浩港溝甲皇硬稿糠紅紘絞綱耕考肯肱腔膏航荒行衡講
貢購郊酵鉱砿鋼閤降項香高鴻剛劫号合壕拷濠豪轟麹克刻告国穀酷鵠
黒獄漉腰甑忽惚骨狛込此頃今困坤墾婚恨懇昏昆根梱混痕紺艮魂些佐
叉唆嵯左差査沙瑳砂詐鎖裟坐座挫債催再最哉塞妻宰彩才採栽歳済災
采犀砕砦祭斎細菜裁載際剤在材罪財冴坂阪堺榊肴咲崎埼碕鷺作削咋
搾昨朔柵窄策索錯桜鮭笹匙冊刷察拶撮擦札殺薩雑皐鯖捌錆鮫皿晒三
傘参山惨撒散桟燦珊産算纂蚕讃賛酸餐斬暫残仕仔伺使刺司史嗣四士
始姉姿子屍市師志思指支孜斯施旨枝止死氏獅祉私糸紙紫肢脂至視詞
詩試誌諮資賜雌飼歯事似侍児字寺慈持時次滋治爾璽痔磁示而耳自蒔
辞汐鹿式識鴫竺軸宍雫七叱執失嫉室悉湿漆疾質実蔀篠偲柴芝屡蕊縞
舎写射捨赦斜煮社紗者謝車遮蛇邪借勺尺杓灼爵酌釈錫若寂弱惹主取
守手朱殊狩珠種腫趣酒首儒受呪寿授樹綬需囚収周宗就州修愁拾洲秀
秋終繍習臭舟蒐衆襲讐蹴輯週酋酬集醜什住充十従戎柔汁渋獣縦重銃
叔夙宿淑祝縮粛塾熟出術述俊峻春瞬竣舜駿准循旬楯殉淳準潤盾純巡
遵醇順処初所暑曙渚庶緒署書薯藷諸助叙女序徐恕鋤除傷償勝匠升召
哨商唱嘗奨妾娼宵将小少尚庄床廠彰承抄招掌捷昇昌昭晶松梢樟樵沼
消渉湘焼焦照症省硝礁祥称章笑粧紹肖菖蒋蕉衝裳訟証詔詳象賞醤鉦
鍾鐘障鞘上丈丞乗冗剰城場壌嬢常情擾条杖浄状畳穣蒸譲醸錠嘱埴飾
拭植殖燭織職色触食蝕辱尻伸信侵唇娠寝審心慎振新晋森榛浸深申疹
真神秦紳臣芯薪親診身辛進針震人仁刃塵壬尋甚尽腎訊迅陣靭笥諏須
酢図厨逗吹垂帥推水炊睡粋翠衰遂酔錐錘随瑞髄崇嵩数枢趨雛据杉椙
菅頗雀裾澄摺寸世瀬畝是凄制勢姓征性成政整星晴棲栖正清牲生盛精
聖声製西誠誓請逝醒青静斉税脆隻席惜戚斥昔析石積籍績脊責赤跡蹟
碩切拙接摂折設窃節説雪絶舌蝉仙先千占宣専尖川戦扇撰栓栴泉浅洗
染潜煎煽旋穿箭線繊羨腺舛船薦詮賎践選遷銭銑閃鮮前善漸然全禅繕
膳糎噌塑岨措曾曽楚狙疏疎礎祖租粗素組蘇訴阻遡鼠僧創双叢倉喪壮
奏爽宋層匝惣想捜掃挿掻操早曹巣槍槽漕燥争痩相窓糟総綜聡草荘葬
蒼藻装走送遭鎗霜騒像増憎臓蔵贈造促側則即息捉束測足速俗属賊族
続卒袖其揃存孫尊損村遜他多太汰詑唾堕妥惰打柁舵楕陀駄騨体堆対
耐岱帯待怠態戴替泰滞胎腿苔袋貸退逮隊黛鯛代台大第醍題鷹滝瀧卓
啄宅托択拓沢濯琢託鐸濁諾茸凧蛸只叩但達辰奪脱巽竪辿棚谷狸鱈樽
誰丹単嘆坦担探旦歎淡湛炭短端箪綻耽胆蛋誕鍛団壇弾断暖檀段男談
値知地弛恥智池痴稚置致蜘遅馳築畜竹筑蓄逐秩窒茶嫡着中仲宙忠抽
昼柱注虫衷註酎鋳駐樗瀦猪苧著貯丁兆凋喋寵帖帳庁弔張彫徴懲挑暢
朝潮牒町眺聴脹腸蝶調諜超跳銚長頂鳥勅捗直朕沈珍賃鎮陳津墜椎槌
追鎚痛通塚栂掴槻佃漬柘辻蔦綴鍔椿潰坪壷嬬紬爪吊釣鶴亭低停偵剃
貞呈堤定帝底庭廷弟悌抵挺提梯汀碇禎程締艇訂諦蹄逓邸鄭釘鼎泥摘
擢敵滴的笛適鏑溺哲徹撤轍迭鉄典填天展店添纏甜貼転顛点伝殿澱田
電兎吐堵塗妬屠徒斗杜渡登菟賭途都鍍砥砺努度土奴怒倒党冬凍刀唐
塔塘套宕島嶋悼投搭東桃梼棟盗淘湯涛灯燈当痘祷等答筒糖統到董蕩
藤討謄豆踏逃透鐙陶頭騰闘働動同堂導憧撞洞瞳童胴萄道銅峠鴇匿得
徳涜特督禿篤毒独読栃橡凸突椴届鳶苫寅酉瀞噸屯惇敦沌豚遁頓呑曇
鈍奈那内乍凪薙謎灘捺鍋楢馴縄畷南楠軟難汝二尼弐迩匂賑肉虹廿日
乳入如尿韮任妊忍認濡禰祢寧葱猫熱年念捻撚燃粘乃廼之埜嚢悩濃納
能脳膿農覗蚤巴把播覇杷波派琶破婆罵芭馬俳廃拝排敗杯盃牌背肺輩
配倍培媒梅楳煤狽買売賠陪這蝿秤矧萩伯剥博拍柏泊白箔粕舶薄迫曝
漠爆縛莫駁麦函箱硲箸肇筈櫨幡肌畑畠八鉢溌発醗髪伐罰抜筏閥鳩噺
塙蛤隼伴判半反叛帆搬斑板氾汎版犯班畔繁般藩販範釆煩頒飯挽晩番
盤磐蕃蛮匪卑否妃庇彼悲扉批披斐比泌疲皮碑秘緋罷肥被誹費避非飛
樋簸備尾微枇毘琵眉美鼻柊稗匹疋髭彦膝菱肘弼必畢筆逼桧姫媛紐百
謬俵彪標氷漂瓢票表評豹廟描病秒苗錨鋲蒜蛭鰭品彬斌浜瀕貧賓頻敏
瓶不付埠夫婦富冨布府怖扶敷斧普浮父符腐膚芙譜負賦赴阜附侮撫武
舞葡蕪部封楓風葺蕗伏副復幅服福腹複覆淵弗払沸仏物鮒分吻噴墳憤
扮焚奮粉糞紛雰文聞丙併兵塀幣平弊柄並蔽閉陛米頁僻壁癖碧別瞥蔑
箆偏変片篇編辺返遍便勉娩弁鞭保舗鋪圃捕歩甫補輔穂募墓慕戊暮母
簿菩倣俸包呆報奉宝峰峯崩庖抱捧放方朋法泡烹砲縫胞芳萌蓬蜂褒訪
豊邦鋒飽鳳鵬乏亡傍剖坊妨帽忘忙房暴望某棒冒紡肪膨謀貌貿鉾防吠
頬北僕卜墨撲朴牧睦穆釦勃没殆堀幌奔本翻凡盆摩磨魔麻埋妹昧枚毎
哩槙幕膜枕鮪柾鱒桝亦俣又抹末沫迄侭繭麿万慢満漫蔓味未魅巳箕岬
密蜜湊蓑稔脈妙粍民眠務夢無牟矛霧鵡椋婿娘冥名命明盟迷銘鳴姪牝
滅免棉綿緬面麺摸模茂妄孟毛猛盲網耗蒙儲木黙目杢勿餅尤戻籾貰問
悶紋門匁也冶夜爺耶野弥矢厄役約薬訳躍靖柳薮鑓愉愈油癒諭輸唯佑
優勇友宥幽悠憂揖有柚湧涌猶猷由祐裕誘遊邑郵雄融夕予余与誉輿預
傭幼妖容庸揚揺擁曜楊様洋溶熔用窯羊耀葉蓉要謡踊遥陽養慾抑欲沃
浴翌翼淀羅螺裸来莱頼雷洛絡落酪乱卵嵐欄濫藍蘭覧利吏履李梨理璃
痢裏裡里離陸律率立葎掠略劉流溜琉留硫粒隆竜龍侶慮旅虜了亮僚両
凌寮料梁涼猟療瞭稜糧良諒遼量陵領力緑倫厘林淋燐琳臨輪隣鱗麟瑠
塁涙累類令伶例冷励嶺怜玲礼苓鈴隷零霊麗齢暦歴列劣烈裂廉恋憐漣
煉簾練聯蓮連錬呂魯櫓炉賂路露労婁廊弄朗楼榔浪漏牢狼篭老聾蝋郎
六麓禄肋録論倭和話歪賄脇惑枠鷲亙亘鰐詫藁蕨椀湾碗腕弌丐丕个丱
丶丼丿乂乖乘亂亅豫亊舒弍于亞亟亠亢亰亳亶从仍仄仆仂仗仞仭仟价
伉佚估佛佝佗佇佶侈侏侘佻佩佰侑佯來侖儘俔俟俎俘俛俑俚俐俤俥倚
倨倔倪倥倅伜俶倡倩倬俾俯們倆偃假會偕偐偈做偖偬偸傀傚傅傴傲僉
僊傳僂僖僞僥僭僣僮價僵儉儁儂儖儕儔儚儡儺儷儼儻儿兀兒兌兔兢竸
兩兪兮冀冂囘册冉冏冑冓冕冖冤冦冢冩冪冫决冱冲冰况冽凅凉凛几處
凩凭凰凵凾刄刋刔刎刧刪刮刳刹剏剄剋剌剞剔剪剴剩剳剿剽劍劔劒剱
劈劑辨辧劬劭劼劵勁勍勗勞勣勦飭勠勳勵勸勹匆匈甸匍匐匏匕匚匣匯
匱匳匸區卆卅丗卉卍凖卞卩卮夘卻卷厂厖厠厦厥厮厰厶參簒雙叟曼燮
叮叨叭叺吁吽呀听吭吼吮吶吩吝呎咏呵咎呟呱呷呰咒呻咀呶咄咐咆哇
咢咸咥咬哄哈咨咫哂咤咾咼哘哥哦唏唔哽哮哭哺哢唹啀啣啌售啜啅啖
啗唸唳啝喙喀咯喊喟啻啾喘喞單啼喃喩喇喨嗚嗅嗟嗄嗜嗤嗔嘔嗷嘖嗾
嗽嘛嗹噎噐營嘴嘶嘲嘸噫噤嘯噬噪嚆嚀嚊嚠嚔嚏嚥嚮嚶嚴囂嚼囁囃囀
囈囎囑囓囗囮囹圀囿圄圉圈國圍圓團圖嗇圜圦圷圸坎圻址坏坩埀垈坡
坿垉垓垠垳垤垪垰埃埆埔埒埓堊埖埣堋堙堝塲堡塢塋塰毀塒堽塹墅墹
墟墫墺壞墻墸墮壅壓壑壗壙壘壥壜壤壟壯壺壹壻壼壽夂夊夐夛梦夥夬
夭夲夸夾竒奕奐奎奚奘奢奠奧奬奩奸妁妝佞侫妣妲姆姨姜妍姙姚娥娟
娑娜娉娚婀婬婉娵娶婢婪媚媼媾嫋嫂媽嫣嫗嫦嫩嫖嫺嫻嬌嬋嬖嬲嫐嬪
嬶嬾孃孅孀孑孕孚孛孥孩孰孳孵學斈孺宀它宦宸寃寇寉寔寐寤實寢寞
寥寫寰寶寳尅將專對尓尠尢尨尸尹屁屆屎屓屐屏孱屬屮乢屶屹岌岑岔
妛岫岻岶岼岷峅岾峇峙峩峽峺峭嶌峪崋崕崗嵜崟崛崑崔崢崚崙崘嵌嵒
嵎嵋嵬嵳嵶嶇嶄嶂嶢嶝嶬嶮嶽嶐嶷嶼巉巍巓巒巖巛巫已巵帋帚帙帑帛
帶帷幄幃幀幎幗幔幟幢幤幇幵并幺麼广庠廁廂廈廐廏廖廣廝廚廛廢廡
廨廩廬廱廳廰廴廸廾弃弉彝彜弋弑弖弩弭弸彁彈彌彎弯彑彖彗彙彡彭
彳彷徃徂彿徊很徑徇從徙徘徠徨徭徼忖忻忤忸忱忝悳忿怡恠怙怐怩怎
怱怛怕怫怦怏怺恚恁恪恷恟恊恆恍恣恃恤恂恬恫恙悁悍惧悃悚悄悛悖
悗悒悧悋惡悸惠惓悴忰悽惆悵惘慍愕愆惶惷愀惴惺愃愡惻惱愍愎慇愾
愨愧慊愿愼愬愴愽慂慄慳慷慘慙慚慫慴慯慥慱慟慝慓慵憙憖憇憬憔憚
憊憑憫憮懌懊應懷懈懃懆憺懋罹懍懦懣懶懺懴懿懽懼懾戀戈戉戍戌戔
戛戞戡截戮戰戲戳扁扎扞扣扛扠扨扼抂抉找抒抓抖拔抃抔拗拑抻拏拿
拆擔拈拜拌拊拂拇抛拉挌拮拱挧挂挈拯拵捐挾捍搜捏掖掎掀掫捶掣掏
掉掟掵捫捩掾揩揀揆揣揉插揶揄搖搴搆搓搦搶攝搗搨搏摧摯摶摎攪撕
撓撥撩撈撼據擒擅擇撻擘擂擱擧舉擠擡抬擣擯攬擶擴擲擺攀擽攘攜攅
攤攣攫攴攵攷收攸畋效敖敕敍敘敞敝敲數斂斃變斛斟斫斷旃旆旁旄旌
旒旛旙无旡旱杲昊昃旻杳昵昶昴昜晏晄晉晁晞晝晤晧晨晟晢晰暃暈暎
暉暄暘暝曁暹曉暾暼曄暸曖曚曠昿曦曩曰曵曷朏朖朞朦朧霸朮朿朶杁
朸朷杆杞杠杙杣杤枉杰枩杼杪枌枋枦枡枅枷柯枴柬枳柩枸柤柞柝柢柮
枹柎柆柧檜栞框栩桀桍栲桎梳栫桙档桷桿梟梏梭梔條梛梃檮梹桴梵梠
梺椏梍桾椁棊椈棘椢椦棡椌棍棔棧棕椶椒椄棗棣椥棹棠棯椨椪椚椣椡
棆楹楷楜楸楫楔楾楮椹楴椽楙椰楡楞楝榁楪榲榮槐榿槁槓榾槎寨槊槝
榻槃榧樮榑榠榜榕榴槞槨樂樛槿權槹槲槧樅榱樞槭樔槫樊樒櫁樣樓橄
樌橲樶橸橇橢橙橦橈樸樢檐檍檠檄檢檣檗蘗檻櫃櫂檸檳檬櫞櫑櫟檪櫚
櫪櫻欅蘖櫺欒欖鬱欟欸欷盜欹飮歇歃歉歐歙歔歛歟歡歸歹歿殀殄殃殍
殘殕殞殤殪殫殯殲殱殳殷殼毆毋毓毟毬毫毳毯麾氈氓气氛氤氣汞汕汢
汪沂沍沚沁沛汾汨汳沒沐泄泱泓沽泗泅泝沮沱沾沺泛泯泙泪洟衍洶洫
洽洸洙洵洳洒洌浣涓浤浚浹浙涎涕濤涅淹渕渊涵淇淦涸淆淬淞淌淨淒
淅淺淙淤淕淪淮渭湮渮渙湲湟渾渣湫渫湶湍渟湃渺湎渤滿渝游溂溪溘
滉溷滓溽溯滄溲滔滕溏溥滂溟潁漑灌滬滸滾漿滲漱滯漲滌漾漓滷澆潺
潸澁澀潯潛濳潭澂潼潘澎澑濂潦澳澣澡澤澹濆澪濟濕濬濔濘濱濮濛瀉
瀋濺瀑瀁瀏濾瀛瀚潴瀝瀘瀟瀰瀾瀲灑灣炙炒炯烱炬炸炳炮烟烋烝烙焉
烽焜焙煥煕熈煦煢煌煖煬熏燻熄熕熨熬燗熹熾燒燉燔燎燠燬燧燵燼燹
燿爍爐爛爨爭爬爰爲爻爼爿牀牆牋牘牴牾犂犁犇犒犖犢犧犹犲狃狆狄
狎狒狢狠狡狹狷倏猗猊猜猖猝猴猯猩猥猾獎獏默獗獪獨獰獸獵獻獺珈
玳珎玻珀珥珮珞璢琅瑯琥珸琲琺瑕琿瑟瑙瑁瑜瑩瑰瑣瑪瑶瑾璋璞璧瓊
瓏瓔珱瓠瓣瓧瓩瓮瓲瓰瓱瓸瓷甄甃甅甌甎甍甕甓甞甦甬甼畄畍畊畉畛
畆畚畩畤畧畫畭畸當疆疇畴疊疉疂疔疚疝疥疣痂疳痃疵疽疸疼疱痍痊
痒痙痣痞痾痿痼瘁痰痺痲痳瘋瘍瘉瘟瘧瘠瘡瘢瘤瘴瘰瘻癇癈癆癜癘癡
癢癨癩癪癧癬癰癲癶癸發皀皃皈皋皎皖皓皙皚皰皴皸皹皺盂盍盖盒盞
盡盥盧盪蘯盻眈眇眄眩眤眞眥眦眛眷眸睇睚睨睫睛睥睿睾睹瞎瞋瞑瞠
瞞瞰瞶瞹瞿瞼瞽瞻矇矍矗矚矜矣矮矼砌砒礦砠礪硅碎硴碆硼碚碌碣碵
碪碯磑磆磋磔碾碼磅磊磬磧磚磽磴礇礒礑礙礬礫祀祠祗祟祚祕祓祺祿
禊禝禧齋禪禮禳禹禺秉秕秧秬秡秣稈稍稘稙稠稟禀稱稻稾稷穃穗穉穡
穢穩龝穰穹穽窈窗窕窘窖窩竈窰窶竅竄窿邃竇竊竍竏竕竓站竚竝竡竢
竦竭竰笂笏笊笆笳笘笙笞笵笨笶筐筺笄筍笋筌筅筵筥筴筧筰筱筬筮箝
箘箟箍箜箚箋箒箏筝箙篋篁篌篏箴篆篝篩簑簔篦篥籠簀簇簓篳篷簗簍
篶簣簧簪簟簷簫簽籌籃籔籏籀籐籘籟籤籖籥籬籵粃粐粤粭粢粫粡粨粳
粲粱粮粹粽糀糅糂糘糒糜糢鬻糯糲糴糶糺紆紂紜紕紊絅絋紮紲紿紵絆
絳絖絎絲絨絮絏絣經綉絛綏絽綛綺綮綣綵緇綽綫總綢綯緜綸綟綰緘緝
緤緞緻緲緡縅縊縣縡縒縱縟縉縋縢繆繦縻縵縹繃縷縲縺繧繝繖繞繙繚
繹繪繩繼繻纃緕繽辮繿纈纉續纒纐纓纔纖纎纛纜缸缺罅罌罍罎罐网罕
罔罘罟罠罨罩罧罸羂羆羃羈羇羌羔羞羝羚羣羯羲羹羮羶羸譱翅翆翊翕
翔翡翦翩翳翹飜耆耄耋耒耘耙耜耡耨耿耻聊聆聒聘聚聟聢聨聳聲聰聶
聹聽聿肄肆肅肛肓肚肭冐肬胛胥胙胝胄胚胖脉胯胱脛脩脣脯腋隋腆脾
腓腑胼腱腮腥腦腴膃膈膊膀膂膠膕膤膣腟膓膩膰膵膾膸膽臀臂膺臉臍
臑臙臘臈臚臟臠臧臺臻臾舁舂舅與舊舍舐舖舩舫舸舳艀艙艘艝艚艟艤
艢艨艪艫舮艱艷艸艾芍芒芫芟芻芬苡苣苟苒苴苳苺莓范苻苹苞茆苜茉
苙茵茴茖茲茱荀茹荐荅茯茫茗茘莅莚莪莟莢莖茣莎莇莊荼莵荳荵莠莉
莨菴萓菫菎菽萃菘萋菁菷萇菠菲萍萢萠莽萸蔆菻葭萪萼蕚蒄葷葫蒭葮
蒂葩葆萬葯葹萵蓊葢蒹蒿蒟蓙蓍蒻蓚蓐蓁蓆蓖蒡蔡蓿蓴蔗蔘蔬蔟蔕蔔
蓼蕀蕣蕘蕈蕁蘂蕋蕕薀薤薈薑薊薨蕭薔薛藪薇薜蕷蕾薐藉薺藏薹藐藕
藝藥藜藹蘊蘓蘋藾藺蘆蘢蘚蘰蘿虍乕虔號虧虱蚓蚣蚩蚪蚋蚌蚶蚯蛄蛆
蚰蛉蠣蚫蛔蛞蛩蛬蛟蛛蛯蜒蜆蜈蜀蜃蛻蜑蜉蜍蛹蜊蜴蜿蜷蜻蜥蜩蜚蝠
蝟蝸蝌蝎蝴蝗蝨蝮蝙蝓蝣蝪蠅螢螟螂螯蟋螽蟀蟐雖螫蟄螳蟇蟆螻蟯蟲
蟠蠏蠍蟾蟶蟷蠎蟒蠑蠖蠕蠢蠡蠱蠶蠹蠧蠻衄衂衒衙衞衢衫袁衾袞衵衽
袵衲袂袗袒袮袙袢袍袤袰袿袱裃裄裔裘裙裝裹褂裼裴裨裲褄褌褊褓襃
褞褥褪褫襁襄褻褶褸襌褝襠襞襦襤襭襪襯襴襷襾覃覈覊覓覘覡覩覦覬
覯覲覺覽覿觀觚觜觝觧觴觸訃訖訐訌訛訝訥訶詁詛詒詆詈詼詭詬詢誅
誂誄誨誡誑誥誦誚誣諄諍諂諚諫諳諧諤諱謔諠諢諷諞諛謌謇謚諡謖謐
謗謠謳鞫謦謫謾謨譁譌譏譎證譖譛譚譫譟譬譯譴譽讀讌讎讒讓讖讙讚
谺豁谿豈豌豎豐豕豢豬豸豺貂貉貅貊貍貎貔豼貘戝貭貪貽貲貳貮貶賈
賁賤賣賚賽賺賻贄贅贊贇贏贍贐齎贓賍贔贖赧赭赱赳趁趙跂趾趺跏跚
跖跌跛跋跪跫跟跣跼踈踉跿踝踞踐踟蹂踵踰踴蹊蹇蹉蹌蹐蹈蹙蹤蹠踪
蹣蹕蹶蹲蹼躁躇躅躄躋躊躓躑躔躙躪躡躬躰軆躱躾軅軈軋軛軣軼軻軫
軾輊輅輕輒輙輓輜輟輛輌輦輳輻輹轅轂輾轌轉轆轎轗轜轢轣轤辜辟辣
辭辯辷迚迥迢迪迯邇迴逅迹迺逑逕逡逍逞逖逋逧逶逵逹迸遏遐遑遒逎
遉逾遖遘遞遨遯遶隨遲邂遽邁邀邊邉邏邨邯邱邵郢郤扈郛鄂鄒鄙鄲鄰
酊酖酘酣酥酩酳酲醋醉醂醢醫醯醪醵醴醺釀釁釉釋釐釖釟釡釛釼釵釶
鈞釿鈔鈬鈕鈑鉞鉗鉅鉉鉤鉈銕鈿鉋鉐銜銖銓銛鉚鋏銹銷鋩錏鋺鍄錮錙
錢錚錣錺錵錻鍜鍠鍼鍮鍖鎰鎬鎭鎔鎹鏖鏗鏨鏥鏘鏃鏝鏐鏈鏤鐚鐔鐓鐃
鐇鐐鐶鐫鐵鐡鐺鑁鑒鑄鑛鑠鑢鑞鑪鈩鑰鑵鑷鑽鑚鑼鑾钁鑿閂閇閊閔閖
閘閙閠閨閧閭閼閻閹閾闊濶闃闍闌闕闔闖關闡闥闢阡阨阮阯陂陌陏陋
陷陜陞陝陟陦陲陬隍隘隕隗險隧隱隲隰隴隶隸隹雎雋雉雍襍雜霍雕雹
霄霆霈霓霎霑霏霖霙霤霪霰霹霽霾靄靆靈靂靉靜靠靤靦靨勒靫靱靹鞅
靼鞁靺鞆鞋鞏鞐鞜鞨鞦鞣鞳鞴韃韆韈韋韜韭齏韲竟韶韵頏頌頸頤頡頷
頽顆顏顋顫顯顰顱顴顳颪颯颱颶飄飃飆飩飫餃餉餒餔餘餡餝餞餤餠餬
餮餽餾饂饉饅饐饋饑饒饌饕馗馘馥馭馮馼駟駛駝駘駑駭駮駱駲駻駸騁
騏騅駢騙騫騷驅驂驀驃騾驕驍驛驗驟驢驥驤驩驫驪骭骰骼髀髏髑髓體
髞髟髢髣髦髯髫髮髴髱髷髻鬆鬘鬚鬟鬢鬣鬥鬧鬨鬩鬪鬮鬯鬲魄魃魏魍
魎魑魘魴鮓鮃鮑鮖鮗鮟鮠鮨鮴鯀鯊鮹鯆鯏鯑鯒鯣鯢鯤鯔鯡鰺鯲鯱鯰鰕
鰔鰉鰓鰌鰆鰈鰒鰊鰄鰮鰛鰥鰤鰡鰰鱇鰲鱆鰾鱚鱠鱧鱶鱸鳧鳬鳰鴉鴈鳫
鴃鴆鴪鴦鶯鴣鴟鵄鴕鴒鵁鴿鴾鵆鵈鵝鵞鵤鵑鵐鵙鵲鶉鶇鶫鵯鵺鶚鶤鶩
鶲鷄鷁鶻鶸鶺鷆鷏鷂鷙鷓鷸鷦鷭鷯鷽鸚鸛鸞鹵鹹鹽麁麈麋麌麒麕麑麝
麥麩麸麪麭靡黌黎黏黐黔黜點黝黠黥黨黯黴黶黷黹黻黼黽鼇鼈皷鼕鼡
鼬鼾齊齒齔齣齟齠齡齦齧齬齪齷齲齶龕龜龠堯槇遙瑤凜熙
EOF

my %JISkanji;

my $n = 10000;
for($JISkanji =~ /$Char/go){
    next if /\s/;
    $JISkanji{$_} = [++$n];
}

my %Order = makeorder("",
  ' ', '　',
  [[[['、', '､']]]],
  [[[['。', '｡']]]],
  [[[[',', '，']]]],
  [[[['.', '．']]]],
  [[[['・', '･']]]],
  [[[[':', '：']]]],
  [[[[';', '；']]]],
  [[[['?', '？']]]],
  [[[['!', '！']]]],
  [[[['´'     ]]]],	# ACUTE ACCENT
  [[[['`', '｀']]]],	# GRAVE ACCENT
  [[[['¨'     ]]]],	# DIAERESIS
  [[[['^', '＾']]]],	# CIRCUMFLEX ACCENT
  [[[["\xc2\xaf", "\xef\xbf\xa3"]]]], #MACRON
  "\xE2\x80\xBE",	# OVERLINE
  [[[['_', '＿']]]],
  "\xe2\x80\x95",	# HORIZONTAL BAR
  "\xe2\x80\x94",	# EM DASH
  "\xe2\x80\x93",	# EN DASH
  '‐',
  [[[['/', '／']]]],
  [[[["\x5C", "\xef\xbc\xbc"]]]], # SOLIDUS
  "\xe3\x80\x9c", # WAVE DASH
  [[[["\x7E", "\xEF\xBD\x9E"]]]], # TILDE
  "\xe2\x80\x96", # DOUBLE VERTICAL LINE  
  "\xe2\x88\xa5", # PARALLEL TO
  [[[['|', '｜']]]],
  qw/… ‥ /,
  qw/‘ ’/,
  [[[["'", '＇']]]], # APOSTROPHE
  qw/“ ”/,
  [[[['"', '＂']]]], # QUOTATION MARK
  [[[['(', '（']]]],
  [[[[')', '）']]]],
  qw/〔 〕/,
  [[[['[', '［']]]],
  [[[[']', '］']]]],
  [[[['{', '｛']]]],
  [[[['}', '｝']]]],
  qw/〈 〉 《 》 /,
  [[[['「', '｢']]]],
  [[[['」', '｣']]]],
  qw/『 』 【 】 /,
  [[[['+', '＋']]]],
  [[[['-', "\xef\xbc\x8d"]]]], # HYPHEN-MINUS
  "\xe2\x88\x92", # MINUS SIGN
  qw/± × ÷ /,
  [[[['=', '＝']]]],
  '≠',
  [[[['<', '＜']]]],
  [[[['>', '＞']]]],
  qw/≦ ≧ ≒ ≪ ≫ ∝ ∞ ∂ ∇ √ ∫ ∬ ∠ ⊥ ⌒ /,
  qw/≡ ∽ ∈ ∋ ⊆ ⊇ ⊂ ⊃ ∪ ∩ ∧ ∨ /,
  [[[["\xc2\xac", "\xef\xbf\xa2"]]]], # NOT SIGN
  qw/⇒ ⇔ ∀ ∃ ∴ ∵ ♂ ♀ /,
  [[[['#', '＃']]]],
  [[[['&', '＆']]]],
  [[[['*', '＊']]]],
  [[[['@', '＠']]]],
  qw/§ ¶ ※ † ‡ /,
  qw/☆ ★ ○ ● ◎ ◇ ◆ □ ■ △ ▲ ▽ ▼ /,
  qw/〒 → ← ↑ ↓ ♯ ♭ ♪ /,
  qw/° ′ ″ ℃ /,
  [[[["\xc2\xa5", "\xef\xbf\xa5"]]]], # YEN SIGN
  [[[['$', '＄']]]],
  [[[["\xc2\xa2", "\xef\xbf\xa0"]]]], # CENT SIGN
  [[[["\xc2\xa3", "\xef\xbf\xa1"]]]], # POUND SIGN
  [[[['%', '％']]]],
  '‰', 'Å',
  [[[['0', '０']]]],
  [[[['1', '１']]]],
  [[[['2', '２']]]],
  [[[['3', '３']]]],
  [[[['4', '４']]]],
  [[[['5', '５']]]],
  [[[['6', '６']]]],
  [[[['7', '７']]]],
  [[[['8', '８']]]],
  [[[['9', '９']]]],
  qw/α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω/,
  qw/Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω/,
  qw/а б в г д е ё ж з и й к л м н о п/,
  qw/р с т у ф х ц ч ш щ ъ ы ь э ю я/, 
  qw/А Б В Г Д Е Ё Ж З И Й К Л М Н О П/,
  qw/Р С Т У Ф Х Ц Ч Ш Щ Ъ Ы Ь Э Ю Я/,
  [
   [ [['a', 'ａ']], [['A', 'Ａ']] ],
   [ "\xc4\x81", "\xc4\x80" ],
   [ "\xc3\xa2", "\xc3\x82" ],
  ],
  [[ [['b', 'ｂ']], [['B', 'Ｂ']] ]],
  [[ [['c', 'ｃ']], [['C', 'Ｃ']] ]],
  [[ [['d', 'ｄ']], [['D', 'Ｄ']] ]],
  [
   [ [['e', 'ｅ']], [['E', 'Ｅ']] ],
   [ "\xc4\x93", "\xc4\x92" ],
   [ "\xc3\xaa", "\xc3\x8a" ],
  ],
  [[ [['f', 'ｆ']], [['F', 'Ｆ']] ]],
  [[ [['g', 'ｇ']], [['G', 'Ｇ']] ]],
  [[ [['h', 'ｈ']], [['H', 'Ｈ']] ]],
  [
   [ [['i', 'ｉ']], [['I', 'Ｉ']] ],
   [ "\xc4\xab", "\xc4\xaa" ],
   [ "\xc3\xae", "\xc3\x8e" ],
  ],
  [[ [['j', 'ｊ']], [['J', 'Ｊ']] ]],
  [[ [['k', 'ｋ']], [['K', 'Ｋ']] ]],
  [[ [['l', 'ｌ']], [['L', 'Ｌ']] ]],
  [[ [['m', 'ｍ']], [['M', 'Ｍ']] ]],
  [[ [['n', 'ｎ']], [['N', 'Ｎ']] ]],
  [
   [ [['o', 'ｏ']], [['O', 'Ｏ']] ],
   [ "\xc5\x8d", "\xc5\x8c" ],
   [ "\xc3\xb4", "\xc3\x94" ],
  ],
  [[ [['p', 'ｐ']], [['P', 'Ｐ']] ]],
  [[ [['q', 'ｑ']], [['Q', 'Ｑ']] ]],
  [[ [['r', 'ｒ']], [['R', 'Ｒ']] ]],
  [[ [['s', 'ｓ']], [['S', 'Ｓ']] ]],
  [[ [['t', 'ｔ']], [['T', 'Ｔ']] ]],
  [
   [ [['u', 'ｕ']], [['U', 'Ｕ']] ],
   [ "\xc5\xab", "\xc5\xaa" ],
   [ "\xc3\xbb", "\xc3\x9b" ],
  ],
  [[ [['v', 'ｖ']], [['V', 'Ｖ']] ]],
  [[ [['w', 'ｗ']], [['W', 'Ｗ']] ]],
  [[ [['x', 'ｘ']], [['X', 'Ｘ']] ]],
  [[ [['y', 'ｙ']], [['Y', 'Ｙ']] ]],
  [[ [['z', 'ｚ']], [['Z', 'Ｚ']] ]],
  [[
    [[qw/ーア ｰｱ/]], ['ぁ', [qw/ァ ｧ/] ], [qw/ゝあ ヽア/], ['あ', [qw/ア ｱ/] ],
  ]],
  [[
    [[qw/ーイ ｰｲ/]], ['ぃ', [qw/ィ ｨ/] ], [qw/ゝい ヽイ/], ['い', [qw/イ ｲ/] ],
  ]],
  [
   [
    [[qw/ーウ ｰｳ/]], ['ぅ', [qw/ゥ ｩ/] ], [qw/ゝう ヽウ/], ['う', [qw/ウ ｳ/] ],
   ],
   [ [qw/ヾヴ /], [ [qw/ヴ ｳﾞ/] ] ],
  ],
  [[
    [[qw/ーエ ｰｴ/]], ['ぇ', [qw/ェ ｪ/] ], [qw/ゝえ ヽエ/], ['え', [qw/エ ｴ/] ],
  ]],
  [[
    [[qw/ーオ ｰｵ/]], ['ぉ', [qw/ォ ｫ/] ], [qw/ゝお ヽオ/], ['お', [qw/オ ｵ/] ],
  ]],
  [
    [ [qw/ ヵ /], [qw/ゝか ヽカ /], ['か', [qw/カ ｶ /] ] ],
    [             [qw/ゞが ヾガ /], ['が', [qw/ガ ｶﾞ/] ] ],
  ],
  [
    [ [qw/ゝき ヽキ /], ['き', [qw/キ ｷ /] ] ],
    [ [qw/ゞぎ ヾギ /], ['ぎ', [qw/ギ ｷﾞ/] ] ],
  ],
  [
    [ [qw/ゝく ヽク /], ['く', [qw/ク ｸ /] ] ],
    [ [qw/ゞぐ ヾグ /], ['ぐ', [qw/グ ｸﾞ/] ] ],
  ],
  [
    [ [qw/ ヶ /], [qw/ゝけ ヽケ /], ['け', [qw/ケ ｹ /] ] ],
    [             [qw/ゞげ ヾゲ /], ['げ', [qw/ゲ ｹﾞ/] ] ],
  ],
  [
    [ [qw/ゝこ ヽコ /], ['こ', [qw/コ ｺ /] ] ],
    [ [qw/ゞご ヾゴ /], ['ご', [qw/ゴ ｺﾞ/] ] ],
  ],
  [
    [ [qw/ゝさ ヽサ /], ['さ', [qw/サ ｻ /] ] ],
    [ [qw/ゞざ ヾザ /], ['ざ', [qw/ザ ｻﾞ/] ] ],
  ],
  [
    [ [qw/ゝし ヽシ /], ['し', [qw/シ ｼ /] ] ],
    [ [qw/ゞじ ヾジ /], ['じ', [qw/ジ ｼﾞ/] ] ],
  ],
  [
    [ [qw/ゝす ヽス /], ['す', [qw/ス ｽ /] ] ],
    [ [qw/ゞず ヾズ /], ['ず', [qw/ズ ｽﾞ/] ] ],
  ],
  [
    [ [qw/ゝせ ヽセ /], ['せ', [qw/セ ｾ /] ] ],
    [ [qw/ゞぜ ヾゼ /], ['ぜ', [qw/ゼ ｾﾞ/] ] ],
  ],
  [
    [ [qw/ゝそ ヽソ /], ['そ', [qw/ソ ｿ /] ] ],
    [ [qw/ゞぞ ヾゾ /], ['ぞ', [qw/ゾ ｿﾞ/] ] ],
  ],
  [
    [ [qw/ゝた ヽタ /], ['た', [qw/タ ﾀ /] ] ],
    [ [qw/ゞだ ヾダ /], ['だ', [qw/ダ ﾀﾞ/] ] ],
  ],
  [
    [ [qw/ゝち ヽチ /], ['ち', [qw/チ ﾁ /] ] ],
    [ [qw/ゞぢ ヾヂ /], ['ぢ', [qw/ヂ ﾁﾞ/] ] ],
  ],
  [
    [ ['っ', [qw/ッ ｯ  /] ], [qw/ゝつ ヽツ /], ['つ', [qw/ツ ﾂ /] ] ],
    [                        [qw/ゞづ ヾヅ /], ['づ', [qw/ヅ ﾂﾞ/] ] ],
  ],
  [
    [ [qw/ゝて ヽテ /], ['て', [qw/テ ﾃ /] ] ],
    [ [qw/ゞで ヾデ /], ['で', [qw/デ ﾃﾞ/] ] ],
  ],
  [
    [ [qw/ゝと ヽト /], ['と', [qw/ト ﾄ /] ] ],
    [ [qw/ゞど ヾド /], ['ど', [qw/ド ﾄﾞ/] ] ],
  ],
  [ [ [qw/ゝな ヽナ /], ['な', [qw/ナ ﾅ /] ] ] ],
  [ [ [qw/ゝに ヽニ /], ['に', [qw/ニ ﾆ /] ] ] ],
  [ [ [qw/ゝぬ ヽヌ /], ['ぬ', [qw/ヌ ﾇ /] ] ] ],
  [ [ [qw/ゝね ヽネ /], ['ね', [qw/ネ ﾈ /] ] ] ],
  [ [ [qw/ゝの ヽノ /], ['の', [qw/ノ ﾉ /] ] ] ],
  [
    [ [qw/ゝは ヽハ /], ['は', [qw/ハ ﾊ /] ] ],
    [ [qw/ゞば ヾバ /], ['ば', [qw/バ ﾊﾞ/] ] ],
    [                   ['ぱ', [qw/パ ﾊﾟ/] ] ],
  ],
  [
    [ [qw/ゝひ ヽヒ /], ['ひ', [qw/ヒ ﾋ /] ] ],
    [ [qw/ゞび ヾビ /], ['び', [qw/ビ ﾋﾞ/] ] ],
    [                   ['ぴ', [qw/ピ ﾋﾟ/] ] ],
  ],
  [
    [ [qw/ゝふ ヽフ /], ['ふ', [qw/フ ﾌ /] ] ],
    [ [qw/ゞぶ ヾブ /], ['ぶ', [qw/ブ ﾌﾞ/] ] ],
    [                   ['ぷ', [qw/プ ﾌﾟ/] ] ],
  ],
  [
    [ [qw/ゝへ ヽヘ /], ['へ', [qw/ヘ ﾍ /] ] ],
    [ [qw/ゞべ ヾベ /], ['べ', [qw/ベ ﾍﾞ/] ] ],
    [                   ['ぺ', [qw/ペ ﾍﾟ/] ] ],
  ],
  [
    [ [qw/ゝほ ヽホ /], ['ほ', [qw/ホ ﾎ /] ] ],
    [ [qw/ゞぼ ヾボ /], ['ぼ', [qw/ボ ﾎﾞ/] ] ],
    [                   ['ぽ', [qw/ポ ﾎﾟ/] ] ],
  ],
  [ [ [qw/ゝま ヽマ /], ['ま', [qw/マ ﾏ /] ] ] ],
  [ [ [qw/ゝみ ヽミ /], ['み', [qw/ミ ﾐ /] ] ] ],
  [ [ [qw/ゝむ ヽム /], ['む', [qw/ム ﾑ /] ] ] ],
  [ [ [qw/ゝめ ヽメ /], ['め', [qw/メ ﾒ /] ] ] ],
  [ [ [qw/ゝも ヽモ /], ['も', [qw/モ ﾓ /] ] ] ],
  [ [ ['ゃ', [qw/ャ ｬ/] ], [qw/ゝや ヽヤ /], ['や', [qw/ヤ ﾔ/] ] ] ],
  [ [ ['ゅ', [qw/ュ ｭ/] ], [qw/ゝゆ ヽユ /], ['ゆ', [qw/ユ ﾕ/] ] ] ],
  [ [ ['ょ', [qw/ョ ｮ/] ], [qw/ゝよ ヽヨ /], ['よ', [qw/ヨ ﾖ/] ] ] ],
  [ [ [qw/ゝら ヽラ /], ['ら', [qw/ラ ﾗ /] ] ] ],
  [ [ [qw/ゝり ヽリ /], ['り', [qw/リ ﾘ /] ] ] ],
  [ [ [qw/ゝる ヽル /], ['る', [qw/ル ﾙ /] ] ] ],
  [ [ [qw/ゝれ ヽレ /], ['れ', [qw/レ ﾚ /] ] ] ],
  [ [ [qw/ゝろ ヽロ /], ['ろ', [qw/ロ ﾛ /] ] ] ],
  [ [ [qw/ゎ ヮ /], [qw/ゝわ ヽワ /], ['わ', [qw/ワ ﾜ /] ] ] ],
  [ [ [qw/ゝゐ ヽヰ /], [qw/ゐ ヰ /] ] ],
  [ [ [qw/ゝゑ ヽヱ /], [qw/ゑ ヱ /] ] ],
  [ [ [qw/ゝを ヽヲ /], ['を', [qw/ヲ ｦ /] ] ] ],
  [[
    [ [qw/ーン ｰﾝ/] ], [qw/ゝん ヽン /], ['ん', [qw/ン ﾝ/] ],
  ]],
  [ [[qw/ゝ ヽ /]], [[qw/ゞ ヾ /]] ],
  [[[['ー', 'ｰ']]]],
  qw/〃 々 仝 〆 〇 /,
);

$Order{ '〓' } = [0x80000000];

my %Iterate;
# $Iterate{ Replaced Char }{ Prev Char } = Replacing Char;

$Iterate{ 'ー' } = _hash(qw/
  アァカガヵサザタダナハバパマヤャラワヮｱｧｶｶﾞｻｻﾞﾀﾀﾞﾅﾊﾊﾞﾊﾟﾏﾔｬﾗﾜあぁかがさざただなはばぱまやゃらわゎ
  イィキギシジチヂニヒビピミリヰｲｨｷｷﾞｼｼﾞﾁﾁﾞﾆﾋﾋﾞﾋﾟﾐﾘいぃきぎしじちぢにひびぴみりゐ
  ウヴゥクグスズツヅッヌフブプムユュルｳｳﾞｩｸｸﾞｽｽﾞﾂﾂﾞｯﾇﾌﾌﾞﾌﾟﾑﾕｭﾙうぅくぐすずつづっぬふぶぷむゆゅる
  エェケゲヶセゼテデネヘベペメレヱｴｪｹｹﾞｾｾﾞﾃﾃﾞﾈﾍﾍﾞﾍﾟﾒﾚえぇけげせぜてでねへべぺめれゑ
  オォコゴソゾトドノホボポモヨョロヲｵｫｺｺﾞｿｿﾞﾄﾄﾞﾉﾎﾎﾞﾎﾟﾓﾖｮﾛｦおぉこごそぞとどのほぼぽもよょろを
  ンﾝん
/);

$Iterate{ 'ｰ' } = _hash(qw/
  ｱｧｶｶﾞｻｻﾞﾀﾀﾞﾅﾊﾊﾞﾊﾟﾏﾔｬﾗﾜあぁかがさざただなはばぱまやゃらわゎアァカガヵサザタダナハバパマヤャラワヮ
  ｲｨｷｷﾞｼｼﾞﾁﾁﾞﾆﾋﾋﾞﾋﾟﾐﾘいぃきぎしじちぢにひびぴみりゐイィキギシジチヂニヒビピミリヰ
  ｳｳﾞｩｸｸﾞｽｽﾞﾂﾂﾞｯﾇﾌﾌﾞﾌﾟﾑﾕｭﾙうぅくぐすずつづっぬふぶぷむゆゅるウヴゥクグスズツヅッヌフブプムユュル
  ｴｪｹｹﾞｾｾﾞﾃﾃﾞﾈﾍﾍﾞﾍﾟﾒﾚえぇけげせぜてでねへべぺめれゑエェケゲヶセゼテデネヘベペメレヱ
  ｵｫｺｺﾞｿｿﾞﾄﾄﾞﾉﾎﾎﾞﾎﾟﾓﾖｮﾛｦおぉこごそぞとどのほぼぽもよょろをオォコゴソゾトドノホボポモヨョロヲ
  ﾝんン
/);

$Iterate{ 'ゝ' } = _hash(qw/
  あぁアァｱｧ
  かがカガヵｶｶﾞ
  さざサザｻｻﾞ
  ただタダﾀﾀﾞ
  なナﾅ
  はばぱハバパﾊﾊﾞﾊﾟ
  まマﾏ
  やゃヤャﾔｬ
  らラﾗ
  わゎワヮﾜ
  いぃイィｲｨ
  きぎキギｷｷﾞ
  しじシジｼｼﾞ
  ちぢチヂﾁﾁﾞ
  にニﾆ
  ひびぴヒビピﾋﾋﾞﾋﾟ
  みミﾐ
  りリﾘ
  ゐヰ
  うぅウヴゥｳｳﾞｩ
  くぐクグｸｸﾞ
  すずスズｽｽﾞ
  つづっツヅッﾂﾂﾞｯ
  ぬヌﾇ
  ふぶぷフブプﾌﾌﾞﾌﾟ
  むムﾑ
  ゆゅユュﾕｭ
  るルﾙ
  えぇエェｴｪ
  けげケゲヶｹｹﾞ
  せぜセゼｾｾﾞ
  てでテデﾃﾃﾞ
  ねネﾈ
  へべぺヘベペﾍﾍﾞﾍﾟ
  めメﾒ
  れレﾚ
  ゑヱ
  おぉオォｵｫ
  こごコゴｺｺﾞ
  そぞソゾｿｿﾞ
  とどトドﾄﾄﾞ
  のノﾉ
  ほぼぽホボポﾎﾎﾞﾎﾟ
  もモﾓ
  よょヨョﾖｮ
  ろロﾛ
  をヲｦ
  んンﾝ 
/);

$Iterate{ 'ヽ' } = _hash(qw/
  アァあぁｱｧ
  カガヵかがｶｶﾞ
  サザさざｻｻﾞ
  タダただﾀﾀﾞ
  ナなﾅ
  ハバパはばぱﾊﾊﾞﾊﾟ
  マまﾏ
  ヤャやゃﾔｬ
  ラらﾗ
  ワヮわゎﾜ
  イィいぃｲｨ
  キギきぎｷｷﾞ
  シジしじｼｼﾞ
  チヂちぢﾁﾁﾞ
  ニにﾆ
  ヒビピひびぴﾋﾋﾞﾋﾟ
  ミみﾐ
  リりﾘ
  ヰゐ
  ウヴゥうぅｳｳﾞｩ
  クグくぐｸｸﾞ
  スズすずｽｽﾞ
  ツヅッつづっﾂﾂﾞｯ
  ヌぬﾇ
  フブプふぶぷﾌﾌﾞﾌﾟ
  ムむﾑ
  ユュゆゅﾕｭ
  ルるﾙ
  エェえぇｴｪ
  ケゲヶけげｹｹﾞ
  セゼせぜｾｾﾞ
  テデてでﾃﾃﾞ
  ネねﾈ
  ヘベペへべぺﾍﾍﾞﾍﾟ
  メめﾒ
  レれﾚ
  ヱゑ
  オォおぉｵｫ
  コゴこごｺｺﾞ
  ソゾそぞｿｿﾞ
  トドとどﾄﾄﾞ
  ノのﾉ
  ホボポほぼぽﾎﾎﾞﾎﾟ
  モもﾓ
  ヨョよょﾖｮ
  ロろﾛ
  ヲをｦ
  ンんﾝ 
/);

$Iterate{ 'ゞ' } = _hash(qw/
  がかカガヵｶｶﾞ
  ざさサザｻｻﾞ
  だたタダﾀﾀﾞ
  ばはぱハバパﾊﾊﾞﾊﾟ
  ぎきキギｷｷﾞ
  じしシジｼｼﾞ
  ぢちチヂﾁﾁﾞ
  びひぴヒビピﾋﾋﾞﾋﾟ
  ぐくクグｸｸﾞ
  ずすスズｽｽﾞ
  づつっツヅッﾂﾂﾞｯ
  ぶふぷフブプﾌﾌﾞﾌﾟ
  げけケゲヶｹｹﾞ
  ぜせセゼｾｾﾞ
  でてテデﾃﾃﾞ
  べへぺヘベペﾍﾍﾞﾍﾟ
  ごこコゴｺｺﾞ
  ぞそソゾｿｿﾞ
  どとトドﾄﾄﾞ
  ぼほぽホボポﾎﾎﾞﾎﾟ
/);

$Iterate{ 'ヾ' } = _hash(qw/
  ガカヵかがｶｶﾞ
  ザサさざｻｻﾞ
  ダタただﾀﾀﾞ
  バハパはばぱﾊﾊﾞﾊﾟ
  ギキきぎｷｷﾞ
  ジシしじｼｼﾞ
  ヂチちぢﾁﾁﾞ
  ビヒピひびぴﾋﾋﾞﾋﾟ
  ヴウゥうぅｳｳﾞｩ
  グクくぐｸｸﾞ
  ズスすずｽｽﾞ
  ヅツッつづっﾂﾂﾞｯ
  ブフプふぶぷﾌﾌﾞﾌﾟ
  ゲケヶけげｹｹﾞ
  ゼセせぜｾｾﾞ
  デテてでﾃﾃﾞ
  ベヘペへべぺﾍﾍﾞﾍﾟ
  ゴコこごｺｺﾞ
  ゾソそぞｿｿﾞ
  ドトとどﾄﾄﾞ
  ボホポほぼぽﾎﾎﾞﾎﾟ
/);

sub _hash{
  my %hash;
  for(@_){
    my @d = m/$Char/go;
    @hash{@d} = ($d[0]) x @d;
  }
  return \%hash;
}

sub makeorder{
   my($ix, @ar, @rt);
   $ix = shift || [];
   @ar = @_;
   push @$ix, 1;
   for(@ar){
      push @rt, ref $_ eq 'ARRAY' ? makeorder([@$ix], @$_) : ($_ => [@$ix]);
      $ix->[-1]++;
   }
   return @rt;
};

sub karr {
  my($self,$coderef,$kanji);
  if(ref $_[0] eq __PACKAGE__){
    $self = shift;
    $coderef = $self->{code};
    $kanji   = $self->{kanji};
  }
  if(ref $_[0] eq 'CODE'){ $coderef = shift }
  $self  = $coderef ? $coderef->(shift) : shift;
  $kanji ||= shift || $Kanji;
  my(@ret, $key);
  my $prev = '';
  unless($self =~ m/^(?:$Char)*$/o){
    croak __PACKAGE__ . " Malformed UTF-8 character";
  }
  for($self =~ m/$Char/go){
    next unless $Order{$_} || $kanji > 1 && /^$CJK$/o;
    if(defined $Iterate{$_} && defined $Iterate{$_}{$prev}){
      $prev = $Iterate{$_}{$prev};
      $key = $_.$prev;
    }
    else { $prev = $key = $_ }
    push @ret,
      $Order{$key} ? $Order{$key} :
      $kanji == 2 ? $JISkanji{$key} :
      $kanji == 3 ? [ unpack('N', "\0" x (4-length).$_) ] :
                   ();
  }
  return @ret ? \@ret : [[0]];
}

sub kcmp {
  my($i,$j,$n,$r);
  my($a,$b,$self,$level);
  if(ref $_[0] eq __PACKAGE__){
    $self = shift;
    $level = $self->{level};
  }
  $a = shift;
  $b = shift;
  $level ||= shift || $Level;
  $n = @$a > @$b ? @$a - 1 : @$b - 1;
  for $i (0..$level-1){
     for $j (0..$n){
        $r = ((defined $a->[$j][$i] ? $a->[$j][$i] : 0)
          <=> (defined $b->[$j][$i] ? $b->[$j][$i] : 0));
        return $r if $r;
     }
  }
  return 0;
}

sub jcmp {
  my($self,$coderef,$level,$kanji);
  if(ref $_[0] eq __PACKAGE__){
    $self = shift;
    $coderef = $self->{code};
    $level   = $self->{level};
    $kanji   = $self->{kanji};
  }
  if(ref $_[0] eq 'CODE'){ $coderef = shift }
  my $a = defined $coderef ? $coderef->($_[0]) : $_[0];
  my $b = defined $coderef ? $coderef->($_[1]) : $_[1];
  $level ||= $_[2] || $Level;
  $kanji ||= $_[3] || $Kanji;
  kcmp(karr($a, $kanji), karr($b, $kanji), $level);
}

sub jsort {
  my($self,$coderef,$level,$kanji);
  if(ref $_[0] eq __PACKAGE__){
    $self = shift;
    $coderef = $self->{code};
    $level   = $self->{level};
    $kanji   = $self->{kanji};
  }
  if(ref $_[0] eq 'CODE'){ $coderef = shift }
  map { $_->[0] }
  sort{ kcmp($a->[1], $b->[1], $level) }
  map { [$_, karr( defined $coderef ? $coderef->($_) : $_, $kanji ) ] }
  @_;
}

my $Fsort = $PACKAGE->new(5,2);
my $Msort = $PACKAGE->new(4,1);
my $Bsort = $PACKAGE->new(4,2);
my $Xsort = $PACKAGE->new(4,3);

sub fsort {
    my($self,$coderef);
    if(ref $_[0] eq __PACKAGE__){
       $self = shift;
       $coderef = $self->{code};
    }
    if(ref $_[0] eq 'CODE'){ $coderef = shift }
    $Fsort->jsort($coderef ? $coderef : (), @_);
}

sub msort {
    my($self,$coderef);
    if(ref $_[0] eq __PACKAGE__){
       $self = shift;
       $coderef = $self->{code};
    }
    if(ref $_[0] eq 'CODE'){ $coderef = shift }
    $Msort->jsort($coderef ? $coderef : (), @_);
}

sub bsort {
    my($self,$coderef);
    if(ref $_[0] eq __PACKAGE__){
       $self = shift;
       $coderef = $self->{code};
    }
    if(ref $_[0] eq 'CODE'){ $coderef = shift }
    $Bsort->jsort($coderef ? $coderef : (), @_);
}

sub xsort {
    my($self,$coderef);
    if(ref $_[0] eq __PACKAGE__){
       $self = shift;
       $coderef = $self->{code};
    }
    if(ref $_[0] eq 'CODE'){ $coderef = shift }
    $Xsort->jsort($coderef ? $coderef : (), @_);
}

sub getorder{wantarray ? %Order : \%Order}
sub getkanji{wantarray ? %JISkanji : \%JISkanji}

1;
__END__

=head1 NAME

Lingua::JA::Sort::JIS -
a perl module compares and sorts strings
in the UTF-8 encoding 
using the collation of Japanese character strings
of JIS (Japanese Industrial Standards).

=head1 SYNOPSIS

  use Lingua::JA::Sort::JIS qw(jsort);

  @result = jsort(
    qw/ パンダ キツネ ひょう たぬき ねずみ さる いぬ ネコ ライオン /
  );

  # result: qw/ いぬ キツネ さる たぬき ネコ ねずみ パンダ ひょう ライオン /

=head1 DESCRIPTION

This module provides some functions to compare and sort strings
in the UTF-8 encoding (EUC-JP or Shift_JIS are NOT permitted!)
using the collation of Japanese character strings.

This module is an implementation of JIS X 4061-1996 and
the collation rules are based on that standard.

=head2 Collation Levels

The following criteria are considered in order
until the collation order is determined.
By default, Levels 1 to 4 are applied and Level 5 is ignored
(as JIS does).

=over 4

=item Level 1: alphabetic ordering.

The character class early appeared in the following list is smaller.

    Space characters, Symbols and Punctuations, Digits, Greek Letters,
    Cyrillic Letters, Latin letters, Kana letters, ( Kanji ideographs ),
    and Geta mark.

In the class, alphabets are collated alphabetically;
kana letters are AIUEO-betically (in the Gozyuon order).

For Kanji, see B<Kanji Classes>.

Other characters are collated as defined.

Characters not defined as a collation element are
ignored and skipped on collation.

    Please see "collate.txt" from "collate.pl" for detail.

B<BN:> Especially, almost alphabets with any diacritical mark
are NOT defined in this implement, 
excepting Latin vowels with macron or circumflex,
because they are not used in Japanese contexts.

=item Level 2: diacritic ordering.

In the Latin vowels, the order is as shown the following list.

    One without diacritical mark, with macron, then with circumflex.

In kana, the order is as shown the following list.

    A voiceless kana, the voiced, then the semi-voiced (if exists).
     (eg. Ka before Ga; Ha before Ba before Pa)

=item Level 3: case ordering.

A small Latin is lesser than the corresponding Capital.

In kana, the order is as shown the following list.

    replaced PROLONGED SOUND MARK(U+30FC);
    Small kana;
    replaced ITERATION MARK (U+309D, U+309E, U+30FD or U+30FE);
    then normal kana.

For example, C<Katakana A + PROLONGED SOUND MARK>, 
C<Katakana A + Small Katakana A>,
C<Katakana A + ITERATION MARK>,
C<Katakana A + Katakana A>. 
(see NOTE about the replacement)

=item Level 4: variant ordering.

Hiragana is lesser than katakana.

=item Level 5: width ordering.

A character that belongs to the block C<Halfwidth and Fullwidth Forms>
is greater than the corresponding normal character.

B<BN:> According to the JIS standard, the level 5 should be ignored.

=back

=head2 Kanji Classes

There are three kanji classes:

=over 4

=item Class 1: the 'saisho' (minimum) kanji class

It comprises five kanji-like chars,
i.e. U+3003, U+3005, U+4EDD, U+3006, U+3007.
Any kanji except U+4EDD are ignored on collation.

=item Class 2: the 'kihon' (basic) kanji class

It comprises JIS levels 1 and 2 kanji in addition to 
the minimum kanji class. Sorted in the JIS order.
Any kanji excepting those defined by JIS X 0208 are ignored on collation.

=item Class 3: the 'kakucho' (extended) kanji class

All the CJK Unified Ideographs in addition to 
the minimum kanji class. Sorted in the unicode order.

=back

=head2 Methods (OOP)

=over 4

=item C<$jis = Lingua::JA::Sort::JIS-E<gt>new()>

=item C<$jis = Lingua::JA::Sort::JIS-E<gt>new(LEVEL)>

=item C<$jis = Lingua::JA::Sort::JIS-E<gt>new(LEVEL, KANJI CLASS)>

=item C<$jis = Lingua::JA::Sort::JIS-E<gt>new(CODE REF, LEVEL, KANJI CLASS)>

Constructs an instance.

The collation level is specified as a number
 between 1 and 5. If omitted, level 4 is applied.
The kanji class is specified as a number between 1 and 3.
If omitted, class 2 is applied.

If a coderef is specified as the first argument,
strings given to a collating method are converted by the coderef
before making collating keys.

For example, if you want to ignore C<PROLONGED SOUND MARK> on collation,

   use Lingua::JA::Sort::JIS;

   $jis = Lingua::JA::Sort::JIS->new(
      sub { my $str = shift; $str =~ s/ー//g; $str; }
   );

   @sorted = $jis->jsort(@strings); # utf-8 encoded

If you want to collate EUC-JP-encoded strings,
give the constructor a coderef converting EUC-JP to UTF-8.

   use Lingua::JA::Sort::JIS;
   use Jcode;
   $euc = Lingua::JA::Sort::JIS->new(
      sub {Jcode->new($_[0], 'euc')->utf8},
   );

   @sorted_euc_jp_strings = $euc->jsort(@euc_jp_strings);

=item C<$jis-E<gt>jsort(LIST)>

Sorts a list of strings in the UTF-8 encoding

=item C<$jis-E<gt>jcmp($a, $b)>

Japanese Collation version of the C<cmp> operator.
It returns 1 (C<$a> is greater than C<$b>) 
or 0 (C<$a> is equal to C<$b>)
or -1 (C<$a> is lesser than C<$b>).

=back

=head2 Functions (not-OOP)

=over 4

=item C<jsort(LIST)>

=item C<jsort(CODE REF, LIST)>

Sorts a list of strings in the UTF-8 encoding
(as the collation level and the kanji class, the default values are used,
and C<jsort()> without any object is identical to C<bsort()>).

If a coderef is specified as the first argument,
strings given to a collating method are converted by the coderef
before making collating keys.

For example, if you want to collate Shift_JIS-encoded strings,
do like following.

   use Jcode;
   use Lingua::JA::Sort::JIS qw(jsort);

   $sjis_to_utf8 = sub {Jcode->new($_[0], 'sjis')->utf8};
   @sorted = jsort $sjis_to_utf8, @not_sorted;

=item C<msort(LIST)>

=item C<msort(CODE REF, LIST)>

Sorts a list of strings in the UTF-8 encoding
(the collation level is 4 and the kanji class is 1, C<m>: minimum).

=item C<bsort(LIST)>

=item C<bsort(CODE REF, LIST)>

Sorts a list of strings in the UTF-8 encoding
(the collation level is 4 and the kanji class is 2, C<b>: basic).

=item C<xsort(LIST)>

=item C<xsort(CODE REF, LIST)>

Sorts a list of strings in the UTF-8 encoding
(the collation level is 4 and the kanji class is 3, C<x>: extented).

=item C<fsort(LIST)>

=item C<fsort(CODE REF, LIST)>

Sorts a list of strings in the UTF-8 encoding
(the collation level is 5 and the kanji class is 2, C<f>: fullwidth).

=item C<jcmp( [ CODEREF ], $a, $b, [ LEVEL, KANJI CLASS ])>

Japanese Collation version of the C<cmp> operator.
It returns 1 (C<$a> is greater than C<$b>) 
or 0 (C<$a> is equal to C<$b>)
or -1 (C<$a> is lesser than C<$b>).

The C<LEVEL> (collation level) is specified as a number
 between 1 and 5. If omitted, level 4 is applied.

The C<KANJI CLASS> (kanji class) is specified as a number between 1 and 3.
If omitted, class 2 is applied.

If C<CODE REF> is specified as the first argument,
strings given to a collating method are converted by the coderef
before making collating keys.

The C<CODE REF>, C<LEVEL> and the C<KANJI CLASS> can be omitted
if not necessary.

e.g. C<jcmp("perl", "Perl")> returns C<-1>
and C<jcmp("perl", "Perl", 2)> returns C<0> 
since C<"perl"> is tertiary and quarternary less than
C<"Perl">, and secondary equal to.

=back

=head2 Advanced Matters

=over 4

=item C<karr([ CODE REF ], STRING, [ KANJI CLASS ] )>

=item C<kcmp(KEY ARRAY, KEY ARRAY, [ LEVEL ])>

These functions allow you to do the Schwartzian transform.

C<karr()> makes C<KEY ARRAY> from C<STRING>.

C<kcmp()> returns
1 (The first C<KEY ARRAY> is greater than the second C<KEY ARRAY>)
or 0 (The first C<KEY ARRAY> is equal to the second C<KEY ARRAY>)
or -1 (The first C<KEY ARRAY> is lesser than the second C<KEY ARRAY>).

The C<CODE REF>, C<LEVEL> and the C<KANJI CLASS>
can be omitted if not necessary.

The following example is sorting by C<"yomi-hyoki"> collation, in which
C<"yomi"> (or pronunciation) is used as the first sorting key, and
C<"hyoki"> (or spell) is used as the second sorting key.

=over 4

=item by OOP

  use Lingua::JA::Sort::JIS;

  $jis = Lingua::JA::Sort::JIS->new();

  foreach(ysort(@data)){ 
    print "@$_\n";
  }

  sub ysort {
    map { $_->[0] }
    sort{ 
      $jis->kcmp($a->[1], $b->[1]) ||
      $jis->kcmp($a->[2], $b->[2])
    }
    map { [$_, $jis->karr($_->[1]),
               $jis->karr($_->[0]) ] } @_;
  }

=item by not-OOP

  use Lingua::JA::Sort::JIS qw(kcmp karr);

  foreach(ysort(@data)){ 
    print "@$_\n";
  }

  sub ysort {
    map { $_->[0] }
    sort{ kcmp($a->[1], $b->[1]) ||
          kcmp($a->[2], $b->[2]) }
    map { [$_, karr($_->[1]), karr($_->[0]) ] } @_;
  }

=item Definition of C<@data> in this example

  @data = (
    [qw/ 小山 こやま (株)ほげほげ /],
    [qw/ 長田 ながた 凸凹商事 /],
    [qw/ 田中 たなか ○×物産 /],
    [qw/ 鈴木 すずき ＊＊精機 /],
    [qw/ 小嶋 こじま ＃＃水産 /],
    [qw/ 児島 こじま ＄＄堂 /],
    [qw/ 長田 おさだ ％％銀行 /],
    [qw/ 小山 おやま ＠＠電鉄 /],
    [qw/ 小島 こじま ￥￥百貨店 /],
    [qw/ 山田 やまだ ＆＆食品 /],
    [qw/ 永田 ながた ＋＋製薬 /],
  );

=item Result

  長田 おさだ ％％銀行
  小山 おやま ＠＠電鉄
  児島 こじま ＄＄堂
  小島 こじま ￥￥百貨店
  小嶋 こじま ＃＃水産
  小山 こやま (株)ほげほげ
  鈴木 すずき ＊＊精機
  田中 たなか ○×物産
  永田 ながた ＋＋製薬
  長田 ながた 凸凹商事
  山田 やまだ ＆＆食品

=back

=item C<getorder()>

In the list context, it returns the collation element hash;
otherwise, it returns the reference of that hash.

In the collation element hash, each key is
the collation element string and each value is
the anonymous array with 5 elements.

You can manipulate the collation element hash like as follows.

    my $order = getorder();

    # delete 'X' from the collation element hash
    delete $order->{'X'};

    # swap the collation order between 'b' and 'B';
    @$order{'B', 'b'} = @$order{'b', 'B'};

    # add a new collation element HIRAGANA LETTER VU;

    my $hira_vu = "\xE3\x82\x94";
    my $kata_vu = "\xE3\x83\xB4";

    $order->{$hira_vu} = [ @{ $order->{$kata_vu} } ];
    -- $order->{$hira_vu}[3];
     # HIRAGANA VU to be quarternary lesser than KATAKANA VU.

=back

=head1 NOTE

=head2 Replacement of PROLONGED SOUND MARK and ITERATION MARKs

        RFC1345 UCS
	[*5]    U+309D  HIRAGANA ITERATION MARK
	[+5]    U+309E  HIRAGANA VOICED ITERATION MARK
	[-6]    U+30FC  KATAKANA-HIRAGANA PROLONGED SOUND MARK
	[*6]    U+30FD  KATAKANA ITERATION MARK
	[+6]    U+30FE  KATAKANA VOICED ITERATION MARK

To represent Japanese characters,
RFC 1345 Mnemonic characters enclosed by brackets
are used below.

These characters, if replaced, are secondary equal to
the replacing kana, while ternary not equal to.

=over 4

=item KATAKANA-HIRAGANA PROLONGED SOUND MARK

The PROLONGED MARK is repleced to normal vowel or nasal
katakana corresponding to the preceding kana if exists.

  eg.	[Ka][-6] to [Ka][A6]
	[bi][-6] to [bi][I6]
	[Pi][YU][-6] to [Pi][YU][U6]
	[N6][-6] to [N6][N6]

=item HIRAGANA- and KATAKANA ITERATION MARKs

The ITERATION MARKs (VOICELESS) are repleced 
to normal kana corresponding to the preceding kana if exists.

  eg.	[Ka][*6] to [Ka][Ka]
	[Do][*5] to [Do][to]
	[n5][*5] to [n5][n5]
	[Pu][*6] to [Pu][Hu]
	[Pi][YU][*6] to [Pi][YU][Yu]

=item HIRAGANA- and KATAKANA VOICED ITERATION MARKs

The VOICED ITERATION MARKs are repleced to the voiced kana
corresponding to the preceding kana if exists.

  eg.	[ha][+5] to [ha][ba]
	[Pu][+5] to [Pu][bu]
	[Ko][+6] to [Ko][Go]
	[U6][+6] to [U6][Vu]

=item Cases of no replacement

Otherwise, no replacement occurs. Especially in the 
cases when these marks follow any character except kana.

The characters not replaced are primary
greater than any kana (see C<"Collate.txt">).

  eg.	CJK followed by PROLONGED SOUND MARK
	DIGIT followed by ITERATION
	[A6][+6] ([A6] has no voiced variant)

=item Example

For example, the Japanese string C<[Pa][-6][Ru]> (spell of C<Perl> in Japanese)
has three collation elements: C<KATAKANA PA>, 
C<PROLONGED SOUND MARK replaced by KATAKANA A>, and C<KATAKANA RU>.

   [Pa][-6][Ru] is converted to [Pa][A6][Ru] by replacement.
		primary equal to [ha][a5][ru].
		secondary equal to [pa][a5][ru], greater than [ha][a5][ru].
		tertiary equal to [pa][-6][ru], lesser than [Pa][A6][Ru].
		quartenary greater than [pa][-6][ru].


=back

=head2 About this implementation

                           [according to the article 6.2, JIS X 4061]

  (1) charset: UTF-8.

  (2) No limit of the number of characters in the string considered
      to collate.

  (3) No character class is added.

  (4) The following characters are added as collation elements.

      IDEOGRAPHIC SPACE in the space class.

      ACUTE ACCENT, GRAVE ACCENT, DIAERESIS, CIRCUMFLEX ACCENT,
      MACRON, HORIZONTAL BAR, EN DASH, TILDE, PARALLEL TO
      in the class of descriptive symbols.

      APOSTROPHE, QUOTATION MARK in the class of parentheses.

      HYPHEN-MINUS in the class of mathematical symbols.

  (5) Collation of Latin alphabets with macron and with circumflex
      is supported.

  (6) Selected kanji class: 
       the minimum kanji class (Five kanji-like chars).
       the basic kanji class (Levels 1 and 2 kanji, JIS).
       the extended kanji class (CJK Unified Ideographs).

=head1 AUTHOR

Tomoyuki SADAHIRO

  bqw10602@nifty.com
  http://homepage1.nifty.com/nomenclator/perl/

 This program is free software; you can redistribute it and/or 
 modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item *

JIS X 4061 [Collation of Japanese character strings]

=item *

JIS X 0208 [7-bits and 8-bits double byte coded Kanji sets
for information interchange]

=item *

JIS X 0221 [Information technology - Universal Multiple-Octet Coded
Character Set (UCS) - part 1 : Architectute and Basic Multilingual Plane].
That is translated from ISO/IEC 10646-1 and introduced into JIS.

=item *

RFC 1345 [Character Mnemonics & Character Sets]

=back

=cut
