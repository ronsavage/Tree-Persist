use warnings;
use strict;

require 5.006000;

use Module::Build;

# ----------------

Module::Build -> new
(
	module_name    => 'Tree::Persist',
	license        => 'artistic_2',
	dist_abstract  => 'A transparent persistence layer for Tree and its children',
	dist_author    => 'Rob Kinyon <rkinyon@cpan.org>',
	build_requires =>
	{
		'Test::More' => 1.001014,
		'Test::Pod' => 1.48,
		'Test::Pod::Coverage' => 1.10,
	},
	configure_requires =>
	{
		'Module::Build' => 0.4211,
	},
	requires =>
	{
		'base' => 0,
		'DBD::SQLite' => 1.39,
		'DBI' => 1.627,
		'File::Slurp' => 9999.19,
		'File::Spec::Functions' => 0.01,
		'File::Spec' => 0.01,
		'File::Temp' => 0.01,
		'Module::Runtime' => 0.013,
		'Scalar::Util' => 1.10,
		'strict' => 0,
		'Test::File' => 1.10,
		'Test::File::Contents' => 0.02,
		'Tree' => 1.05,
		'warnings' => 0,
		'XML::Parser' => 2.41,
	},
) -> create_build_script();
