#!/usr/bin/perl -w
use strict;
use warnings;
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
# Trivial Change to make sure git is working with github
#
# Scrape AOP website to build CSV file to be imported into a spreadsheet
# so that member data such as location (and hopefully "Based In") can be sorted and tracked
#
#  Information required:
#   - main website URL
#  
#   Methodology:
#
#   Set up Global Hash to store results - this is suspect and confusing.
#   I need to store multiple locations, and multiple based in, per photog
#
#   - go to main page
#   - grab all location codes (hash - number, name)
#   - grab all Based In codes (hash?)
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

my $name = "";
my $myLoc = "";     # Variables to be re-used to build one persons hash
my $myBased = "";   # This seems dumb to set to empty quotes but it is necessary for use in anon hashes below such as $places. Uhh why are those hashes anon?? -- MATT CHECK

my $places = {$myLoc, $myBased};
my $person = {$name, $places}; # Places is a (loc, based) hash?

# my $locsRef;
# my $basedInRef;

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

   # LAZY - i need to re re-write to generate dynamically by scraping!!!
   
   # <option value="1">Anywhere in the UK (403)</option>
   
   # <option value="2">East Midlands (34)</option>
   # <option value="3">East of England (39)</option>
   # <option value="4">London & the South East (483)</option>
   # <option value="5">Manchester & the North West (44)</option>
   # <option value="6">North East (27)</option>
   # <option value="7">Northern Ireland (30)</option>
   # <option value="8">Scotland (34)</option>
   # <option value="9">South West (36)</option>
   # <option value="10">Wales (29)</option>
   # <option value="11">West Midlands (26)</option>
   # <option value="12">Yorkshire & Humberside (28)</option>
   # <option value="14">North Wales (20)</option>
   # <option value="15">Worldwide (311)</option>
   # <option value="16">Europe (135)</option>
   # <option value="17">Overseas (98)</option>
   # <option value="18">Ireland (40)</option>
   
   my %locs = (
      1 => "Anywhere in the UK",
      2 => "East Midlands",
      3 => "East of England",
      4 => "London & the South East",
      5 => "Manchester & the North West",
      6 => "North East",
      7 => "Northern Ireland",
      8 => "Scotland",
      9 => "South West",
      10 => "Wales",
      11 => "West Midlands",
      12 => "Yorkshire & Humberside",
      14 => "North Wales",
      15 => "Worldwide",
      16 => "Europe".
      17 => "Overseas",
      18 => "Ireland",
   );
   
   my $hashref = \%locs;
   
   return $hashref;
    
}

sub grabBasedIn {
    
    # LAZY - i need to re re-write to generate dynamically
    
    # <option value="1">Republic of Ireland (18)</option>
    # <option value="4">London (415)</option>
    # <option value="5">Wales (7)</option>
    # <option value="6">Scotland (12)</option>
    # <option value="7">Yorkshire & Humberside (18)</option>
    # <option value="8">West Midlands (11)</option>
    # <option value="9">East Midlands (12)</option>
    # <option value="10">South East (40)</option>
    # <option value="11">South West (30)</option>
    # <option value="12">North West (17)</option>
    # <option value="13">North East (5)</option>
    # <option value="14">East of England (8)</option>
    # <option value="15">Northern Ireland (1)</option>
    # <option value="16">USA (5)</option>
    # <option value="19">Australia (2)</option>
    # <option value="23">France (4)</option>
    # <option value="24">Germany (21)</option>
    # <option value="25">Netherlands (3)</option>
    # <option value="28">Spain (2)</option>
    # <option value="40">Guernsey (2)</option>
    # <option value="41">Hong Kong (2)</option>
    # <option value="58">South Africa (1)</option>
    # <option value="71">UK/Europe/USA/Asia (4)</option>
    
    my %basedIn = (
      '1' => 'Republic of Ireland',
      '4' => 'London',
      '5' => 'Wales',
      '6' => 'Scotland',
      '7' => 'Yorkshire & Humberside',
      '8' => 'West Midlands',
      '9' => 'East Midlands',
      '10' => 'South East',
      '11' => 'South West',
      '12' => 'North West',
      '13' => 'North East',
      '14' => 'East of England',
      '15' => 'Northern Ireland',
      '16' => 'USA'.
      '19' => 'Australia',
      '23' => 'France',
      '24' => 'Germany',
      '25' => 'Netherlands',
      '28' => 'Spain',
      '40' => 'Guernsey',
      '41' => 'Hong Kong',
      '58' => 'South Africa',
      '71' => 'UK/Europe/USA/Asia',
      
   );
   
   my $hashref = \%basedIn;
   
   return $hashref;
    
} 

sub nextPage {

}

# MAIN

grabMainPage();

my $locsRef;
$locsRef = grabLocs();

# Beware it returns a hashref that needs to be dereferenced such as  $locsRef->{key}

my $basedInRef;
$basedInRef = grabBasedIn();

# print $locsRef->{1};


;

