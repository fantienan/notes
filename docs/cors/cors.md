前言

小明一个星期的成长故事。今日前端早读课文章由@huli 授权分享。

正文从这开始~~

在 【第 2224 期】CORS 完全手册之如何解决 CORS 问题？ 里面我们提到了常见的 CORS 错误解法，以及大多数状况下应该要选择的解法：「请后端加上 response header」。

但其实「跨来源请求」这个东西又可以再细分成两种，简单请求跟非简单请求，简单请求的话可以透过上一篇的解法来解，但非简单请求的话就比较复杂一些了。

除此之外，跨来源请求预设是不会把 cookie 带上去的，需要在使用 xhr 或是 fetch 的时候多加一个设定，而后端也需要加一个额外的 header 才行。

与 CORS 相关的 header 其实不少，有些你可能听都没听过。原本这篇我想要把这些东西一一列出来讲解，但仔细想了一下觉得这样有点太无趣，而且大家应该看过就忘记了。

那怎样的方法会比较好呢？大家都喜欢听故事，因此这篇让我们从故事的角度下手，为大家讲述一段爱与 CORS 的故事。

主角的名字大家都知道了，对，就是毫无新意的小明。

Day1：简单的 CORS

小明任职于某科技公司，担任菜鸟前端工程师。

而他的第一个任务，就是要做一个「联络我们」的表单，让看到官网，对他们服务有兴趣的潜在使用者能够联络到公司的人，再让业务去跟他们联络，洽谈后续的合作事项。

而表单长这样（虽然长得很像 Goolge 表单但是是小明自己做的）：

小明花了半天不到的时间，把页面都刻好了，功能也差不多做完了，只剩下最后一步而已。小明的主管跟他说公司常常会对外举办一些活动，而在活动尾声都会提供这个表单给大家，希望大家统一透过表单留下联络资料。

因此表单上的「怎么知道我们公司的？」就会希望能够动态调整栏位，在活动期间加一个「透过在 1/10 举办的技术分享会」的选项，而活动结束后大概两个礼拜把这个选项撤掉。之所以要能动态调整，主管说是因为不想让后续维护的工再回到开发这端，如果一开始就能做成动态的，那未来只要他们自己维护就行了，让他们能够透过后台自己去控制。

所以后端开了一个 API 出来，要小明去接这个 API 然后把内容 render 出来变成选项。为了方便测试，后端工程师先把整个 API service 打包成 docker image，然后让小明跑在自己电脑上，网址是：http://localhost:3000

小明接到这个任务之后，想说先把 API 内容抓下来看看好了，于是就写了这样一段程式码：

fetch ( 'http://localhost:3000' )

然后发现 console 出现了错误讯息：

小明没有看得很懂那是什么意思，只注意到了最后一段：

If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.

于是帮 fetch 加上了 no-cors 的 mode：

fetch ( 'http://localhost:3000' , {
mode : 'no-cors'
}). then ( res => console . log ( res ))

改完之后重新整理，发现没有错误了，可是印出来的 response 长得特别奇怪：

没有任何资料，而且 status 居然是 0。小明在这之后 debug 很久，找不出原因，不知道为什么就是拿不到资料。眼看死线将近，小明鼓起勇气去求助了前辈小华，小华跟他说：

这是当然的啊，no-cors 是个很容易误导初学者的参数，他的意思并不是「绕过 cors 拿到资料」，而是「我知道它过不了 cors，但我没差，所以不要给我错误也不要给我 response」

你这问题一定要透过后端去解，我帮你跟后端说一声吧

小华前辈不愧资深，三两下就解决了小明的问题。而后端那边也帮忙加上了一个 header：Access-Control-Allow-Origin: \*，代表来自任何 origin 的网站都可以用 AJAX 存取这个资源。

后端程式码：

app . get ( '/' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' )
res . json ({
data : db . getFormOptions ,
})
})

小明把原本的 mode 拿掉，改成：

fetch ( 'http://localhost:3000' )
. then ( res => res . json )
. then ( res => console . log ( res ))

打开了浏览器，发现可以成功拿到选项了，也从 network tab 里面看到了新增加的 header：

拿到资料以后，就只剩下把选项放上去画面而已，大概又半天的时间，小明就把这个功能做完并且测试完了，感谢小华前辈的帮助。

Day1 总结

