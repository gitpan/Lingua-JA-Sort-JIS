#!perl

require 5.006;
use strict;
use warnings;

use Lingua::JA::Sort::JIS qw(kcmp);
use Unicode::CharName qw(uname);

print "show collation elements...\n";

open FH, ">collate.txt";
print FH << '';
#  COLLATION ELEMENTS for Lingua::JA::Sort::JIS
#
#   based on Collation of Japanese Character String <JIS X 4061-1996>
#
# * This list is <<privately>> prepared for Lingua::JA::Sort::JIS.pm.
#   This is <<not included>> in the original JIS.
#
# * <CJK> characters are just before GETA MARK.
#
#   Here is based on the basic kanji class of levels 1 and 2 JIS kanji.
#

my %order = (
   Lingua::JA::Sort::JIS::getorder(),
   Lingua::JA::Sort::JIS::getkanji(),
);
for(sort { kcmp([ $order{$a} ], [ $order{$b} ], 5) } keys %order){
    my ($u,$v) = unpack 'UU', $_;
    my $n = uname($u);
    print FH sprintf("[%-15s] ", join(", ", @{ $order{$_} })),
    "U+", sprintf("%04X", $u), 
  defined $v ? ':U+'.sprintf("%04X", $v) : '', 
    "\t", $n =~ /CJK/ ? '<CJK>' : $n,
  defined $v ? ':'.uname($v) : '', "\n";
}
__END__
