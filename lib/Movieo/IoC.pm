use IoC;
use DBIish;

use Movieo::Movie::Model;
use Movieo::TVShow::Model;
use Movieo::People::Model;
use Movieo::Movie::Controller;
use Movieo::TVShow::Controller;
use Movieo::People::Controller;

unit module Movieo::IoC;

sub ioc is export {
	my $container = container 'Movieo' => contains {
		service 'MovieModel' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Movie::Model,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'TVShowModel' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::TVShow::Model,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'PeopleModel' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::People::Model,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'MovieController' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Movie::Controller,
			dependencies	=> { model => 'MovieModel' },
		};	

		service 'TVShowController' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::TVShow::Controller,
			dependencies	=> { model => 'TVShowModel' },
		};	

		service 'PeopleController' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::People::Controller,
			dependencies	=> { model => 'PeopleModel' },
		};	

		service 'dbh' => {
			lifecycle => 'Singleton',
			block			=> sub {
				my $host			= '127.0.0.1';
				my $dbtype		= 'Pg';
				my $user			= 'postgres';
				my $password	= 'pass';
				my $database	= 'movieo';

				DBIish.connect($dbtype, :$host, :$user, :$password, :$database);
			}
		};
	};

	return $container;
}
