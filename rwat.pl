use strict;
use warnings;
use utf8 ;
use Data::Dumper qw(Dumper);
require 'GetHadiths.pl';
  use XML::Writer;
  use IO::File;

binmode (STDOUT, ":utf8" );
#    my $output = IO::File->new(">output.xml");
#my $writer = XML::Writer->new(OUTPUT => $output);
#  $writer->xmlDecl("UTF-8");
my @rwat = hadithRwat (GetHadith (404));
#foreach my $rwat (@rwat) {
#			 $writer->startTag("Hadith");
#		   $writer->characters("$rwat");
#		    $writer->endTag();
#	
#}
#$writer->end();
#  $output->close();
#my @rwat = hadithRwat($hadith);
#print $rwat[0] ;
#my $output = join  '\n', @rwat;

my $filename = 'output.txt';
	open( OUT, ">$filename" ) || die("Cannot Open File");
binmode OUT, ":utf8"; 
print OUT  join  "\n", @rwat;
#print OUT GetHadith (5);

sub hadithRwat {
	my $source = $_[0];
	my @words = split / / , $source ;
	my @keyWrdslocation ;
	my @rwat;
	my $saidTest = 0; 
	print "we have started \n";
	 
	
	for (my $i = 0 ; $i <= $#words; $i++){
		$words[$i] =DeleteHrakat($words[$i]);
#		if ($words[$i] eq "قال") {
#			$saidTest = 1;
#		}
		if ($saidTest == 0) {
			if ( ishKeyword($words[$i] ) ) {
				print "I found a keyword \n";
			push @keyWrdslocation ,$i;			
		
				}
		}
	}
	for (my $i = 0 ; $i < $#keyWrdslocation ; $i++){
		my $j = $i + 1;
		my $first = $keyWrdslocation[$i] + 1 ;
		my $second = $keyWrdslocation[$j] - 1 ;
		my @rawi = @words[$first .. $second];
		my $rawi = join ' ', @rawi;
	#	print $rawi ."\n";
		
		push  @rwat,$rawi;
	}
	return @rwat ;
}

sub ishKeyword {
my @keywords = qw{حدثنا حدثني سمعت سمعنا أخبرني أخبرنا سمع عن قال } ;
# 	my @keywords = qw{حدث سمع أخبر عن قال};
	foreach my $word (@keywords) {
	return 1 if $_[0] =~ m/$word/ ;
	}
	
}

sub DeleteHrakat {
	my $text = $_[0];
	
	$text =~ s/ّ//g;
	$text =~ s/َ//g;
	$text =~ s/ً//g;
	$text =~ s/ُ//g;
	$text =~ s/ٌ//g;
	$text =~ s/ِ//g;
	$text =~ s/ٍ//g;
	$text =~ s/ْ//g;
	return $text ;
	
}

