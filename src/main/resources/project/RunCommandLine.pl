# -------------------------------------------------------------------------
# Package
#    RunCommandLine
#
# Dependencies
#    None
#
# Purpose
#    Execute a command line against psql
#
# Date
#    07/18/2012
#
# Engineer(s)
#    Carlos Rojas
#    Vitaliy Batichko (fix for ECPDBPostgreSQL-8)
#    Alexey Yermakov
#
# Copyright (c) 2014 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package ExecuteSQL;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
use ElectricCommander;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod qw(/myProject/libs);
use Common;
use File::Copy qw(copy);

$|=1;


sub main {
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);

    # -------------------------------------------------------------------------
    # Variables
    # -------------------------------------------------------------------------
    my $commandLine = ($ec->getProperty( "/myCall/commandLine" ))->findvalue('//value')->string_value;
    my $workspace_dir = ($ec->getProperty( "/myCall/workspace_directory" ))->findvalue('//value')->string_value;
    my $output_file_name = ($ec->getProperty( "/myCall/output_file" ))->findvalue('//value')->string_value;
    my $query       = ($ec->getProperty( "Query" ))->findvalue('//value')->string_value;
    my $out_prop    = ($ec->getProperty( "Result_outpp" ))->findvalue('//value')->string_value;
    my ($configName) = $commandLine =~ /\[(.*)\]/;
    my $user;
    my $password;
    
    if (defined $configName) {
        my %config = getConfiguration($ec, $configName);

        if(%config){
            if($config{'user'} ne '' && $config{'password'} ne '') {
                $ENV{PGPASSWORD}="$config{'password'}";
            	$commandLine =~ s/\[(.*)\]\@/ -U $config{'user'} -h /;
                print "Command to run: $commandLine\n";
            } else {
                die 'Unable to retrieve data from configuration "$configName"';
            }
        } else {
            die 'Unable to find configuration "$configName"';
        }
    }
    
    my $utility = Common->new();
    if(!$utility->IsEmptyOrNull($query)){
        #Creates a temporary file and the sql script on it and then executes the temp file.       
        open (MYFILE, '>temp.sql');
        print MYFILE "$query";
        close (MYFILE);
    }

    #store the output in the file we created
    my $result = `$commandLine`;
    print $result, "\n";

    my $exit_code = $? >> 8;
    if($exit_code != 0) {
        $ec->setProperty("summary", "exit code $exit_code");
        $ec->setProperty("outcome", "error");
        die "Exit code $exit_code";
    }

    if($out_prop && $out_prop ne "") {
        my $xpath = $ec->setProperty($out_prop, $result);
        if($xpath) {
            my $code = $xpath->findvalue('//code')->value(); 
            if ($code ne "") {
                my $mesg = $xpath->findvalue('//message');
                $ec->setProperty("summary", "$code: $mesg");
                die qq{Can't set output property "$out_prop": $mesg\n};
            }
        }
    }

    if($output_file_name ne "") {
        open (MYFILE, ">$output_file_name");
        print MYFILE $result;
        close (MYFILE);
    }

    if($workspace_dir ne "") {
        copy $output_file_name, "$workspace_dir/$output_file_name";
    }
}

###########################################################################
=head2 getConfiguration
 
  Title    : getConfiguration
  Usage    : getConfiguration("Configuration name");
  Function : get the information of the configuration given 
  Returns  : hash containing the configuration information
  Args     : named arguments:
           : -configName => name of the configuration to retrieve
           :
=cut
###########################################################################
sub getConfiguration{
    my $ec = shift;
    my $configName = shift;

    my %configToUse;

    my $proj = '$[/myProject/projectName]';
    my $pluginConfigs = new ElectricCommander::PropDB($ec,"/projects/$proj/PostgreSQL_cfgs");

    my %configRow = $pluginConfigs->getRow($configName);

    # Check if configuration exists
    unless(keys(%configRow)) {
        die 'Credential "$configName" does not exist';
    }

    # Get user/password out of credential
    my $xpath = $ec->getFullCredential($configRow{credential});
    $configToUse{'user'} = $xpath->findvalue("//userName");
    $configToUse{'password'} = $xpath->findvalue("//password");

    foreach my $c (keys %configRow) {
        #getting all values except the credential that was read previously
        if($c ne "credential"){
            $configToUse{$c} = $configRow{$c};
        }
    }

    return %configToUse;

}


main();
