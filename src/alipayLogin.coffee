fs = require "fs"

phantom = require "phantomjs"

cookieJar = require "cookiejar"
_ = require 'lodash'


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
toAccount = casper.cli.get 'to'
cookiefile = casper.cli.get "cookies-file"

if username is null or password is null or toAccount is null
    # @echo("usage: casperjs  --cookies-file=cookie.txt --username=<ALIPAY_USERNAME> --password=<ALIPAY_PASSWORD> --order=<ORDER_NUMBER>  alipayLogin.js")
    @echo("usage: casperjs  --cookies-file=cookie.txt --username=<ALIPAY_USERNAME> --password=<ALIPAY_PASSWORD> --to=<TO>  alipayLogin.js")
    @exit()






home = "https://my.alipay.com/portal/oldhome.htm"
record = "https://consumeprod.alipay.com/record/index.htm"
standard = "https://consumeprod.alipay.com/record/standard.htm"

transferURL = "https://shenghuo.alipay.com/send/payment/fill.htm"


login = ->

    casper.open "https://auth.alipay.com/login/index.htm" , ->
        @echo "Title:" + @getTitle()
        @capture("loginPage.png")

        @fill 'form#login',
            'logonId': username
            'password_rsainput': password
        , false
        @wait 100
        @capture("loginPage2.png")
        @click "input[id='J-login-btn']"

transfer = (toAccount, amount)->
    casper.open transferURL
    .then ->
        url = @getCurrentUrl()
        if _.startsWith url, 'https://auth.alipay.com/login'
            @echo 'login...'
            @echo "Title:" + @getTitle()
            @capture("loginPage.png")

            @fill 'form#login',
                'logonId': username
                'password_rsainput': password
            , false
            @wait 200
            @capture("loginPage2.png")
            @click "input[id='J-login-btn']"

    casper.then ->
        url = @getCurrentUrl()
        if _.startsWith url, 'https://auth.alipay.com/login' or _.startsWith url, 'https://authgtj.alipay.com/login'
            @echo "Error login"
            @capture 'loginError.png'
            @exit()


        @echo "transfering..."
        @capture "transfer.png"
        @fill 'form#paymentForm',
            'optEmail':toAccount
            'payAmount': '0.01'
        ,false
        @wait 200
        @capture 'transfer2.png'
        @click "input[type='submit']"
        @capture 'transfer3.png'

    casper.then ->
        @click "a#J-choose-pc"
        @wait 200
        @wait

casper.start()
casper.then ->
    transfer(toAccount, 0.01)


casper.run()
