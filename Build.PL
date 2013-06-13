use strict;
use warnings;

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
		'Test::More'          => 0.96,
#		'Test::Pod'           => 1.45, # Make it optional. See t/pod.t
#		'Test::Pod::Coverage' => 1.08, # Make it optional. See t/pod.t
	},
	configure_requires =>
	{
		'Module::Build' => 0.3800,
	},
	optional =>
	{
		'DBI'         => 1.41,
		'XML::Parser' => 0.01,
    },
	requires =>
	{
		'File::Copy'           => 0.01,
		'File::Spec'           => 0.01,
		'Module::Runtime'      => 0.013,
		'Scalar::Util'         => 1.10,
		'strict'               => 0,
		'Test::File'           => 1.10,
		'Test::File::Cleaner'  => 0.02,
		'Test::File::Contents' => 0.02,
		'warnings'             => 0,
	},
) -> create_build_script();
