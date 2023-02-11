#!/usr/bin/perl -w
use strict;
use utf8;

require v5.12;

use WWW::Mechanize;
use HTML::TokeParser;
use DBI;
use IO::Socket::SSL qw();

# Copyright Matthew Paluch 2022-2023
# Edge of the World Productions LLC
#
# Objective
#
#Trivial Change to make sure git is working with github
#
# Scrape AOP website to build CSV file to be imported into a spreadsheet
# so that member data such as location (and hopefully "Based In") can be sorted and tracked
#
#  Information required:
#   - main website URL
#  
#   Methodology:
#
#   Set up Global Hash to store results
#
#   - go to main page
#   - grab all location codes
#   - grab all Based In codes
#   - iternate over location codes
#     - build GET url with location
#       - scrape page - adding data to global hash
#       - check for more pages
#       - if yes, snd URL with new page info to nextPageLoc function
#       - if none, repeat location code loop
#
#   - iternate over Based In codes
#     - build GET url with basedIn code
#       - scrape page - adding data to global hash
#       - check for more pages
#       - if yes, snd URL with new page info to nextPageBasedIn function
#       - if none, repeat basedIn code loop
#
#   - write data to csv file
#

#   NOTE - for now the functions to grab locations, and to grab basedIn codes, will just be statically built hashes
#   - this clearly needs to be re-written at a later date to always grab them dynamically
#
#   mfp 12/9/2022


# GLOBALS

my $mainURL = "https://www.the-aop.org/find/photographers?specialism=&locations=&base=&awards=&video_stills=&displayMode=list&letter=";

my $myLoc;     # Variables to be re-used to build one persons hash
my $myBased;

my places = {$myLoc, $myBased};
my person = {$name, $places}; # Places is a (loc, based) hash?

sub grabMainPage {

    my $agent = WWW::Mechanize->new(ssl_opts => {
    SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE, verify_hostname => 0,
    });

    $agent->get($mainURL);
    die "Could not retrieve $mainURL" unless defined $agent;

    my $page = HTML::TokeParser->new(\$agent->{content});
    
    print "$page\n";
    
    # Parse what TokeParser did to our Mechanize agent
    
    while (my $tag = $page->get_tag("a")) {
    
       # using a href tags as example, not sure what i need yet, possibly different command to $page?
       
    }
    
}

sub grabLocs {

   # LAZY - i need to re re-write to generate dynamically
    
}

sub grabBasedIn {
    
    # LAZY - i need to re re-write to generate dynamically
    
    
} 

sub nextPage {

}

# MAIN

grabMainPage()

;

