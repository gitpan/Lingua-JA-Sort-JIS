# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

use strict;
use vars qw($loaded);
$^W = 1;

BEGIN { $| = 1; print "1..14\n"; }
END {print "not ok 1\n" unless $loaded;}
use Lingua::JA::Sort::JIS qw(jsort jcmp);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $s;

my @data = (
 [qw/ いぬ キツネ さる たぬき ネコ ねずみ パンダ ひょう ライオン /],
 [qw/ データ デェタ デエタ データー データァ データア
   デェター デェタァ デェタア デエター デエタァ デエタア /],
 [qw/ さと さど さとう さどう さとうや サトー さとおや /],
 [qw/ ファール ぶあい ファゥル ファウル ファン ふあん フアン ぶあん /],
 [qw/ しょう しよう じょう じよう しょうし しょうじ しようじ
      じょうし じょうじ ショー ショオ ジョー じょおう ジョージ /],
 [qw/すす すず すゝき すすき す┼ゞき すずき すずこ /],
);

$s = 0;
for(@data){
  my %h;
  @h{ @$_ } =();
  $s ++ unless join(":", @$_) eq join(":", jsort(keys %h));
}
print ! $s ? "ok 2\n" : "not ok 2\n";

print jcmp("Perl", "Ｐｅｒｌ") == 0
   && jcmp("Perl", "Ｐｅｒｌ", 4) == 0
   && jcmp("Perl", "Ｐｅｒｌ", 5) == -1
    ? "ok 3\n" : "not ok 3\n";
print jcmp("PERL", "Ｐｅｒｌ") == 1
   && jcmp("PERL", "Ｐｅｒｌ", 3) == 1
   && jcmp("PERL", "Ｐｅｒｌ", 2) == 0
    ? "ok 4\n" : "not ok 4\n";
print jcmp("Perl", "ＰＥＲＬ") == -1
   && jcmp("Perl", "ＰＥＲＬ", 3) == -1
   && jcmp("Perl", "ＰＥＲＬ", 2) == 0
    ? "ok 5\n" : "not ok 5\n";
print jcmp("あいうえお", "アイウエオ") == -1
   && jcmp("あいうえお", "アイウエオ",3) == 0
    ? "ok 6\n" : "not ok 6\n";
print jcmp("ｱｲｳｴｵ", "アイウエオ") == 0
   && jcmp("ｱｲｳｴｵ", "アイウエオ", 5) == 1
    ? "ok 7\n" : "not ok 7\n";
print jcmp("XYZ", "abc") == 1
   && jcmp("XYZ", "abc",1) == 1
    ? "ok 8\n" : "not ok 8\n";
print jcmp("XYZ", "ABC") == 1
   && jcmp("xyz", "ABC") == 1 
    ? "ok 9\n" : "not ok 9\n";
print jcmp("ああ", "あゝ") == 1
   && jcmp("ああ", "あゝ", 3) == 1
   && jcmp("あぁ", "あゝ", 3) == -1
   && jcmp("ああ", "あゝ", 2) == 0
   && jcmp("ああ", "あゞ", 1) == -1
   && jcmp("ただ", "たゞ", 2) == 0
   && jcmp("ただ", "たゝ", 2) == 1
   && jcmp("ただ", "たゝ", 1) == 0
    ? "ok 10\n" : "not ok 10\n";
print jcmp("パアル", "パール") == 1
   && jcmp("パアル", "パール", 3) == 1
   && jcmp("パァル", "パール", 3) == 1
   && jcmp("パアル", "パール", 2) == 0
    ? "ok 11\n" : "not ok 11\n";
print jcmp("", "") == 0
   && jcmp("", "", 1) == 0
   && jcmp("", "", 2) == 0
   && jcmp("", "", 3) == 0
   && jcmp("", "", 4) == 0
   && jcmp("", "", 5) == 0
   && jcmp("", " ")  == -1
   && jcmp("", "\n") == 0
   && jcmp("\n ", "\n \r") == 0
   && jcmp(" ", "\n \r") == 0
    ? "ok 12\n" : "not ok 12\n";
print jcmp('Ａ', '亜') == -1
   && jcmp('Ａ', '亜', 1, 1) == 1
   && jcmp('Ａ', '亜', 1, 2) == -1
   && jcmp('Ａ', '亜', 1, 3) == -1
   && jcmp('亜', '一', 1, 0) == -1
   && jcmp('亜', '一', 1, 1) == 0
   && jcmp('亜', '一', 1, 2) == -1
   && jcmp('亜', '一', 1, 3) == 1
   && jcmp('〓', '熙') == 1
    ? "ok 13\n" : "not ok 13\n";

{
  my(@subject, $sorted);

  my $ignore_prolong = Lingua::JA::Sort::JIS->new(
      sub { my $str = shift; $str =~ s/ー//g; $str; }
  );

  my $jis    = new Lingua::JA::Sort::JIS;
  my $level2 = Lingua::JA::Sort::JIS->new(2);
  my $level3 = Lingua::JA::Sort::JIS->new(3);
  my $level4 = Lingua::JA::Sort::JIS->new(4);
  my $level5 = new Lingua::JA::Sort::JIS 5;

  $sorted  = 'パイナップル ハット はな バーナー バナナ パール パロディ';
  @subject = qw(パロディ パイナップル バナナ ハット はな パール バーナー);

  print $sorted eq join(' ', $ignore_prolong->jsort(@subject))
   && $level2->jcmp("パアル", "パール") == 0
   && $level3->jcmp("パアル", "パール") == 1
   && $level3->jcmp("パァル", "パール") == 1
   && $level4->jcmp("ﾊﾟｰﾙ",   "パール") == 0
   && $level5->jcmp("パール", "ﾊﾟｰﾙ",4) == -1
   && $level2->jcmp("パパ", "ぱぱ") == 0
   && $jis->jcmp("パパ", "ぱぱ") == 1
    ? "ok 14\n" : "not ok 14\n";
}
