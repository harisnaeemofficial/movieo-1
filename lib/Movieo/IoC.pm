use IoC;
use DBIish;

use Movieo::Model::Movie;
use Movieo::Model::TVShow;
use Movieo::Model::People;
use Movieo::Controller::Movie;
use Movieo::Controller::TVShow;
use Movieo::Controller::People;

unit module Movieo::IoC;

sub setup-ioc is export {
	my $container = container 'Movieo' => contains {
		service 'ModelMovie' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Model::Movie,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'ModelTVShow' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Model::TVShow,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'ModelPeople' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Model::People,
			dependencies	=> { dbh => 'dbh' },
		};

		service 'ControllerMovie' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Controller::Movie,
			dependencies	=> { model => 'ModelMovie' },
		};	

		service 'ControllerTVShow' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Controller::TVShow,
			dependencies	=> { model => 'ModelTVShow' },
		};	

		service 'ControllerPeople' => {
			lifecycle			=> 'Singleton',
			type					=> Movieo::Controller::People,
			dependencies	=> { model => 'ModelPeople' },
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
