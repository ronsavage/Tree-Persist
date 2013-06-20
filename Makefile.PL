use strict;
use warnings;

require 5.006000;

use ExtUtils::MakeMaker;

# ----------------------

WriteMakefile
(
	($] ge '5.005') ?
	(
		AUTHOR   => 'Rob Kinyin <rkinyon@cpan.org>',
		ABSTRACT => 'A transparent persistence layer for Tree and its children',
	) : (),
	clean =>
	{
		FILES => 'blib/* Makefile MANIFEST Lingua-EN-StopWordList-*'
	},
	dist =>
	{
		COMPRESS => 'gzip',
		SUFFIX   => 'gz'
	},
	DISTNAME  => 'Tree-Persist',
	NAME      => 'Tree::Persist',
	LICENSE   => 'artistic_2',
	PL_FILES  => {},
	PREREQ_PM =>
	{
		'base'                  => 0,
		'DBI'                   => 1.627,
		'File::Copy'            => 0.01,
		'File::Spec'            => 0.01,
		'File::Spec::Functions' => 0.01,
		'File::Temp'            => 0.01,
		'Module::Runtime'       => 0.013,
		'perl'                  => '5.006000',
		'Tree'                  => 0.15,
		'Scalar::Util'          => 1.10,
		'strict'                => 0,
		'Test::File'            => 1.10,
		'Test::File::Contents'  => 0.02,
		'Test::More'            => 0.98,
#		'Test::Pod'             => 1.45, # Make it optional. See t/pod.t
#		'Test::Pod::Coverage'   => 1.08, # Make it optional. See t/pod.t
		'Tree'                  => 1.05,
		'warnings'              => 0,
		'XML::Parser'           => 2.41,
	},
	VERSION_FROM => 'lib/Tree/Persist.pm',
);
