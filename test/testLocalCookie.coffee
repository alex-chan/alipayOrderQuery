fs = require "fs"

casper = require("casper").create
    verbose: true
    logLevel: 'debug'
    pageSettings:
        loadImages: false
        loadPlugins: false
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
        javascriptEnabled: true
# viewportSize: {width: 1024, height: 768}

casper.start()

casper.echo "cookie before request:"
casper.echo  " sfds" + casper.page.cookies
casper.echo  casper.cookies


casper.thenOpen "http://localhost:8000/",->

    @echo @getTitle()
    @echo "cookies:"
    @echo casper.cookies
    @echo casper.page.cookies

    @exit()


casper.run()
