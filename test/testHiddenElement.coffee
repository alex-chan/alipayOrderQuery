fs = require "fs"

casper = require("casper").create
    verbose: true
    logLevel: 'debug'
    pageSettings:
        loadImages: true
        loadPlugins: false
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
        javascriptEnabled: true
    viewportSize:
            width: 1024
            height: 768

isImgLoaded = ->
    @evaluate ->
        return window.imagesNotLoaded == 0;

casper.start()


casper.thenOpen "http://localhost:8000/hiddenElem.html",->

    @wait 200, ->
        @echo "img loaded "
        @captureSelector "testHiddenElem.png","img[id='abc']"

        @exit()


casper.run()
