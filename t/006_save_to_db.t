use strict;
use warnings;

use Test::More;

eval "use DBI";
plan skip_all => "DBI required for testing DB plugin" if $@;

#use t::tests qw( %runs );

plan tests => 5;

my $CLASS = 'Tree::Persist';
use_ok( $CLASS )
    or Test::More->builder->BAILOUT( "Cannot load $CLASS" );

use_ok( 'Tree' );

my $dbh = DBI->connect(
    'dbi:mysql:tree', 'tree', 'tree', {
        AutoCommit => 1,
        RaiseError => 1,
        PrintError => 0,
    },
);

$dbh->do( <<"__END_SQL__" );
CREATE TEMPORARY TABLE 006_tree (
    id INT NOT NULL PRIMARY KEY
   ,parent_id INT REFERENCES 006_tree (id)
   ,value VARCHAR(255)
   ,class VARCHAR(255) NOT NULL
)
__END_SQL__

$dbh->do( <<"__END_SQL__" );
INSERT INTO 006_tree
    ( id, parent_id, value, class )
VALUES 
    ( 1, NULL, 'root', 'Tree' )
   ,( 2, NULL, 'root2', 'Tree' )
   ,( 3, 2, 'child', 'Tree' )
__END_SQL__

sub get_values {
    my $dbh = shift;
    my ($table) = @_;
    $table ||= '006_tree';

    if ( $table eq '006_tree' ) {
        my $sth = $dbh->prepare_cached( "SELECT * FROM 006_tree WHERE id > 3 ORDER BY id" );
        $sth->execute;
        return $sth->fetchall_arrayref( {} );
    }
    else {
        my $sth = $dbh->prepare_cached( "SELECT * FROM $table ORDER BY id" );
        $sth->execute;
        return $sth->fetchall_arrayref( {} );
    }
}

{
    my $tree = Tree->new( 'root' );

    my $persist = $CLASS->create_datastore({
        type  => 'DB',
        tree  => $tree,
        dbh   => $dbh,
        table => '006_tree',
        class_col => 'class',
    });

    my $values = get_values( $dbh );
    is_deeply(
        $values,
        [
            { id => 4, parent_id => undef, class => 'Tree', value => 'root' },
        ],
        "We got back what we put in.",
    );

    $dbh->do( "DELETE FROM 006_tree WHERE id > 3" );
}

{
    my $tree = Tree->new( 'A' )->add_child(
        Tree->new( 'B' ),
        Tree->new( 'C' )->add_child(
            Tree->new( 'D' ),
        ),
        Tree->new( 'E' ),
    );

    my $persist = $CLASS->create_datastore({
        type  => 'DB',
        tree  => $tree,
        dbh   => $dbh,
        table => '006_tree',
        class_col => 'class',
    });

    my $values = get_values( $dbh );
    is_deeply(
        $values,
        [
            { id => 4, parent_id => undef, class => 'Tree', value => 'A' },
            { id => 5, parent_id =>     4, class => 'Tree', value => 'B' },
            { id => 6, parent_id =>     4, class => 'Tree', value => 'C' },
            { id => 7, parent_id =>     4, class => 'Tree', value => 'E' },
            { id => 8, parent_id =>     6, class => 'Tree', value => 'D' },
        ],
        "We got back what we put in.",
    );

    $dbh->do( "DELETE FROM 006_tree WHERE id > 3" );
}

$dbh->do( <<"__END_SQL__" );
CREATE TEMPORARY TABLE 006_tree_2 (
    id INT NOT NULL PRIMARY KEY
   ,parent_id INT REFERENCES 006_tree_2 (id)
   ,value VARCHAR(255)
)
__END_SQL__

{
    my $tree = Tree->new( 'A' )->add_child(
        Tree->new( 'B' ),
        Tree->new( 'C' )->add_child(
            Tree->new( 'D' ),
            Tree->new( 'E' ),
        ),
    );

    my $persist = $CLASS->create_datastore({
        type  => 'DB',
        tree  => $tree,
        dbh   => $dbh,
        table => '006_tree_2',
    });

    my $values = get_values( $dbh, '006_tree_2' );
    is_deeply(
        $values,
        [
            { id => 1, parent_id => undef, value => 'A' },
            { id => 2, parent_id =>     1, value => 'B' },
            { id => 3, parent_id =>     1, value => 'C' },
            { id => 4, parent_id =>     3, value => 'D' },
            { id => 5, parent_id =>     3, value => 'E' },
        ],
        "We got back what we put in.",
    );

    $dbh->do( "DELETE FROM 006_tree_2" );
}
