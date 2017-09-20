use Movieo::Routines;

unit package Movieo::Movie::Edit;

use Bailador;

get '/movie/(<digit>+)/edit' => sub ($movieid) {
	my $db = dbconnect;
	my $sql = qq:to/END/;
	SELECT S.* FROM shows S
	INNER JOIN films F ON S.showid = F.showid
	WHERE S.showid = '$movieid';
	END
	my $sth = $db.prepare($sql);
	$sth.execute;

	template 'movie/edit.html', { movie => $sth.row(:hash) }
}

post '/movie/(<digit>+)/edit' => sub ($movieid) {
	my $title			= request.params<title>;
	my $overview	= request.params<overview>;
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
		return redirect '/';
	}


	template 'movie/edit.html', { showid => $showid }
}
