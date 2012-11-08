package Tree::Persist;

use strict;
use warnings;

our $VERSION = '1.02';

# ----------------------------------------------

sub connect
{
	my($class) = shift;
	my($obj)   = $class -> _instantiate( @_ );

	$obj -> _reload;

	return $obj;

} # End of connect.

# ----------------------------------------------

sub create_datastore
{
	my($class) = shift;
	my($obj)   = $class -> _instantiate( @_ );

	$obj -> _create;

	return $obj;

} # End of create_datastore.

# ----------------------------------------------

sub _instantiate
{
	my($class) = shift;
	my($opts)  = @_;
	my($type)  = delete $opts->{type};
	$type      = 'File' if (! $type);

	use Tree::Persist::File::XML;
	use Tree::Persist::DB::SelfReferential;

	my($obj) =
		$type eq 'File' ? Tree::Persist::File::XML->new( $opts ) :
		$type eq 'DB'   ? Tree::Persist::DB::SelfReferential->new( $opts ) :
		die "Unknown type '$type'";

	return $obj;

} # End of _instantiate.

# ----------------------------------------------

1;

__END__

=head1 NAME

Tree::Persist - A transparent persistence layer for L<Tree> and its children

=head1 SYNOPSIS

Create a tree:

	use Tree;
	use Tree::Persist;

	my($tree_1) = Tree -> new('A') -> add_child
	(
		Tree -> new('B'),
		Tree -> new('C') -> add_child
		(
			Tree -> new('D'),
		),
		Tree -> new('E'),
	);

Create a datastore, which includes writing the tree:

	my($writer) = Tree::Persist -> create_datastore
	({
		filename => 'scripts/store.xml',
		tree	 => $tree_1,
		type	 => 'File',
	});

Retrieve the tree:

	my($reader) = Tree::Persist -> connect
	({
		filename => 'scripts/store.xml',
		type	 => 'File',
	});

	my($tree_2) = $reader -> tree;

See scripts/xml.demo.pl and its storage file scripts/store.xml. See also t/008_add_from_db.t.

General usage of methods:

	$store -> autocommit(0);

	$tree -> set_value('foo');

=head1 DESCRIPTION

This is a transparent persistence layer for Tree and its children. It's fully
pluggable and will allow either loading, storing, and/or association with
between a datastore and a tree.

B<NOTE:> If you load a subtree, you will have access to the parent's id, but
the node will be considered the root for the tree you are working with.

=head1 PLUGINS

The plugins that have been written are:

=over 4

=item * L<Tree::Persist::DB::SelfReferential>

=item * L<Tree::Persist::File::XML>

=back

Please refer to their documentation for the appropriate options for
C<connect()> and C<create_datastore()>.

=head1 METHODS

=head3 Class Methods

=head2 connect({%opts})

This will return an object that will provide persistence. It will B<not> be an
object that inherits from Tree::Persist.

%opts is described in L<Tree::Persist::DB::SelfReferential/PARAMETERS> and L<Tree::Persist::File::XML/PARAMETERS>.

=head2 create_datastore({%opts})

This will create a new datastore for a tree. It will then return the object
used to create that datastore, as if you had called L</connect({%opts})>.

%opts is described in L<Tree::Persist::DB::SelfReferential/PARAMETERS> and L<Tree::Persist::File::XML/PARAMETERS>.

=head3 Behaviors

These behaviors apply to the object returned from L</connect({%opts})> or
L</create_datastore({%opts})>.

=head2 autocommit()

This is a Boolean option that determines whether or not changes to the tree
will committed to the datastore immediately or not. The default is true. This
will return the current setting.

=head2 tree()

This returns the tree.

=head2 commit()

This will save all changes made to the tree associated with this Tree::Persist
object.

This is a no-op if autocommit is true.

=head2 rollback()

This will undo all changes made to the tree since the last commit. If there
were any changes, it will reload the tree from the datastore.

This is a no-op if autocommit is true.

B<NOTE>: Any references to any of the nodes in the tree as it was before
C<rollback()> is called will B<not> refer to the same node of C<<< $persist -> tree >>>
after C<rollback()>.

=head1 FAQ

=head2 How do I control the database used for testing?

The tests default to using $ENV{DBI_DSN}, $ENV{DBI_USER} and $ENV{DBI_PASS}, so you can set
them to anything.

If $ENV{DBI_DSN} is empty, the code uses DBD::SQLite for the database. In this case, a temporary
directory is used for each test.

=head1 CODE COVERAGE

We use L<Devel::Cover> to test the code coverage of our tests. Below is the
L<Devel::Cover> report on this module's V 0.99 test suite.

  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  File						   stmt   bran   cond	sub	pod   time  total
  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  blib/lib/Tree/Persist.pm	  100.0   83.3	n/a  100.0  100.0   17.7   97.6
  .../lib/Tree/Persist/Base.pm  100.0   88.9  100.0  100.0  100.0   20.0   98.3
  blib/lib/Tree/Persist/DB.pm   100.0	n/a	n/a  100.0	n/a	3.1  100.0
  ...ist/DB/SelfReferential.pm  100.0   93.8	n/a  100.0	n/a   36.3   99.2
  .../lib/Tree/Persist/File.pm  100.0   50.0	n/a  100.0	n/a	7.7   96.7
  .../Tree/Persist/File/XML.pm  100.0  100.0  100.0  100.0	n/a   15.1  100.0
  Total						 100.0   89.1  100.0  100.0  100.0  100.0   98.7
  ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 SUPPORT

The mailing list is at L<TreeCPAN@googlegroups.com>. I also read
L<http://www.perlmonks.com> on a daily basis.

=head1 AUTHORS

Rob Kinyon E<lt>rob.kinyon@iinteractive.comE<gt>

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

Thanks to Infinity Interactive for generously donating our time.

Co-maintenance since V 1.01 is by Ron Savage <rsavage@cpan.org>.
Uses of 'I' in previous versions is not me, but will be hereafter.

=head1 COPYRIGHT AND LICENSE

Copyright 2004, 2005 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
