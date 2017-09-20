use Movieo::Routines;

unit package Movieo::Movie::New;

use Bailador;


get '/movie/new' => sub {
	template 'movie/new.html', { }
}

post '/movie/new' => sub {
	my $title				= request.params<title>;
	my $releaseyear	= request.params<releaseyear>;
	my $overview		= request.params<overview>;
	say "Title" ~ $title;
	my $showid;
	my $db = dbconnect;
	my $sql = q:to/END/;
	SELECT S.title FROM shows S
	INNER JOIN films F ON S.showid = F.showid;
	END

	my $sth = $db.prepare($sql);
	$sth.execute;
	my @titles = $sth.allrows;

	if $title eq @titles.any {
		my $sql = "SELECT showid FROM shows WHERE title = '$title';";
		my $sth = $db.prepare($sql);
		$sth.execute;
		$showid = $sth.allrows;
	}
	else {
		my $sql = "SELECT add_movie('$title', '$overview');";
		my $sth = $db.prepare($sql);
		$sth.execute;
	say "Title" ~ $title;
		return redirect '/';
	}


	template 'movie/new.html', { showid => $showid }
}

