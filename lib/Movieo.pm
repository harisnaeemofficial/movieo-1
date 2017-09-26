use Bailador;
use Movieo::IoC;
use Movieo::Controller::Movie;


class Movieo {
	submethod TWEAK(|) {
		container setup-ioc();
		
		get		'/' => sub {
			template 'index.html', :layout('landing-page.html');
		};

		get		'/movie'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-list'
		}

		get		'/movie/info/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-info'
		}

		get		'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-edit'
		}

		post	'/movie/edit/:id'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-update'
		}

		get		'/movie/add'	=> sub {
			template '/movie/add/index.html';
		}

		post	'/movie/add'	=> {
			service => 'ControllerMovie',
			to			=> 'movie-add'
		}

		static-dir / (.*) / => 'assets/';
	}

	method start {
  	baile;
  }
}
