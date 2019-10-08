@::gMatchers = (
  #PostgreSQL common errors
  #error counter
  {
    id =>       "error-counter",
    pattern =>          q{ERROR:},
    action =>           q{&incValueWithString("error-counter", "Total errors found: 0");setProperty("outcome", "error" );updateSummary();},
  },
  #invalid file
  {
    id =>       "invalid-file",
    pattern =>          q{unable\sto\sopen\sfile\s(.*)},
    action =>           q{addSimpleMessage("invalid-file", "unable to open file $1");setProperty("outcome", "error" );updateSummary();},
  },
);

sub addSimpleMessage {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub incValueWithString {
    my ($name, $patternString, $increment) = @_;

    $increment = 1 unless defined($increment);

    my $localString = (defined $::gProperties{$name}) ? $::gProperties{$name} :
                                                        $patternString;

    $localString =~ /([^\d]*)(\d+)(.*)/;
    my $leading = $1;
    my $numeric = $2;
    my $trailing = $3;
    
    $numeric += $increment;
    $localString = $leading . $numeric . $trailing;
    setProperty ($name, $localString);
}

sub updateSummary {
    my $summary = (defined $::gProperties{"postgresql-error"}) ? $::gProperties{"postgresql-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"error-counter"}) ? $::gProperties{"error-counter"} . "\n" : "";
    $summary .= (defined $::gProperties{"invalid-file"}) ? $::gProperties{"invalid-file"} . "\n" : "";
	$summary .= (defined $::gProperties{"sp2-error"}) ? $::gProperties{"sp2-error"} . "\n" : "";
    setProperty ("summary", $summary);
}