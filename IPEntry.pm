#------------------------------------------------
# automagically updated versioning variables -- CVS modifies these!
#------------------------------------------------
our $Revision           = '$Revision: 1.1 $';
our $CheckinDate        = '$Date: 2002/09/20 03:27:06 $';
our $CheckinUser        = '$Author: xpix $';
# we need to clean these up right here
$Revision               =~ s/^\$\S+:\s*(.*?)\s*\$$/$1/sx;
$CheckinDate            =~ s/^\$\S+:\s*(.*?)\s*\$$/$1/sx;
$CheckinUser            =~ s/^\$\S+:\s*(.*?)\s*\$$/$1/sx;
#-------------------------------------------------
#-- package Tk::Graph ----------------------------
#-------------------------------------------------

# -------------------------------------------------------
#
# Tk/IPEntry.pm
#
# A Megawidget for Input Ip-Adresses Ipv4 and Ipv6
#

=head1 NAME

Tk::IPEntry - A megawidget for input of IP-Adresses IPv4 and IPv6

=head1 SYNOPSIS

 use Tk;
 use Tk::IPEntry;

 my $mw = MainWindow->new();
 my $ipadress;

 my $entry = $mw->IPEntry(
	-variable  => \$ipadress,
 )->pack(-side => 'left');

 $ipadress = '129.2.32.1';

 MainLoop;

=cut

# -------------------------------------------------------
# ------- S O U R C E -----------------------------------
# -------------------------------------------------------
package Tk::IPEntry;
use strict;
use Carp;

use Tk;
use Tk::NumEntry;
use Tie::Watch;

# That's the Base
use base qw/Tk::Frame/;

# ... and construct the Widget!
Construct Tk::Widget 'IPEntry';

# ------------------------------------------
sub ClassInit {
# ------------------------------------------
    # ClassInit is called once per MainWindow, and serves to 
    # perform tasks for the class as a whole.  Here we create
    # a Photo object used by all instances of the class.

    my ($class, $mw) = @_;

    $class->SUPER::ClassInit($mw);

} # end ClassInit

# ------------------------------------------
sub Populate {
# ------------------------------------------
	my ($obj, $args) = @_;
	my %specs;
#-------------------------------------------------
	$obj->{type} = delete $args->{-type}  || 'ipv4';

=head2 -type (I<ipv4>|ipv6) 

The format of Ip-Number.

=cut

#-------------------------------------------------


=head1 METHODS

Here come the methods that you can use with this Widget.

=cut


#-------------------------------------------------

#-------------------------------------------------
	$specs{-variable}     	= [qw/METHOD  variable   Variable/, undef ];

=head2 $IPEntry->I<variable>(\$ipnumber);

Specifies the name of a variable. The value of the variable is a text string 
to be displayed inside the widget; if the variable value changes then the widget 
will automatically update itself to reflect the new value. 
The way in which the string is displayed in the widget depends on the particular 
widget and may be determined by other options, such as anchor or justify. 

=cut

#-------------------------------------------------
	$specs{-set}		= [qw/METHOD  set	Set/,	 undef];

=head2 $IPEntry->I<set>($ipnumber);

Set the IP number to display.

=cut

#-------------------------------------------------
	$specs{-get}     	= [qw/METHOD  get        Get/, 	 undef ];

=head2 $IPEntry->I<get>();  

Here you can get IP number from display.

=cut

#-------------------------------------------------
	$specs{-error}     	= [qw/METHOD  error      Error/, undef ];

=head2 $IPEntry->I<error>();  

This prints the last error.

=cut

	# Ok, here the important structure from the widget ....
	$obj->SUPER::Populate($args);

	$obj->ConfigSpecs(
		-get   	    => [qw/METHOD  get        Get/, 	 undef ],
		-error      => [qw/METHOD  error      Error/, 	 undef ],
		%specs,
	);

	# Widgets in the Megawidget
	# Next, we need 4 NumEntrys(ipv4)
	if(uc($obj->{type}) eq 'IPV4') 
	{
		foreach my $n (0..3) {
			$obj->{nummer}->[$n] = $obj->NumEntry(
				-width	      => 3,
				-minvalue     => 0,
				-maxvalue     => 255,
				-bell	      => 1,
			)->pack(
				-side => 'left'
			);
		}
	} 
	elsif(uc($obj->{type}) eq 'IPV6') 
	{
		foreach my $n (0..7) {
			$obj->{nummer}->[$n] = $obj->Entry(
				-width	      => 4,
			)->pack(
				-side => 'left'
			);
		}
	}
}

