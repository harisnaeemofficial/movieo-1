class Movieo::Movie::Model {
	has $.dbh is required;

	method list {
		my $sql = qq:to/END/;
		SELECT * FROM movie_details();
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @movies = $sth.allrows(:array-of-hash);
		return @movies;
	}

	method info(Int $id) {
		my $sql = qq:to/END/;
		SELECT * FROM movie_details ($id);
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $movie = $sth.row(:hash);
		return $movie;
	}

	method edit(Int $id) {
		my $sql = qq:to/END/;
		SELECT S.* FROM shows S
		INNER JOIN films F ON S.showid = F.showid
		WHERE S.showid = '$id';
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $movie = $sth.row(:hash);
		return $movie;
	}

	method update(Int $id, $title, $overview) {
		my $sql = qq:to/END/;
		SELECT movie_update('$title', '$overview');
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
	}

	method add(:$title, :$overview, :$releaseyear?) {
		my $sql = qq:to/END/;
		SELECT S.title FROM shows s
		INNER JOIN films f ON s.showid = f.showid;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @titles = $sth.allrows();
		if $title eq @titles.any {
			return;
		}
		else {
		my $sql = qq:to/END/;
		SELECT add_movie('$title', '$overview');
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my $movieid = $sth.row();
		return $movieid;
		}
	}
}
