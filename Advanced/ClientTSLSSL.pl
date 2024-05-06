use strict;
use warnings;
use IO::Socket::SSL;

my $client = IO::Socket::SSL->new(
    PeerAddr => 'localhost',
    PeerPort => 7777,
    SSL_verify_mode => 0x00,
) or die "Can't connect to server: $!";

print "Connected to server.\n";

# Start a separate thread for receiving messages from the server
async {
    while (my $message = <$client>) {
        print "Server: $message";
    }
}->detach();

# Main loop for sending messages
while (1) {
    print "> ";
    my $message = <STDIN>;
    print $client $message;
}
