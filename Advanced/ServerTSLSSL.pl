#Server Script with TLS/SSL

use strict;
use warnings;
use IO::Socket::SSL;

my $server = IO::Socket::SSL->new(
    LocalAddr => 'localhost',
    LocalPort => 7777,
    SSL_cert_file => 'server.crt',
    SSL_key_file  => 'server.key',
    SSL_verify_mode => 0x00,
    Reuse => 1,
    Listen => SOMAXCONN
) or die "Can't create server: $!";

print "Server started. Listening on port 7777...\n";

my @clients;
while (my $client = $server->accept()) {
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
