package Tree::Persist::Base;

use strict;
use warnings;

use Scalar::Util qw( blessed );
use UNIVERSAL::require;

our $VERSION = '1.01';

sub new {
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init( @_ );

    return $self;
}

sub _init {
    my $self = shift;
    my ($opts) = @_;

    $self->{_tree} = undef;
    $self->{_autocommit} = (exists $opts->{autocommit} ? $opts->{autocommit} : 1);
    $self->{_changes} = [];

    if ( exists $opts->{class} ) {
        $self->{_class} = $opts->{class};
    }
    else {
        $self->{_class} = 'Tree';
    }

    if ( exists $opts->{tree} ) {
        $self->_set_tree( $opts->{tree} );
    }

    return $self;
}

sub autocommit {
    my $self = shift;

    if ( @_ ) {
        (my $old, $self->{_autocommit}) = ($self->{_autocommit}, (shift && 1) );
        return $old;
    }
    else {
        return $self->{_autocommit};
    }
}

sub rollback {
    my $self = shift;

    if ( @{$self->{_changes}} ) {
        $self->_reload;
        $self->{_changes} = [];
    }

    return $self;
}

sub commit {
    my $self = shift;

    if ( @{$self->{_changes}} ) {
        $self->_commit;
        $self->{_changes} = [];
    }

    return $self;
}

sub tree {
    my $self = shift;
    return $self->{_tree};
}

sub _set_tree {
    my $self = shift;
    my ($value) = @_;

    $self->{_tree} = $value;

    $self->_install_handlers;

    return $self;
}

sub _install_handlers {
    my $self = shift;

    $self->{_tree}->add_event_handler({
        add_child    => $self->_add_child_handler,
        remove_child => $self->_remove_child_handler,
        value        => $self->_value_handler,
    });

    return $self;
}

sub _strip_options {
    my $self = shift;
    my ($params) = @_;

    if ( @$params && !blessed($params->[0]) && ref($params->[0]) eq 'HASH' ) {
        return shift @$params;
    }
    else {
        return {};
    }
}

sub _add_child_handler {
    my $self = shift;
    return sub {
        my ($parent, @children) = @_;
        my $options = $self->_strip_options( \@children );
        push @{$self->{_changes}}, {
            action => 'add_child',
            parent => $parent,
            options => $options,
            children => [ @children ],
        };
        $self->commit if $self->autocommit;
    };
}

sub _remove_child_handler {
    my $self = shift;
    return sub {
        my ($parent, @children) = @_;
        my $options = $self->_strip_options( \@children );
        push @{$self->{_changes}}, {
            action => 'remove_child',
            parent => $parent,
            options => $options,
            children => [ @children ],
        };
        $self->commit if $self->autocommit;
    };
}

sub _value_handler {
    my $self = shift;
    return sub {
        my ($node, $old, $new) = @_;
        push @{$self->{_changes}}, {
            action => 'change_value',
            node => $node,
            old_value => $old,
            new_value => $node->value,
        };
        $self->commit if $self->autocommit;
    };
}

1;
__END__

=head1 NAME

Tree::Persist::Base - The base class for the Tree persistence plugin hierarchy

=head1 DESCRIPTION

This provides a useful baseclass for all the L<Tree::Persist> plugins.

Existing plugins are:

=over 4

=item * L<Tree::Persist::DB::SelfReferential>

=item * L<Tree::Persist::File::XML>

=back

=head1 PARAMETERS

These are the parameters provided for by this class. These are in addition to
whatever parameters the child class may use.

=over 4

=item * autocommit (optional)

This will be the initial setting for the autocommit value. (Please see
C<autocommit()> for more info.)

=item * class (optional)

This is the class that will be used to bless the nodes into, unless the
datastore specifies otherwise. It will default to 'Tree'.

=back

=head1 METHODS

=head2 new({ %opts })

This is the constructor. C<%opts> is the set of parameters described in
L<Tree::Persist>.

=head2 autocommit( [$autocommit] )

Here, [] indicate an optional parameter.

If called without any parameters, this will return the current autocommit
setting. If called with a parameter, it will set the autocommit flag to the
truth value of the parameter, then return the I<old> setting.

Autocommit, if turned on, will write any changes made to the tree directly to
the datastore. If it's off, you will have to explicitly issue a commit.

NOTE: If you turn autocommit off, then back on, it will B<not> issue a commit
until the next change occurs. At that time, it will commit all changes that
have occurred since the last commit.

=head2 commit()

If any changes are queued up, this will write them to the database. If there
are no changes, this is a no-op.

=head2 rollback()

If there are any changes queued up, this will discard those changes and reload
the tree from the datastore. If there are no changes, this is a no-op.

=head2 tree()

This will return the tree that is being persisted.

=head1 CODE COVERAGE

Please see the relevant section of L<Tree::Persist>.

=head1 SUPPORT

Please see the relevant section of L<Tree::Persist>.

=head1 AUTHORS

Rob Kinyon E<lt>rob.kinyon@iinteractive.comE<gt>

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

Thanks to Infinity Interactive for generously donating our time.

=head1 COPYRIGHT AND LICENSE

Copyright 2004, 2005 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
