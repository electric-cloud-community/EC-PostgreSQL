# -------------------------------------------------------------------------
# Package
#    ExecuteSQL.pl
#
# Dependencies
#    Common.pm
#
# Purpose
#    Perl script to create an PostgreSQL command line
#
# Date
#    10/19/2011
#
# Engineers
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
use Cwd;
use Carp;
use strict;
use Data::Dumper;
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropMod qw(/myProject/libs);
use Common;
$|=1;

sub main {
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    
    # -------------------------------------------------------------------------
    # Parameters
    # -------------------------------------------------------------------------
    my $ConfigName          = ($ec->getProperty( "ConfigName" ))->findvalue('//value')->string_value;
    my $PsqlPath         = ($ec->getProperty( "PsqlPath" ))->findvalue('//value')->string_value;
    my $Server              = ($ec->getProperty( "Server" ))->findvalue('//value')->string_value;
    my $OutputFileName      = ($ec->getProperty( "OutputFileName" ))->findvalue('//value')->string_value;
    my $Query               = ($ec->getProperty( "Query" ))->findvalue('//value')->string_value;
    my $SQLFilePath         = ($ec->getProperty( "SQLFilePath" ))->findvalue('//value')->string_value;
    my $AdditionalCommands  = ($ec->getProperty( "AdditionalCommands" ))->findvalue('//value')->string_value;
    my $WorkingDir          = ($ec->getProperty( "WorkingDir" ))->findvalue('//value')->string_value;
    
    my @cmd;
    my %props;
    #instance the common module
    my $utility = Common->new();
    #print the current plugin version
    print $utility->printVersion("EC-PostgreSQL");
    
    if(!$utility->IsEmptyOrNull($Query) && !$utility->IsEmptyOrNull($SQLFilePath)){
        print "Query and SQLFilePath are mutually exclusive parameters.";
        exit 1;
    }

    #executable
    if(!$utility->IsEmptyOrNull($PsqlPath)){
        push(@cmd,qq{"$PsqlPath"});
    }
    
    #enable quiet mode
    push(@cmd, "-q");
    
    #additional comands
    if(!$utility->IsEmptyOrNull($AdditionalCommands)){
        foreach my $command (split(' +', $AdditionalCommands)) {
             push(@cmd, "$command");
        }
    }
    
    #user name, password and server name
    if(!$utility->IsEmptyOrNull($ConfigName) && !$utility->IsEmptyOrNull($Server)){
    	push(@cmd, qq{[$ConfigName]\@$Server});
    }
    
    if(!$utility->IsEmptyOrNull($Query)){      
        $SQLFilePath = 'temp.sql';
    }
    
    #sql statements from file or textarea
    if(!$utility->IsEmptyOrNull($SQLFilePath)){
        push(@cmd, qq{-f "$SQLFilePath"});
    }
    #OutputFileName
    if(!$utility->IsEmptyOrNull($OutputFileName)){
        $OutputFileName .= ".txt";
        $utility->registerReports(qq{$OutputFileName});
        $props{'output_file'} = $OutputFileName;
    }else{
        $props{'output_file'} = "";
    }
    
    if(!$utility->IsEmptyOrNull($WorkingDir) && !$utility->IsEmptyOrNull($OutputFileName)){
        $props{'workspace_directory'} = cwd;
    }else{
        $props{'workspace_directory'} = "";
    }
    
    if(!$utility->IsEmptyOrNull($WorkingDir)){
        $props{"workingdir"} = $WorkingDir;
    }
    
    #generate the command to execute in console
    $props{"commandLine"} = join(" ", @cmd);
    $utility->setProperties(\%props);
}
  
main();
