# -------------------------------------------------------------------------
# Package
#    Common.pm
#
# Dependencies
#    none
#
# Purpose
#    a bunch of common functions for the Electric Commander plugin development
#
# Date
#    10/07/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package Common;

use strict;
use ElectricCommander;

#constructor
sub new {
    my $class = shift;
    #attributes
    my $self = {};
    bless $self, $class;
    return $self;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties {
    my $self = shift;
    my $propHash = shift;
    # get an EC object
    my $ec = ElectricCommander->new;
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
    return;
}

########################################################################
# IsEmptyOrNull - validate null or empty values
#
# Arguments:
#   -values: variable you want to validate
#
#
# Returns:
#   -0 / 1 
#
########################################################################
sub IsEmptyOrNull {
    my $self = shift;
    my $value = shift;
    if($value && $value ne ''){
        return 0;
    }
    return 1;
}

########################################################################
# printVersion - prints the plugin version
#
# Arguments:
#   -pluginName: Name of the currect plugin name
#
#
# Returns:
#   -nothing
#
########################################################################
sub printVersion {
    my $self = shift;
    my $pluginName = shift;
    my $ec = ElectricCommander->new;
    $ec->abortOnError(0);
    my $xpath = $ec->getPlugin($pluginName);
    my $version = $xpath->findvalue('//pluginVersion')->value;
    return "Using plugin $pluginName version $version\n";
}

########################################################################
# registerReports - creates a link for registering the generated report
# in the job step detail
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub registerReports {
    my $self = shift;
    my $fileName = shift;
    if(!IsEmptyOrNull($fileName)){
        my $ec = ElectricCommander->new;
        $ec->abortOnError(0);
        $ec->setProperty("/myJob/artifactsDirectory", '');
        my $plugin_key = '@PLUGIN_KEY@';
        $ec->setProperty("/myJob/report-urls/$plugin_key Report","jobSteps/$[jobStepId]/" . $fileName);
    }
}

1;
