Gem::Specification.new do |gem|
	gem.add_dependency 'tumblr_client'
	gem.add_dependency 'logger'
	gem.name = 'curate_tumblr'
	gem.version = '1.0.3'
	gem.authors = ['David Tysman']
	gem.description = 'CurateTumblr - reblog and follow Tumblr links'
	gem.summary = 'Reblog and follow Tumblr'
	gem.email = 'web@davidtysman.com'
	gem.files = `git ls-files`.split("\n")
	gem.homepage = "https://github.com/davidtysman/curate_tumblr"
end