# ------------------------------------------
sub set {
# ------------------------------------------
	my ($obj, $adress) = @_;

	# get the new value, split this and give this the 4 or 8 Widgets
	my @adr;
	if(uc($obj->{type}) eq 'IPV4') {
		@adr = split( '\.', $adress);
	} else {
		@adr = split( '\:', $adress)
	}
	# wrong?
	if(uc($obj->{type}) eq 'IPV4' and scalar @adr != 4) {
		return $obj->error('Not right syntax, please put a IpNumber in this format XXX.XXX.XXX.XXX!');
	} 
	if (uc($obj->{type}) eq 'IPV6' and scalar @adr != 8) {
		return $obj->error('Not right syntax, please put a IpNumber in this format ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff!');
	}

	my $c = -1;
	foreach my $num (@adr) {
		$c++;
		$obj->{minivrefs}->[$c] = $obj->check($num);
		$obj->{nummer}->[$c]->configure(
			-textvariable => \$obj->{minivrefs}->[$c]
		);
	}
}

# ------------------------------------------
sub get {
# ------------------------------------------
	my ($obj) = @_;
	my ($addr);

	my $c = 0;
	my $delm = ($obj->{type} eq 'IPV4' ? '.' : ':');
	foreach my $num ( @{ $obj->{minivrefs} } ) {
		$addr .= $delm if($c++);
		$addr .= $obj->check($num);
	}
	return $addr;
}

# ------------------------------------------
sub check {
# ------------------------------------------
	my ($obj, $num) = @_;
	
	# Format
	$num = substr(lc($num), 0, 4)
		if(uc($obj->{type}) eq 'IPV6');

	# wrong?
	if(uc($obj->{type}) eq 'IPV4' && (int($num) < 0 || int($num) > 255)) {
		$obj->error("Number($num) incorrect in IpRange");
		$num = ($num < 0 ? 0 : 255);
	}
	if(uc($obj->{type}) eq 'IPV6' && (! hex($num) && $num !~ /[0]+/)) {
		$obj->error("Number($num) incorrect in IpRange");
		$num = '0000';
	}
	return $num;
}

# ------------------------------------------
sub variable {
# ------------------------------------------
	my ($obj, $vref) = @_;
	
	$obj->{vref} = $vref
		unless(defined $obj->{vref});
	
	my $st = [sub {
		my ($watch, $new_val) = @_;
		my $argv= $watch->Args('-store');
		$argv->[0]->set($new_val);
		$watch->Store($new_val);
	}, $obj];

	my $fetch = [sub {
		my($self, $new) = @_;
		my $var = $self->Fetch;
		my $getvar = $obj->get();
		$self->Store($getvar)
			if($getvar);
		printf ("Fetch: %s\tGet: %s\n", $var, $getvar);
		return ($getvar ? $getvar : $var);
	}, $obj];

	$obj->{watch} = Tie::Watch->new(
		-variable => $vref, 
		-store => $st, 
		-fetch => $fetch
	);

	$obj->OnDestroy( [sub {$_[0]->{watch}->Unwatch}, $obj] );

} # end variable

# ------------------------------------------
sub error {
# ------------------------------------------
	my $self = shift;
	my $msg = shift;
	unless($msg) {
		my $err = $self->{error};
		$self->{error} = '';
		return $err;
	}
	$self->{error} = $msg;
	warn $msg;
	return undef;
} 


1;
=head1 EXAMPLES

Please see for examples in 'demos' directory in this distribution.

=head1 AUTHOR

xpix@netzwert.ag

=head1 SEE ALSO

Tk;
Tk::NumEntry;
Tie::Watch;


__END__
