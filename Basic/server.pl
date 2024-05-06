use strict;
use warnings;
use IO::Socket::INET;

my $server = IO::Socket::INET->new(
    LocalAddr => 'localhost',
    LocalPort => 7777,
    Proto     => 'tcp',
    Listen    => SOMAXCONN,
    Reuse     => 1
) or die "Can't create server: $!";

print "Server started. Listening on port 7777...\n";

my @clients;
while (1) {
    my $client = $server->accept();
    push @clients, $client;
    print "Client connected.\n";

    # Create a new thread for each client to handle messages concurrently
    async {
        while (my $message = <$client>) {
            broadcast($message, $client);
        }
    }->detach();
}

sub broadcast {
    my ($message, $sender) = @_;
    foreach my $client (@clients) {
        next if $client == $sender;
        print $client $message;
    }
}
