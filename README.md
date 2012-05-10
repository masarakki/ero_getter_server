## EroGetter server

EroGetter Server is a downloader suitable for adult sites.

### usage

1) start server

    bundle install       # install gems
    rake backend:start   # run downloader job, you can stop it by
                         # rake backend:stop
    shotgun              # run server, see http://localhost:9393/

now, you can't customize any configurations, but it will be fixed soon.

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
