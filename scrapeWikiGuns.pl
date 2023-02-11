#!/usr/bin/perl -w
use strict;
use utf8;

require v5.12;

use WWW::Mechanize;
use HTML::TokeParser;
use DBI;
use IO::Socket::SSL qw();

# Objective
#
#  I want to create a map in Google so that I can drive from place to place and make images of those areas where it happened. A new sort of project. I have 3 American road trip projects that I can do simultaneously and this one I will match up with one about churches so I’ll drive to the areas at the same time. Make sense? The goal is to plan a route. I’ll select 52 or so. But would be good to have them all. And if there is a way I’d layer each group by decade (you can make layers in google maps)

#  Information required:
#   - decade
#   - date
#   - name of location
#   - GPS coords
#   - number of dead
#   - days since last shooting
#  
#   Save to database (mySQL) 
#   


# GLOBALS

my $wikiURL = "https://en.wikipedia.org/wiki/List_of_mass_shootings_in_the_United_States";

sub openDB {
    
}

sub grabDatesLocs {

    my $agent = WWW::Mechanize->new(ssl_opts => {
    SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE, verify_hostname => 0,
    });

    $agent->get($wikiURL);

    my $page = HTML::TokeParser->new(\$agent->{content});
    print "$page\n";
    
}

sub grabGPS{
    
}

sub mapEvents{
    
} 

sub closeDB{
    
}

# MAIN

grabDatesLocs()

;