mode: 'no-cors' 跟你想的不一样，这个没有办法解决 CORS 问题。

碰到 CORS 问题的时候，先确认后端有没有给你 Access-Control-Allow-Origin 这个 header，没有的话请后端给你，否则你怎么试都不会过。

Access-Control-Allow-Origin 的值可以带\*，代表 wildcard，任何 origin 都合法，也可以带 origin 像是，代表只有这个 origin 是合法的。

如果想带多个的话呢？抱歉，没有办法，就是只能全部都给过或者是给一个 origin。因此也有后端会根据 request 的 origin 来决定 response 的 Access-Control-Allow-Origin 值会是多少，这个我们之后会再提到。

Day2：不简单的 CORS

隔了一天之后，主管跟小明说更上层的人不满意这个使用者体验，送出表单之后要等个一两秒才能看到成功的画面，而且这中间也没有 loading 什么的，体验不好，希望能改成 AJAX 的做法送出表单而不是换页，就可以改善使用者体验。

为了因应这个改变，后端又多出了一个 API：POST /form，而且这次后端已经很自动地把 Access-Control-Allow-Origin 的 header 加上去了：

app . post ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' ) //省略写到 db 的程式码
res . json ({ success : true })
})

小明之前已经做过类似的事情，因此很快就把程式码写好了：

document . querySelector ( '.contact-us-form' )
. addEventListener ( 'submit' , ( e ) => { //阻止表单送出
e . preventDefault
//设置参数
var data = new URLSearchParams ; data . append ( 'email' , ' test@test.com ' ) data . append ( 'source' , 'search' )
//送出 request
fetch ( 'http://localhost:3000/form' , {
method : 'POST' ,
headers : { 'Content-Type' : 'application/x-www-form-urlencoded' },
body : data
}). then ( res => res . json ). then ( res => console . log ( res ))
})

测试之后也没有问题，正当小明要跟主管报告做好的时候，后端走过来跟小明说：「不好意思，我们后端最近做了一些改动，未来要统一改成用 JSON 当作资料格式，所以你那边也要改一下，要送 JSON 过来而不是 urlencoded 的资料」

小明听了之后心想：「这简单嘛，不就是改一下资料格式吗？」，于是改成这样：

document . querySelector ( '.contact-us-form' )
. addEventListener ( 'submit' , ( e ) => {
//阻止表单送出
e . preventDefault
//设置参数
var data = {
email : 'test@test.com' ,
soruce : 'search'
}
//送出 request
fetch ( ' http://localhost:3000/form ' , {
method : 'POST' ,
headers : { 'Content-Type' : 'application/json' },
body : JSON . stringify ( data )
} ). then ( res => res . json ). then ( res => console . log ( res ))
})

就只是换一下资料格式而已，改成用 JSON 的方式传资料到后端。改完之后小明再测试了一遍，发现这一次居然挂掉了，而且出现错误讯息：

Access to fetch at ' http://localhost:3000/form ' from origin 'null' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource. If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.

切到 network tab 去看 request 的状况，发现除了原本预期的 POST 以外，还多了一个 OPTIONS 的 request：

小明上网用错误讯息给的关键字：preflight request 找了一下资料，发现 CORS 没有他想像中的简单。

原来之前发送的那些请求都叫做「简单请求」，只要 method 是 GET、POST 或是 HEAD 然后不要带自订的 header，Content-Type 也不要超出：application/x-www-form-urlencoded、multipart/form-data 或是 text/plain 这三种，基本上就可以被视为是「简单请求」（更详细的定义下一篇会说）。

一开始串 API 的时候没有碰到错误，是因为 Content-Type 是 application/x-www-form-urlencoded，所以被视为是简单请求。后来改成 application/json 就不符合简单请求的定义了，就变成是「非简单请求」。

那非简单请求会怎么样呢？会多送出一个东西，叫做 preflight request，中文翻作「预检请求」。这个请求就是小明在 network tab 看到的那个 OPTIONS 的 request，针对这个 request，浏览器会帮忙带上两个 header：

Access-Control-Request-Headers
Access-Control-Request-Method

以刚刚我们看到的/form 的 preflight request 来说，内容是：

Access-Control-Request-Headers: content-type
Access-Control-Request-Method: POST

前者会带上不属于简单请求的 header，后者会带上 HTTP Method，让后端对前端想送出的 request 有更多的资讯。

