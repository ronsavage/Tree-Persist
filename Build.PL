use Module::Build;

use 5.6.0;

use strict;
use warnings;

Module::Build -> new
(
	dist_abstract => 'A transparent persistence layer for Tree and its children',
	module_name   => 'Tree::Persist',
	license       => 'perl',
	requires      =>
	{
		perl               => '5.6.0',
		Scalar::Util       => '1.10',
		Tree               => '1.00',
		UNIVERSAL::require => '0.10',
    },
	optional =>
	{
		DBI         => '1.41',
		XML::Parser => '0.01',
    },
	configure_requires =>
	{
		Module::Build => '0.40',
	},
	build_requires =>
	{
		File::Copy           => '0.01',
		File::Spec           => '0.01',
		Scalar::Util         => '1.10',
		Test::More           => '0.47',
		Test::File           => '1.10',
		Test::File::Cleaner  => '0.02',
		Test::File::Contents => '0.02',
	},
	create_makefile_pl   => 'traditional',
	recursive_test_files => 1,
	add_to_cleanup       =>
	[
		'META.yml', '*.bak', '*.gz', 'Makefile.PL',
	],
) -> create_build_script;
