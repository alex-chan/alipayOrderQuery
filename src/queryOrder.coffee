


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
