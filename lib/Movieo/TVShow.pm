use Bailador;

class Movieo::TVShow {

	method routes() {
		get		'/tvshow'	=> {
			service => 'TVShowController',
			to			=> 'list'
		}

		get		'/tvshow/info/:id'	=> {
			service => 'TVShowController',
			to			=> 'info'
		}

		get		'/tvshow/edit/:id'	=> {
			service => 'TVShowController',
			to			=> 'edit'
		}

		post	'/tvshow/edit/:id'	=> {
			service => 'TVShowController',
			to			=> 'update'
		}

		get		'/tvshow/add'	=> sub {
			template '/tvshow/add/index.html';
		}

		post	'/tvshow/add'	=> {
			service => 'TVShowController',
			to			=> 'add'
		}
	}
}
