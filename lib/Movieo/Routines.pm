use DBIish;
use Bailador;

unit package Movieo::Routines;


sub dbconnect is export {
	my $host			= config.get('dbhost');
	my $dbtype		= config.get('dbtype');
	my $user			= config.get('dbuser');
	my $password	= config.get('dbpass');
	my $database	= config.get('dbname');

	my $dbh = DBIish.connect($dbtype, :$host, :$user, :$password, :$database);

  return $dbh;
}

sub dbinit() is export {
    my $db = dbconnect;
    my $schema = slurp 'schema.sql';
    $db.do($schema);
}

sub send_error($message, $code) is export {
}