如果后端愿意放行，就跟之前一样，回一个 Access-Control-Allow-Origin 就好了。知道这点以后，小明马上请后端同事补了一下，后端程式码变成：

app . post ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '_' )
res . json ({
success : true
})
})
//多加这个，让 preflight 通过
app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '_' )
res . end
})

改好以后小明重新试了一下，发现居然还是有错误：

Access to fetch at ' http://localhost:3000/form ' from origin 'null' has been blocked by CORS policy: Request header field content-type is not allowed by Access-Control-Allow-Headers in preflight response.

当你的 CORS request 含有自订的 header 的时候，preflight response 需要明确用 Access-Control-Allow-Headers 来表明：「我愿意接受这个 header」，浏览器才会判断预检通过。

而在这个案例中，content-type 就属于自订 header，所以后端必须明确表示愿意接受这个 header：

app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' )
res . header ( 'Access-Control-Allow-Headers' , ' content-type' )
res . end
})

如此一来，小明那边就可以顺利通过 preflight request，只有在通过 preflight 之后，真正的那个 request 才会发出。

流程会像是这样：

我们要送出 POST 的 request 到 http://localhost:3000/form
浏览器发现是非简单请求，因此先发出一个 preflight request
检查 response，preflight 通过
送出 POST 的 request 到 http://localhost:3000/form

所以如果 preflight 没有过，第一个步骤的 request 是不会被送出的。

经历过一番波折之后，这个改动总算也顺利完成了。现在我们可以成功在前端用 AJAX 的方式送出表单资料了。

Day2 总结

CORS request 分成两种：简单请求与非简单请求，无论是哪一种，后端都需要给 Access-Control-Allow-Origin 这个 header。而最大的差别在于非简单请求在发送正式的 request 之前，会先发送一个 preflight request，如果 preflight 没有通过，是不会发出正式的 request 的。

针对 preflight request，我们也必须给 Access-Control-Allow-Origin 这个 header 才能通过。

除此之外，有些产品可能会想要送一些自订的 header，例如说 X-App-Version 好了，带上目前网站的版本，这样后端可以做个纪录：

fetch ( ' http://localhost:3000/form' , {
method : 'POST' ,
headers : { 'X-App-Version' : "v0.1" , 'Content-Type' : 'application/json' } ,
body : JSON . stringify ( data )
}). then ( res => res . json ). then ( res => console . log ( res ))

当你这样做以后，后端也必须新增 Access-Control-Allow-Headers，才能通过 preflight：

app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' )
res . header ( 'Access-Control-Allow-Headers' , ' X-App-Version, content-type' )
res . end
})

简单来说，preflight 就是一个验证机制，确保后端知道前端要送出的 request 是预期的，浏览器才会放行。我之前所说的「跨来源请求挡的是 response 而不是 request」，只适用于简单请求。对于有 preflight 的非简单请求来说，你真正想送出的 request 确实会被挡下来。

那为什么会需要 preflight request 呢？这边可以从两个角度去思考：

相容性
安全性

针对第一点，你可能有发现如果一个请求是非简单请求，那你绝对不可能用 HTML 的 form 元素做出一样的 request，反之亦然。举例来说， <form>的 enctype 不支援 application/json，所以这个 content type 是非简单请求；enctype 支援 multipart/form，所以这个 content type 属于简单请求。

对于那些古老的网站，甚至于是在出现之前就存在的网站，他们的后端没有预期到浏览器能够发出 method 是 DELETE 或是 PATCH 的 request，也没有预期到浏览器会发出 content-type 是 application/json 的 request，因为在那个时代 <form>跟 <img>等等的元素是唯一能发出 request 的方法。

那时候根本没有 fetch，甚至连 都没有。所以为了不让这些后端接收到预期外的 request，就先发一个 preflight request 出去，古老的后端没有针对这个 preflight 做处理，因此就不会通过，浏览器就不会把真正的 request 给送出去。

这就是我所说的相容性，通过预检请求，让早期的网站不受到伤害，不接收到预期外的 request。

而第二点安全性的话，还记得在第一篇问过大家的问题吗？送出 POST request 删除文章的那个问题。删除的 API 一般来说会用 DELETE 这个 HTTP method，如果没有 preflight request 先挡住的话，浏览器就会真的直接送这个 request 出去，就有可能对后端造成未预期的行为（没有想到浏览器会送这个出来）。

