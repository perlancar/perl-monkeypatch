package monkeypatch;

# DATE
# VERSION

my @handles;
sub import {
    require Monkey::Patch::Action;

    my ($package, $fullsubname, $action, @args) = @_;

    die "Please specify action" unless $action;

    die "Please specify subname" unless $fullsubname;
    my ($pkg, $subname) = $fullsubname =~ /\A((?:[0-9A-Za-z_:]+)::)*([0-9A-Za-z_]+)\z/
        or die "Invalid subname, please use PKG::SUBPKG::NAME syntax";
    $pkg =~ s/::\z//;

    (my $pkg_pm = "$pkg.pm") =~ s!::!/!g;
    require $pkg_pm;

    my $code;
    if ($action eq 'delete') {
        die "Extraneous arguments for 'delete' action" if @args;
    } elsif ($action eq 'replace') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for 'replace' action" if @args > 1;
        $code = eval qq(sub { $args[0] });
    } elsif ($action eq 'add') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for 'add' action" if @args > 1;
        $code = eval qq(sub { $args[0] });
    } elsif ($action eq 'add_or_replace') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for 'add_or_replace' action" if @args > 1;
        $code = eval qq(sub { $args[0] });
    } elsif ($action eq 'wrap' || $action eq 'around') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for '$action' action" if @args > 1;
        $action = 'wrap';
        $code = eval qq(sub { $args[0] });
    } elsif ($action eq 'before') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for 'before' action" if @args > 1;
        $action = 'wrap';
        $code = eval qq(sub { my \$__ctx = shift; $args[0]; \$__ctx->{orig}->(\@_); });
    } elsif ($action eq 'after') {
        die "Please specify code" unless @args;
        die "Extraneous arguments for 'after' action" if @args > 1;
        $action = 'wrap';
        $code = eval qq(sub { my \$__ctx = shift; \$__ctx->{orig}->(\@_); $args[0] });
    }
    push @handles, Monkey::Patch::Action::patch_package(
        $pkg, $subname, $action, $code);
}

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
