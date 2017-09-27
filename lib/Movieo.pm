use Bailador;
use Movieo::IoC;
use Movieo::Movie;
use Movieo::TVShow;
use Movieo::People;


class Movieo {
	method setup-ioc() {
		container ioc();
	}

	method setup-routes {	
		get		'/' => sub {
			template 'index.html', :layout('landing-page.html');
		};

		Movieo::Movie.routes;
		Movieo::TVShow.routes;
		Movieo::People.routes;

		static-dir / (.*) / => 'assets/';
	}

	method start {
		self.setup-ioc();
		self.setup-routes();
  	baile;
  }
}