所以才需要 preflight request，确保后端知道待会要送的这个 request 是合法的，才把真正的 request 送出去。

Day3：带上 Cookie

昨天改的那版受到上层的极力赞赏，主管也请小明跟小华喝了手摇饮来庆祝。只是正当他们开心之时，行销部门的人跑来了，问说：「为什么这些 request 都没有 cookie？我们需要使用者的 cookie 来做分析，请把这些 cookie 带上」。

此时小明才突然想起来：「对欸，跨来源的请求，预设是不会带 cookie 的」，查了一下 MDN 之后，发现只要带：credentials: 'include'应该就行了：

fetch ( ' http://localhost:3000/form' , {
method : 'POST' ,
credentials : 'include' , //新增这个
headers : { 'Content-Type' : 'application/json' },
body : JSON . stringify ( data ) }
). then ( res => res . json ). then ( res => console . log ( res ))

可是没想到前端却出现了错误讯息：

Access to fetch at ' http://localhost:3000/form ' from origin ' http://localhost:8080 ' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: The value of the ' Access-Control-Allow-Origin' header in the response must not be the wildcard '\*' when the request's credentials mode is 'include'.

错误讯息其实已经解释得很清楚了，如果要带上 cookie 的话，那 Access-Control-Allow-Origin 不能是\*，一定要明确指定 origin。

为什么会这样呢？因为如果没有这个限制的话，那代表任何网站（任何 origin）都可以发 request 到这个 API，并且带上使用者的 cookie，这样就会有安全性的问题产生，大概就跟 CSRF 有异曲同工之妙。

所以因为安全性的关系，强制你如果要带上 cookie，后端一定要明确指定是哪个 origin 有权限。除此之外，后端还要额外带上 Access-Control-Allow-Credentials: true 这个 header。

于是小明再度请小华改一下后端：

const VALID_ORIGIN = ' http :// localhost : 8080 '
app . post ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN ) //明确指定
res . header ( 'Access-Control-Allow-Credentials' , true ) //新增这个
res . json ({
success : true
})
})
app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN ) //明确指定
res . header ( 'Access-Control-Allow-Credentials' , true ) //新增这个
res . header ( 'Access-Control-Allow-Headers' , 'content-type, X-App-Version' )
res . end
})

改完之后的版本明确指定才有权限存取 CORS Response，也加上了这个 header。http://localhost:8080Access-Control-Allow-Credentials

如此一来就大功告成了，在发送 request 的时候可以成功带上 Cookie，行销部门那边的需求也搞定了，耶依。

Day3 总结

如果你需要在发送 request 的时候带上 cookie，那必须满足三个条件：

后端 Response header 有 Access-Control-Allow-Credentials: true
后端 Response header 的 Access-Control-Allow-Origin 不能是\*，要明确指定
前端 fetch 加上 credentials: 'include'

这三个条件任何一个不满足的话，都是没办法带上 cookie 的。

除了这个之外还有一件事情要特别注意，那就是不只带上 cookie，连设置 cookie 也是一样的。后端可以用 Set-Cookie 这个 header 让浏览器设置 cookie，但一样要满足上面这三个条件。如果这三个条件没有同时满足，那尽管有 Set-Cookie 这个 header，浏览器也不会帮你设置，这点要特别注意。

事实上呢，无论有没有想要存取 Cookie，都会建议 Access-Control-Allow-Origin 不要设定成\*而是明确指定 origin，避免预期之外的 origin 跨站存取资源。若是你有多个 origin 的话，建议在后端有一个 origin 的清单，判断 request header 内的 origin 有没有在清单中，有的话就设定 Access-Control-Allow-Origin，没有的话就不管它。

Day4：存取自订 header

还记得我们一开始串的那一个 API 吗？跟后端拿选项的 API。虽然之前已经顺利完成，但没想到有陨石砸下来了。今天早上上面说要加一个新的需求。

这个需要是要对这个 API 的内容做版本控制，后端会在 response header 里面多带上一个 header：X-List-Version，来让前端知道这个选项的清单是哪一个版本。

而前端则是要拿到这个版本，并且把值放到表单里面一起送出。

后端会像是这样：

