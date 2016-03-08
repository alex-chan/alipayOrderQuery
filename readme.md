An alipay login and order query program
=======================================

Background
----------


Usage
------

first compile coffee scripts to javascript:

`coffee -c *.coffee`

basic usage

`casperjs  --cookies-file=cookie.txt --username=<ALIPAY_USERNAME> --password=<ALIPAY_PASSWORD> --order=<ORDER_NUMBER>  alipayLogin.js
`

Advanced usage

`casperjs  --output-encoding=gbk --script-encoding=gbk --cookies-file=cookie.txt  --username=<ALIPAY_USERNAME> --password=<ALIPAY_PASSWORD> --order=<ORDER_NUMBER>  alipayLogin.js
`
