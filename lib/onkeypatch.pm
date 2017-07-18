package onkeypatch;

# DATE
# VERSION

use parent qw(monkeypatch);

1;
# ABSTRACT: Monkeypatch your Perl code on the command-line

=head1 SYNOPSIS

On the command-line:

 % perl -Monkeypatch=Your::Package::foo,delete yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,add,'some code' yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,replace,'some code' yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,add_or_replace,'some code' yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,wrap,'my $ctx = shift; some code; $ctx->{orig}(@_)' yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,before,'some code' yourscript.pl ...
 % perl -Monkeypatch=Your::Package::foo,after,'some code' yourscript.pl ...


=head1 DESCRIPTION

This is basically just a convenient way to use L<Monkey::Patch::Action> from the
command-line.


=head1 SEE ALSO

L<Monkey::Patch::Action>

=cut