app . get ( '/' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' )
res . header ( 'X-List-Version' , '1.3' )
res . json ({
data : [
{ name : '1/10 活动' , id : 1 },
{ name : '2/14 特别活动' , id : 2 }
]
})
})

由于这一个 API 的内容本来就是公开的，所以没有允许特定的 origin 也没有关系，可以安心使用 wildcard。

小明把之前的程式码改了一下，试着把 header 先列印出来看看：

fetch ( ' http://localhost:3000' )
. then ( res => { console . log ( res . headers . get ( 'X-List-Version' )) return res . json })
. then ( res => console . log ( res ))

此时，神奇的事情发生了。明明从 network tab 去看，确实有我们要的 response header，但是在程式里面却拿不到，输出 null。小明检查了几遍，确定字没打错，而且没有任何错误讯息，但就是拿不到。

卡了一个小时之后，小明决定再次求助前辈小华。小华身为资深前辈，一看到这个状况之后就说了：

如果你要存取 CORS response 的 header，尤其是这种自定义的 header 的话，后端要多带一个 Access-Control-Expose-Headers 的 header 喔，这样前端才拿得到

「原来是这样吗！」小明恍然大悟，去找了后端的同事，让他加上这个 header：

app . get ( '/' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , '\*' )
res . header ( 'Access-Control-Expose-Headers' , 'X -List-Version' ) //加这个
res . header ( 'X-List-Version' , '1.3' )
res . json ({
data : [
{ name : '1/10 活动' , id : 1 },
{ name : '2/14 特别活动' , id : 2 }
]
})
})

改完之后小明再测试一遍，发现果真可以正确拿到 header 了！感恩小华，赞叹小华，平安的一天又度过了。

Day4 总结

当你拿到跨来源的 response 的时候，基本上都可以拿到 response body，也就是内容。但是 header 就不一样了，只有几个基本的 header 可以直接拿到，例如说 Content-Type 就是一个。

除此之外，如果你想拿其他 header，尤其是自定义的 header 的话，后端就需要带上 Access-Control-Expose-Headers，让浏览器知道说：「我愿意把这个 header 开放出去让 JS 看到」，这样子前端才能顺利抓到 header。

如果没有加的话就会拿到 null，就跟这个 header 不存在一样。

Day5：编辑资料

原本以为一切都很顺利的小明又再次踢到了铁板。这次是老板那边提出的需求，现在一送出表单之后就没机会再更改了，若是使用者意识到哪边有填错，就只能重新再填一遍。而老板觉得这样的体验不好，希望在使用者送出表单以后还有一次机会能够挽回，可以编辑刚刚送出的表单。

跟后端讨论过后，在送出表单之后后端会给一个 token，前端只要带着这个 token 去打 PATCH /form 这个 API，就能够编辑刚刚表单的内容。

后端长得像这样，一样有把该加的 header 都加好：

const VALID_ORIGIN = ' http :// localhost : 8080 '
app . patch ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN )
res . header ( ' Access-Control-Allow-Credentials' , true )
//省略编辑的部分
res . json ({ success : true })
})
app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN )
res . header ( 'Access-Control-Allow-Credentials' , true )
res . header ( 'Access-Control-Allow-Headers' , 'content-type, X-App-Version' )
res . end
})

而小明立刻开始着手前端的部分，大概像是这样：

fetch ( 'http://localhost:3000/form' , {
method : 'PATCH' ,
credentials : 'include' ,
headers : { 'X-App-Version' : "v0.1" , 'Content-Type' : 'application/json' },
body : JSON . stringify ({
token : 'test_token' ,
content : 'new content'
})
}). then ( res => res . json ). then ( res => console . log ( res ))

其实跟之前送出表单的程式码八七分像，差别大概只在 body 跟 method 的部分。然而，小明在测试的时候，浏览器又跳出错误了：

Access to fetch at ' http://localhost:3000/form ' from origin ' http://localhost:8080 ' has been blocked by CORS policy: Method PATCH is not allowed by Access-Control-Allow-Methods in preflight response.

跨来源的请求只接受三种 HTTP Method：GET、HEAD 以及 POST，除了这三种之外，都必须由后端回传一个 Access-Control-Allow-Methods，让后端决定有哪些 method 可以用。

因此后端要改成这样：

// preflight
app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN )
res . header ( 'Access-Control-Allow-Credentials' , true )
res . header ( 'Access-Control-Allow-Methods' , 'PATCH' ) //多这个
res . header ( 'Access-Control-Allow-Headers' , 'content-type, X-App-Version' )
res . end
})

