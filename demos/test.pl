 use Tk;
 use Tk::IPEntry;

 my $mw = MainWindow->new();

 
 # IpV4 ------------------------------
 my $ipv4adress;
 my $fr = $mw->Frame()->pack();
 my $entry = $fr->IPEntry(
	-variable  => \$ipv4adress,
 )->pack(-side => 'left');

 my $button = $fr->Button(
 		-text 	=> 'Get',
 		-command=> sub{
 			print $entry->get(), "\n";
		},
 )->pack(-side => 'left');

 my $button = $fr->Button(
 		-text 	=> 'Fetch',
 		-command=> sub{
 			print $ipv4adress , "\n";
		},
 )->pack(-side => 'left');

 $ipv4adress = '257.2.32.1';
 # ------------------------------------ 

 # IpV4 ------------------------------
 my $ipv6adress;
 my $fr = $mw->Frame()->pack();
 my $entry = $fr->IPEntry(
	-variable  => \$ipv6adress,
	-type	   => 'ipv6'
 )->pack(-side => 'left');

 my $button = $fr->Button(
 		-text 	=> 'Get',
 		-command=> sub{
 			print $entry->get(), "\n";
		},
 )->pack(-side => 'left');

 my $button = $fr->Button(
 		-text 	=> 'Fetch',
 		-command=> sub{
 			print $ipv6adress , "\n";
		},
 )->pack(-side => 'left');

 $ipv6adress = 'GGGGGG:1245:dfe7:ab23:f5a1:2356:c3d2:cd67';
 # ------------------------------------ 

 MainLoop;
 
