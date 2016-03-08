fs = require "fs"

phantom = require "phantomjs"

#cookieJar = require "cookiejar"


# some discussion about bugs of cookie
# https://groups.google.com/forum/#!topic/phantomjs/2UbPkIibnDg

casper = require("casper").create
  verbose: true
  logLevel: 'debug'
  pageSettings:
    loadImages: false
    loadPlugins: false
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36'
    javascriptEnabled: true
  # viewportSize: {width: 1024, height: 768}


username = casper.cli.get 'username'
password = casper.cli.get 'password'
bookorder = casper.cli.get 'order'
cookiefile = casper.cli.get "cookies-file"

if username is null or password is null or bookorder is null
    @echo("usage: casperjs  --cookies-file=cookie.txt --username=<ALIPAY_USERNAME> --password=<ALIPAY_PASSWORD> --order=<ORDER_NUMBER>  alipayLogin.js")
    @exit()






home = "https://my.alipay.com/portal/oldhome.htm"
record = "https://consumeprod.alipay.com/record/index.htm"
standard = "https://consumeprod.alipay.com/record/standard.htm"




login = ->

    casper.start "https://auth.alipay.com/login/index.htm" , ->
        @echo "Title:" + @getTitle()
        @capture("loginPage.png")

        @fill 'form[id="login"]',
            'logonId': username
            'password_rsainput': password
        , false

        casper.wait 50
        @click "input[id='J-login-btn']"

casper.start()
casper.echo username



cookiefile = "cookie.txt"

casper.echo "cookie:" + casper.cookies


if cookiefile != undefined and fs.isFile cookiefile

    casper.echo "OK cookies's there "

#    casper.cookies = JSON.parse fs.read(cookiefile)

    casper.echo casper.page.cookies

    casper.thenOpen home , ->
        @echo "started home"



    casper.wait 5000,  ->
        @capture("homePage.png")

        url =  @getCurrentUrl()
        @echo "current url:" + url
        @echo "title is :" + @getTitle()
        if url.indexOf("my.alipay.com") == -1
            errText = @fetchText "span[class='sl-error-text']"

            @echo "Login failed: " + errText

            @echo "encoding:" +casper.outputEncoding
            casper.outputEncoding = "gbk"

            @echo "encoding2:" +casper.outputEncoding
            @echo errText
            casper.outputEncoding = "utf8"
            @echo "encoding2:" +casper.outputEncoding
            @echo errText
            console.log errText
            # @echo icov.decode(errText, 'GBK')

            fs.write "err.txt", errText

            casper.wait 1000


            @exit()

        @click 'a[href="'+record+'"]'


    casper.wait 2000

    casper.then ->
        @capture("myRecords.png")
        @fill "form[id='topSearchForm']",
            "keyValue": bookorder
        , true

#        casper.wait 50
#        @click "a[href='J-keyword-btn']"


    casper.wait 3000
    casper.then ->
        @capture("queryResult.png")
        if not @exists "table[id='tradeRecordsIndex'] tr[id='J-item-1']"
            @echo "No such order"
        else
            @echo( @fetchText "span[class='amount-pay-in']" )


        @exit()

else
    casper.echo "no cookie"



casper.run()