如此一来，浏览器就知道前端能够使用 PATCH 这个 method，就不会把后续的 request 给挡下来了。

Day5 总结

如果前端要使用 GET、HEAD 以及 POST 以外的 HTTP method 发送请求的话，后端的 preflight response header 必须有 Access-Control-Allow-Methods 并且指定合法的 method，preflight 才会通过，浏览器才会把真正的 request 发送出去。

这个就跟前面提过的 Access-Control-Allow-Headers 有点像，只是一个是在规范可以用哪些 method，一个是在规范可以用哪些 request headers。

Day6：快取 preflight request

好不容易满足了公司各个大头的需求，没想到在上线前夕，技术这端出问题了。小明原本以为解掉了所有跨来源的问题就行了，可是却忽略了一个地方。在 QA 对网站做压测的时候，发现 preflight request 的数量实在是太多了，而且就算同一个使用者已经预检过了，每次都还是需要再检查，其实满浪费效能的。

于是 QA 那边希望后端可以把这个东西快取住，这样如果同一个浏览器重复发送 request，就不用再做预检。

虽然说小明是做前端的，但他其实想成为 CORS 大师，于是就跟后端一起研究该怎么解决这个问题。最后他们找到了一个 header：Access-Control-Max-Age，可以跟浏览器说这个 preflight response 能够快取几秒。

接着后端把这个 header 加上去：

app . options ( '/form' , ( req , res ) => {
res . header ( 'Access-Control-Allow-Origin' , VALID_ORIGIN )
res . header ( 'Access-Control-Allow-Credentials' , true )
res . header ( 'Access-Control-Allow-Headers' , 'content-type, X-App-Version' )
res . header ( 'Access-Control-Max-Age' , 300 )
res . end
})

这样 preflight response 就会被浏览器快取 300 秒，在 300 秒内对同一个资源都不会再打到后端去做 preflight，而是会直接沿用快取的资料。

总结

让我们一个一个来回忆故事中出现的各个 header。

一开始小明需要存取跨来源请求的 response，因此需要后端协助提供 Access-Control-Allow-Origin，证明这个 origin 是有权限的。

再来因为要带自订的 header，所以后端要提供 Access-Control-Allow-Headers，写明 client 可以带哪些 header 上去。同时也因为多了 preflight requset，后端要特别处理 OPTIONS 的 request。

然后我们需要用到 cookie，所以 Access-Control-Allow-Origin 不能是\*，要改成单一的 origin。而后端也要多提供 Access-Control-Allow-Credentials: true。

接着前端需要存取 header，所以后端必须提供 Access-Control-Expose-Headers，跟浏览器说前端可以拿到哪些 header。而前端如果要使用 HEAD、GET 跟 POST 之外的 method，后端要加上 Access-Control-Allow-Methods。

关于快取的部分，则是用 Access-Control-Max-Age。

整串故事看下来，其实你会发现根本没什么前端的事情。前端在整个故事中担任的角色就是：写 code => 发现错误=> 回报后端=> 后端修正=> 完成功能。这也呼应了我之前一再强调的：「CORS 的问题，通常都不是前端能解决的」。

说穿了，CORS 就是藉由一堆的 response header 来跟浏览器讲说哪些东西是前端有权限存取的。如果没有后端给的这些 header，那前端根本什么也做不了。因此无论是前端还是后端，都有必要知道这些 header，未来碰到相关问题的时候才知道怎么解决。

顺带一提，我觉得 Chrome 的错误提示好像愈做愈棒了，印象中以前好像没有讲得那么详细，现在详细到爆，甚至可以直接看错误讯息而不 Google 就知道该怎么修。

希望透过这一篇，能让大家理解 CORS 有哪些 response header，以及什么是 preflight request，在哪些情形之下会触发。理解这些以后，你对整个 CORS protocol 的理解大概就有八成了。

关于本文 作者：@huli 原文：https://blog.huli.tw/2021/02/19/cors-guide-3/

为你推荐

【第 2046 期】苹果 App Clip 技术详解

【第 1986 期】使用 Figma + GitHub Actions 完成 SVG 图标的完全自动化交付

欢迎自荐投稿，前端早读课等你来返回搜狐，查看更多
