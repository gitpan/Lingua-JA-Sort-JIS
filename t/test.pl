use strict;
use JIS::Collation qw(jsort);

chomp(my @data = <DATA>);
unshift @data, "";
my $data = join ":",@data;

for my $i (1..20){
  my @arr  = shuffle(@data);
  my $arr  = join ":",@arr;
  my @sort = jsort(@arr);
  my $sort = join ":",@sort;
  print $sort eq $data ? "ok $i\n" : "not ok $i\n";
}

print "\nEND OK\n";
print "sleep 3 sec..\n";
sleep 3;

sub shuffle {
  my @array = @_;
  my $i;
  for ($i = @array; --$i; ) {
     my $j = int rand ($i+1);
     next if $i == $j;
     @array[$i,$j] = @array[$j,$i];
  }
  return @array;
}


__DATA__
∞ｒ∞
∞Ｒ＃
∞ｔ∞
＃ｒ∞
＃Ｒ＃
＃ｔ％
＃Ｔ％
８ｔ∞
８Ｔ∞
８ｔ＃
８Ｔ＃
８ｔ％
８Ｔ％
８ｔ８
８Ｔ８
ωｒ∞
ΩＲ％
ｒｒ∞
ｒＲ∞
Ｒｒ∞
ＲＲ∞
ＲＴ％
ｒｔ８
ｔｒ∞
ｔｒ８
ＴＲ８
ｔｔ８
シャーレ
シャイ
シヤィ
シャレ
ちょこ
ちよこ
チョコレート
てーた
テータ
テェタ
てえた
でーた
データ
デェタ
でえた
テータｇ
てぇたｇ
てぇたＧ
テェタＧ
てーたー
テータァ
てーたあ
テェター
てぇたぁ
てえたー
でーたー
データァ
でェたァ
デぇタぁ
デエタア
ひゆ
びゅあ
ぴゅあ
びゅあー
ビュアー
ぴゅあー
ピュアー
ヒュウ
ヒユウ
ビュウア
びゅーあー
ビューアー
ビュウアー
ひゅん
ぴゅん
ふーり
フーリ
ふぅり
ふゥり
ふゥリ
フウリ
ぶーり
ブーリ
ぶぅり
ブゥり
ぷうり
プウリ
ふーりー
フゥリー
ふゥりィ
フぅリぃ
フウリー
ふうりぃ
ブウリイ
ぷーりー
ぷゥりイ
ぷうりー
プウリイ
フヽ
ふゞ
ぶゝ
ぶふ
ぶフ
ブふ
ブフ
ぶゞ
ぶぷ
ブぷ
ぷゝ
プヽ
ぷふ
