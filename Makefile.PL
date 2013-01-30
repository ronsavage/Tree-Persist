use strict;
use warnings;

require 5.006000;

use ExtUtils::MakeMaker;

# ----------------------

WriteMakefile
(
	($] ge '5.005') ?
	(
		AUTHOR   => 'Rob Kinyin (rkinyon@cpan.org)',
		ABSTRACT => 'Persist multiple trees in a single db table, preserving child order',
	) : (),
	NAME         => 'Tree::Persist',
	LICENSE   => 'artistic_2',
	VERSION_FROM => 'lib/Tree/Persist.pm',
	PREREQ_PM    =>
	{
		File::Copy           => 0.01,
		File::Spec           => 0.01,
		Scalar::Util         => 1.10,
		Test::File           => 1.10,
		Test::File::Cleaner  => 0.02,
		Test::File::Contents => 0.02,
		Test::Simple         => 0.98,
		Test::Pod            => 1.45,
		Test::Pod::Coverage  => 1.08,
		Tree                 => 1.00,
		UNIVERSAL::require   => 0.10,
	},
	INSTALLDIRS => 'site',
	EXE_FILES   => [],
	PL_FILES    => {},
	test        =>
	{
		TESTS => 't/*.t t/datafiles/*.t'
	}
);
