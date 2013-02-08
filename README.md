## EroGetter server

EroGetter Server is a downloader suitable for adult sites.

### usage

1) start server

    bundle install       # install gems
    rackup -p 9393       # run server, see http://localhost:9393/
    bundle exec rake resque:work QUEUE=ero_getter # run downloader job

OR run with foreman

    bundle exec foreman start

OR generate export startup scripts by foreman

    bundle exec foreman export supervisor /etc/supervisor -a erogetter

2) order a url

push url to downloader job

      curl http://localhost:9393/ -d url=http://example.com/eroero/1010101.html

3) enjoy

    ls ~/ero_getter

### Support Tool
chrome extension: https://github.com/masarakki/ero_getter_chrome_extension

this extension replace 2) to one-click!

### Sites
 downloader can download only a few sites, but it will be extendable.
