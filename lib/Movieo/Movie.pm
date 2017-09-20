use Movieo::Movie::New;
use Movieo::Movie::Details;
use Movieo::Movie::Edit;
use Movieo::Routines;

unit package Movieo::Movie;

use Bailador;

get '/movie' => sub {
	my $db = dbconnect;
	my $sql = qq:to/END/;
	SELECT * FROM movie_details();
	END
	my $sth = $db.prepare($sql);
	$sth.execute;

	template 'movie/index.html', { movies => $sth.allrows(:array-of-hash) }
}
