unit package Movieo;
#
use Movieo::Movie;
use Movieo::Tv;
use Movieo::People;

use Bailador;

get '/' => sub {
	#	my $layout = 'landing-page.html';
	template 'index.html', layout => 'landing-page.html', { version => config.get('version') }
}

static-dir / (.*) / => $?FILE.IO.parent.child('../assets/');
