package LJ::Widget::VerticalSummary;

use strict;
use base qw(LJ::Widget);
use Carp qw(croak);
use Class::Autouse qw( LJ::Vertical );

sub need_res { qw( stc/widgets/verticalsummary.css ) }

sub render_body {
    my $class = shift;
    my %opts = @_;

    my $vertical = $opts{vertical};
    die "Invalid vertical object passed to widget." unless $vertical;

    my $subcats = join(" | ", map { "<a href='" . $_->url . "'>" . $_->display_name . "</a>" } $vertical->children);
    my @entries = $vertical->entries( start => 0, limit => 2 );
    my $ret;

    $ret .= "<h2><a href='" . $vertical->url . "'>";
    $ret .= "<span class='vertsummary-verticalname'>" . $vertical->display_name . "</span> &raquo;";
    $ret .= "</a></h2>";
    $ret .= "<p class='vertsummary-subcats'>";
    if ($subcats) {
        $ret .= $class->ml('widget.verticalsummary.subcats', { subcats => $subcats });
    } else {
        $ret .= "&nbsp;";
    }
    $ret .= "</p>";

    foreach my $entry (@entries) {
        $ret .= "<div class='vertsummary-entry'>";
        if ($entry->userpic) {
            $ret .= $entry->userpic->imgtag_nosize;
        } else {
            $ret .= LJ::run_hook('no_userpic_html');
        }
        $ret .= "<div class='pkg'>";
        $ret .= "<p class='vertsummary-subject'><a href='" . $entry->url . "'><strong>";
        $ret .= $entry->subject_text || "<em>" . $class->ml('widget.verticalsummary.nosubject') . "</em>";
        $ret .= "</strong></a></p>";
        $ret .= "<p class='vertsummary-poster'>" . $entry->poster->ljuser_display;
        unless ($entry->posterid == $entry->journalid) {
            $ret .= " " . $class->ml('widget.verticalsummary.injournal', { user => $entry->journal->ljuser_display });
        }
        $ret .= "</p></div>";
        $ret .= "</div>";
    }

    return $ret;
}

1;
