#!/usr/bin/perl
use IO::File;
use strict;
use warnings;

my @files = <*.content>;
foreach my $file (@files) {
	process_file($file);
}

sub process_file {
my $arg = shift;

my $in = new IO::File;
my $out = new IO::File;

open($in, "< $arg") or die "Error opening $arg for reading";

my $filename = <$in>;
chomp $filename;

print "generating $filename\n";

open($out, "> ../$filename") or die "Error opening $filename for writing";

my $title = <$in>;
chomp $title;

local($/);

my $content = <$in>;

my @links =( 
["index.html", "Home"],
["projects.html", "Projects"],
["comp-sci.html", "Computer Science"],
["programming.html", "Programming"],
["martial-art.html", "Martial Art"],
["dj-pompey.html", "DJ Pompey"],
["quotes.html", "Quotes"],
["contact.html", "Contact"],
["links.html", "Links"]);

my $menu = "";
foreach (@links) {
	my $ref = $$_[0];
	my $text = $$_[1];
	if($ref eq $filename) {
		$menu .= qq{<p><a href="$ref"></a>$text</p>\n};
	}
	else {
		$menu .= qq{<p><a href="$ref">$text</a></p>\n};
	}
}

my $quote_below_menu = qq{<p>"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."</p>};


my $heading = "Ray Myers";
my $sub_heading = "I need closure(s)";
my $css = "style.css";

my $foot = "<p>Paid for by the committee to put meaningless information in footers.</p>";


print $out qq{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>$title</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="/arcfavicon.gif" />
  <link rel="stylesheet" type="text/css" href="$css" />
  <script type="text/css"></script>

</head>

<body id="twocolumn-left">
  <div id="container">
    <div class="wrapper">
      <div id="header">
        <div class="wrapper">
	  <div id='g_title'>
          <h1 id="page-title">
	  $heading
	  </h1>
	  </div>
          <div style="clear: both"></div>
	  <div id='g_description'>
          <p class="description">
	  $sub_heading
	  </p>
	  </div>

          <div style="clear: both"></div>
        </div>
      </div>
      <!-- /wrapper --><!-- /header -->
      <div id="main-content">
        <div class="wrapper">
          <div class="content-item"><div id='g_body'>
	  $content
	  </div></div>
          <div style="clear: both"></div>

        </div>
      </div>
      <!-- /wrapper --><!-- /main-content -->
      <div id="sidebar">
        <div class="wrapper">
          <div class="links">
            <div class="wrapper"><div id='g_sidebar'><p style="text-align: center; clear: both;" class="separator"></p>
$menu
$quote_below_menu
</div></div>
            <div style="clear: both"></div>

          </div>
    <!-- /wrapper --><!-- /links -->
        </div>
      </div>
      <!-- /wrapper --><!-- /sidebar -->
      <div id="footer"><div class="wrapper">
        <hr/>
	<div id='g_footer'>
	$foot
	</div>

        <div style="clear: both"></div>
      </div></div>
      <!-- /wrapper --><!-- /footer -->
    </div>
  </div>
  <!-- /wrapper --><!-- /container -->

<div id="extraDiv1"><span></span></div><div id="extraDiv2"><span></span></div>
<div id="extraDiv3"><span></span></div><div id="extraDiv4"><span></span></div>
<div id="extraDiv5"><span></span></div><div id="extraDiv6"><span></span></div>

</body>
</html>};
close($in);
close($out);
}
