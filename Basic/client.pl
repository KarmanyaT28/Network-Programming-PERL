use strict;
use warnings;
use IO::Socket::INET;

my $client = IO::Socket::INET->new(
    PeerAddr => 'localhost',
    PeerPort => 7777,
    Proto    => 'tcp'
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
