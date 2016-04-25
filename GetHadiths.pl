#!/usr/bin/perl
use warnings;
use strict; 
use HTML::TagParser;
use WWW::Mechanize;
use utf8;
use DBI;
use Switch;
use LWP::Simple;
use WWW::Mechanize;
use JSON; 
use Encode qw(encode decode);
  use Encode::Guess qw/euc-jp shiftjis 7bit-jis/;
  use Encode qw(encode_utf8);
  use String::Similarity ;
  
 
sub GetHadith {
my $hadithNumber = $_[0];
 require LWP::UserAgent;
 # Last Rawi : https://library.islamweb.net/hadith/RawyDetails.php?RawyID=59899
 #Fitan Bin Hammad : https://library.islamweb.net/hadith/display_hbook.php?indexstartno=0&hflag=&pid=133509&bk_no=285&startno=1992
binmode( STDOUT, ":utf8" );
    my $user_agent = 'Mozilla/5.0 (Linux; Android 4.2.2; es-us; SAMSUNG GT-I9195L Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Version/1.0 Chrome/18.0.1025.308 Mobile Safari/535.19';
    
  my $mech = WWW::Mechanize->new(agent=>$user_agent);

my $fullurl = "https://library.islamweb.net/hadith/display_hbook.php?indexstartno=0&hflag=&pid=133509&bk_no=285&startno=$hadithNumber";# i2.8xlarge
$mech->get($fullurl);
my $html   = $mech->content;
#my $textToDel = qq|[ <a href="hadithServices.php?type=1&amp;cid=1734&amp;sid=30002" onclick="javascript: ShowModalDialog('hadithServices.php?type=1&amp;cid=1734&amp;sid=30002', 700, 400, 'tak'); return false;" style="text-decoration: none;">تخريج</a> ] [ <a href="hadithServices.php?type=2&amp;cid=1734&amp;sid=30002" onclick="javascript: ShowModalDialog('hadithServices.php?type=2&amp;cid=1734&amp;sid=30002', 700, 400, 'sahed'); return false;" style="text-decoration: none;">شواهد</a> ] [ <a href="hadithServices.php?type=3&amp;cid=1734&amp;bk_no=285" onclick="javascript: ShowModalDialog('hadithServices.php?type=3&amp;cid=1734&amp;bk_no=285', 700, 400, 'taraf'); return false;" style="text-decoration: none;">أطراف</a> ] [ <a href="asaneed.php?bk_no=285&amp;cid=1734&amp;sid=30002" onclick="javascript: ShowModalDialog('asaneed.php?bk_no=285&amp;cid=1734&amp;sid=30002', 700, 207,'asaneed'); return false;" style="text-decoration: none;">الأسانيد</a> ]|;
#$html =~s/$textToDel//;
$html = encode ( 'windows-1256', $html );
my $htmlContent = HTML::TagParser->new ($html);
my $elem = $htmlContent->getElementById( "tafseer0" );
my $subTree = $elem->subTree();
my @list = $subTree->getElementsByTagName( "a" );
my $text;

 $text = $elem->innerText;
 foreach my $a (@list) {
 	$text .= "\n";
 	$text .=  $a->innerText();
 }

$text = decode ('UTF-8', $text);
return $text ;
	
}

my $text = GetHadith (700);

	binmode( STDOUT, ":utf8" );
	my $fileName = "hadith.txt";
	open( OUT, ">$fileName" ) || die("Cannot Open File");
	binmode( OUT, ":utf8" );
	print OUT $text;


 
 