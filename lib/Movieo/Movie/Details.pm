use Movieo::Routines;

unit package Movieo::Movie::Details;

use Bailador;

get '/movie/(<digit>+)' => sub ($movieid) {
	my $db = dbconnect;
	my $sql = "SELECT * FROM movie_details ($movieid)";
	my $sth = $db.prepare($sql);
	$sth.execute;

	template 'movie/details.html', { movie => $sth.row(:hash) }
}
