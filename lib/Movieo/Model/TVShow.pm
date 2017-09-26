class Movieo::Model::TVShow {
	has $.dbh is required;

	method tvshow-list {
		my $sql = qq:to/END/;
		SELECT * FROM tvshow_details();
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @tvshows = $sth.allrows(:array-of-hash);
		return @tvshows;
	}

	method tvshow-info(Int $id) {
		my $sql = qq:to/END/;
		SELECT * FROM tvshow_details ($id);
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method tvshow-edit(Int $id) {
		my $sql = qq:to/END/;
		SELECT s.* FROM shows s
		INNER JOIN tvshows t ON S.showid = t.showid
		WHERE S.showid = '$id';
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;

		my $tvshow = $sth.row(:hash);
		return $tvshow;
	}

	method tvshow-update(Int $id, $title, $overview) {
		my $sql = qq:to/END/;
		SELECT tvshow_update('$title', '$overview');
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
	}

	method tvshow-add(:$title, :$overview, :$releaseyear?) {
		my $sql = qq:to/END/;
		SELECT s.title FROM shows s
		INNER JOIN tvshows t ON s.showid = t.showid;
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my @titles = $sth.allrows();
		if $title eq @titles.any {
			return;
		}
		else {
		my $sql = qq:to/END/;
		SELECT add_tvshow('$title', '$overview');
		END

		my $sth = $!dbh.prepare($sql);
		$sth.execute;
		my $tvshowid = $sth.row();
		return $tvshowid;
		}
	}
}
